#!/bin/sh

set -e

change_password() {
    local user=$1
    local max_attempts=5
    local attempt=0

    while [ $attempt -lt $max_attempts ]; do
        if passwd $user; then
            echo "Password changed successfully for $user."
            return 0
        else
            echo "Passwords did not match. Please try again."
            attempt=$((attempt + 1))
        fi
    done

    echo "Maximum number of attempts reached for $user."
    return 1
}


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
touch /etc/vconsole.conf # needed for mkinitcpio
sed -i 's/^HOOKS=.*/HOOKS=(base systemd autodetect kms keyboard sd-vconsole block sd-encrypt filesystems fsck)/' /etc/mkinitcpio.conf

# Setting modules
echo "Setting modules..."
sed -i 's/^MODULES=.*/MODULES=(amdgpu)/' /etc/mkinitcpio.conf

# Regenerate initramfs
echo "Regenerating initramfs..."
mkinitcpio -P

# Set root password
echo "Setting root password..."
change_password root

# Install grub
echo "Installing grub..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Set grub config, including the cryptdevice and WQHD resolution
echo "Setting grub config..."
LUKSPARTUUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="quiet splash rd.luks.name='$LUKSPARTUUID'=root root=\/dev\/mapper\/root rd.luks.options=discard"/' /etc/default/grub
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

# Download multlib database
echo "Downloading multilib database..."
pacman -Sy

# Set up user
echo "Setting up user..."
useradd -m -G wheel -s /bin/zsh steckhelena

# Change user password
echo "Changing user password..."
change_password steckhelena

# Set up sudo
echo "Setting up sudo..."
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Install yay, makepkg can't run as root so we need to do this as the user
echo "Installing yay..."
cd /home/steckhelena
sudo -u steckhelena git clone https://aur.archlinux.org/yay.git
cd yay
sudo -u steckhelena makepkg -si --noconfirm
cd ..
sudo -u steckhelena rm -rf yay

# Install packages
echo "Installing packages..."
sudo -u steckhelena curl 'https://raw.githubusercontent.com/steckhelena/dotfiles/experimental-fenrir/.setup/fenrir/packages' -o .apps
sudo -u steckhelena yay -S --noconfirm --needed --removemake - < .apps
sudo -u steckhelena rm .apps

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
sudo -u steckhelena systemctl --user enable xsettingsd.service

# Set up dotfiles
echo "Setting up dotfiles..."
sudo -u steckhelena git init
sudo -u steckhelena git remote add origin https://github.com/steckhelena/dotfiles
sudo -u steckhelena git fetch
sudo -u steckhelena git reset origin/master --hard
sudo -u steckhelena git submodule init

# Set up zsh
echo "Setting up zsh..."
sudo -u steckhelena sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Adding wallpaper folders
echo "Adding wallpaper folders..."
sudo -u steckhelena mkdir -p .wallpaper
mkdir -p /usr/share/lightdmwallpaper
chown -R steckhelena:steckhelena /usr/share/lightdmwallpaper
chmod -R a+r /usr/share/lightdmwallpaper

exit
