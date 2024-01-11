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
pacstrap /mnt base base-devel linux linux-firmware git vim zsh networkmanager grub curl cryptsetup sudo

# Generate fstab
echo "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into new system
echo "Chrooting into new system..."
arch-chroot /mnt /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/steckhelena/dotfiles/experimental-fenrir/.setup/fenrir/setup-chroot.sh)"

# Reboot
echo "Rebooting..., press any key to continue"
read -n 1 -s
sleep 5
umount -R /mnt
reboot
