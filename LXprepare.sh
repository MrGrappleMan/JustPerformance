#!/bin/zsh
netrf() {
    while true; do
        sudo -v
        sleep 240
    done
}
netrf &
NETRFP=$!
sudo swapoff -a
sudorefresh() {
    while true; do
        sudo -v
        sleep 240
    done
}
sudorefresh &
SUDOREFRESHP=$!
sudo touch ~/swapfile
sudo fallocate -l 8G ~/swapfile
sudo chmod 755 ~/swapfile
sudo mkswap ~/swapfile
sudo swapon -p 32765 ~/swapfile
sudo sysctl vm.swappiness=1
# PkgConfigs----------------------------------------------------------------------------------------------------
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo touch /etc/pacman.conf
sudo chmod 755 /etc/pacman.conf
sudo tee /etc/pacman.conf > /dev/null << "XIT"
[options]
HoldPkg = 
CleanMethod = KeepInstalled
Architecture = auto
Color
CheckSpace
DisableDownloadTimeout
VerbosePkgLists
ParallelDownloads = 262144
[core-testing]
Include = /etc/pacman.d/mirrorlist
[extra-testing]
Include = /etc/pacman.d/mirrorlist
[multilib-testing]
Include = /etc/pacman.d/mirrorlist
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
[gnome-unstable]
Include = /etc/pacman.d/mirrorlist
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
XIT
sudo touch /etc/pacman.d/mirrorlist
sudo chmod 755 /etc/pacman.d/mirrorlist
sudo tee /etc/pacman.d/mirrorlist > /dev/null << "XIT"
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
XIT