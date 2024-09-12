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
kill $SUDOREFRESHP
kill $NETRFP
exit