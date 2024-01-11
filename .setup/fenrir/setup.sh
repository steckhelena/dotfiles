#!/bin/sh

set -e

# Set NVMe LBA(Last Block Addressing) format
echo "Setting NVMe performance profile..."
nvme format --lbaf=1 /dev/nvme0n1

# 1 boot partition - 1GB - FAT32
# 1 root partition encrypted - the rest - ext4
echo "Formatting disk..."
fdisk /dev/nvme0n1 <<EOF
g
n
1

+1G
t
1
n
2


w
EOF

# Encrypt root partition
echo "Encrypting root partition..."
cryptsetup luksFormat /dev/nvme0n1p2
echo "Opening encrypted partition..."
cryptsetup open /dev/nvme0n1p2 root

# Format partitions
echo "Formatting partitions..."
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/mapper/root

# Mount partitions
echo "Mounting partitions..."
mount /dev/mapper/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot

# Get mirrorlist
echo "Getting mirrorlist..."
reflector \
  --country Brazil,US,DE \
  --sort country \
  --sort score \
  --sort rate \
  --threads 8 \
  --protocol https \
  --number 20 \
  --save /etc/pacman.d/mirrorlist

# Install base system
echo "Installing base system..."
pacstrap /mnt base base-devel linux linux-firmware git vim zsh networkmanager grub curl

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
echo "Chrooting into new system..."
arch-chroot /mnt

# Set timezone
echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Set hardware clock
echo "Setting hardware clock..."
hwclock --systohc

# Set locale
echo "Setting locale..."
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

# Set language
echo "Setting language..."
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set hostname
echo "Setting hostname..."
echo "fenrir" >> /etc/hostname

# Setting hooks
echo "Setting hooks..."
sed -i 's/^HOOKS=.*/HOOKS=(base systemd autodetect kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' /etc/mkinitcpio.conf

# Setting modules
echo "Setting modules..."
sed -i 's/^MODULES=.*/MODULES=(amdgpu)/' /etc/mkinitcpio.conf

# Regenerate initramfs
echo "Regenerating initramfs..."
mkinitcpio -P

# Set root password
echo "Setting root password..."
passwd

# Install grub
echo "Installing grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Set grub config, including the cryptdevice and WQHD resolution
echo "Setting grub config..."
LUKSPARTUUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="quiet splash rd.luks.name='$LUKSPARTUUID'=root root=\/dev\/mapper\/root"/ rd.luks.options=discard/' /etc/default/grub
sed -i 's/^GRUB_GFXMODE=.*/GRUB_GFXMODE=2560x1440/' /etc/default/grub
sed -i 's/^GRUB_GFXPAYLOAD_LINUX=.*/GRUB_GFXPAYLOAD_LINUX=keep/' /etc/default/grub

# Regenerate grub config
echo "Regenerating grub config..."
grub-mkconfig -o /boot/grub/grub.cfg

# Set up pacman, use ILoveCandy
echo "Setting up pacman..."
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
sed -i 's/^#Color/Color\nILoveCandy/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 8/' /etc/pacman.conf

# Install yay
echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Install packages
echo "Installing packages..."
curl 'https://raw.githubusercontent.com/steckhelena/dotfiles/experimental-fenrir/.setup/fenrir/packages' -o .apps
yay -S --noconfirm --needed --removemake - < .apps
rm .apps

# Set up sudo
echo "Setting up sudo..."
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Set up lightdm
echo "Setting up lightdm..."
sed -i 's/^#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf

# Set up lightdm-gtk-greeter
echo "Setting up lightdm-gtk-greeter..."
sed -i 's/^#background=.*/background=\/usr\/share\/backgrounds\/gnome\/gnome-background-default.jpg/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/^#theme-name=.*/theme-name=Kanagawa-Border/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/^#icon-theme-name=.*/icon-theme-name=Kanagawa/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/^#xft-dpi=.*/xft-dpi=120/' /etc/lightdm/lightdm-gtk-greeter.conf

# Set up X11
echo "Setting up X11..."
echo "Section \"Device\"
    Identifier \"AMD\"
    Driver \"amdgpu\"
    Option \"TearFree\" \"true\"
EndSection" > /etc/X11/xorg.conf.d/20-amdgpu.conf
echo "Section \"Monitor\"
    Identifier \"Monitor0\"
    Modeline \"3840x2160_144.00\"  1252.81 3840 3848 3880 3960 2160 2165 2173 2197 +hsync +vsync
    Option \"PreferredMode\" \"3840x2160_144.00\"
EndSection

Section \"Screen\"
    Identifier \"Screen0\"
    Monitor \"Monitor0\"
    DefaultDepth 24
    SubSection \"Display\"
        Depth 24
        Modes \"3840x2160_144.00\"
    EndSubSection
EndSection" > /etc/X11/xorg.conf.d/10-monitor.conf

# Enable services
echo "Enabling services..."
systemctl enable lightdm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable xsettingsd.service
systemctl enable fstrim.timer

# Set up user
echo "Setting up user..."
useradd -m -G wheel -s /bin/zsh steckhelena

# Set up zsh
echo "Setting up zsh..."
sudo -u steckhelena sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set up dotfiles
echo "Setting up dotfiles..."
sudo -u steckhelena git init
sudo -u steckhelena git remote add origin https://github.com/steckhelena/dotfiles
sudo -u steckhelena git fetch
sudo -u steckhelena git reset origin/master --hard
sudo -u steckhelena git submodule init

# Adding wallpaper folders
echo "Adding wallpaper folders..."
sudo -u steckhelena mkdir -p .wallpaper
mkdir -p /usr/share/lightdmwallpaper
chown -R steckhelena:steckhelena /usr/share/lightdmwallpaper
chmod -R a+r /usr/share/lightdmwallpaper

# Reboot
echo "Rebooting..."
exit
umount -R /mnt
reboot
