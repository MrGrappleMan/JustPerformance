#!/bin/zsh
clear
cd
netrf() {
    while true; do
        sudo nmcli device wifi rescan
		sudo nmcli connection up "$(nmcli -t -f NAME connection show --active | head -n 1)"
        sleep 600
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
sudo pacman -Syy base base-devel git
git clone https://aur.archlinux.org/git-git.git
git clone https://aur.archlinux.org/paru-git.git
git clone https://aur.archlinux.org/pacman-git.git
sudo pacman -Rddns --noconfirm pacman git
cd pacman-git
sudo renice -n -20 -p $BASHPID
makepkg -si --noconfirm
sudo renice -n 0 -p $BASHPID
cd
sudo rm -rf ~/pacman-git
cd git-git
sudo renice -n -20 -p $BASHPID
makepkg -si --noconfirm
sudo renice -n 0 -p $BASHPID
cd
sudo rm -rf ~/git-git

kill $SUDOREFRESHP
kill $NETRFP
exit