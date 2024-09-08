# Bruh, dont forgor 💀 to mount yo disk 
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
pacman -Syu base base-devel git
exit
umount -R /mnt
reboot