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
		sudo nmcli device wifi rescan
		sudo nmcli connection up "$(nmcli -t -f NAME connection show --active | head -n 1)"
    if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
        echo "Connected to the internet."
    else
        echo "Not connected. Trying to reconnect."

        # Try reconnecting to any available network
        sudo nmcli networking off && sudo nmcli networking on

        # Wait a few seconds before rechecking connection
        sleep 5

        if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
            echo "Reconnected to the internet."
        else
            echo "Failed to connect to the internet. Please check your connection."
        fi
    fi
}
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