#!/bin/bash
sudo bash -c "$(curl -sL https://git.io/vokNn)"
sudo apt-fast install software-properties-common -y
sudo add-apt-repository main -y
sudo add-apt-repository restricted -y
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo add-apt-repository ppa:alessandro-strada/google-drive-ocamlfuse-beta -y
sudo add-apt-repository ppa:costamagnagianfranco/boinc -y
sudo add-apt-repository ppa:gezakovacs/ppa -y
sudo apt-fast install preload redshift-gtk snowflake-proxy tor obfs4proxy util-linux zram-config package-update-indicator system-monitoring-center synaptic unetbootin -y
sudo apt-fast purge thunderbird compiz-core -y
sudo systemctl enable --now preload
sudo swapoff /swapfile
cd /usr/bin/
sudo echo '#!/bin/sh' > init-zram-swapping
sudo echo "modprobe zram" >> init-zram-swapping
sudo echo "totalmem=`LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`" >> init-zram-swapping
sudo echo "mem=$((totalmem * 1024))" >> init-zram-swapping
sudo echo "echo $mem > /sys/block/zram0/disksize" >> init-zram-swapping
sudo echo "mkswap /dev/zram0" >> init-zram-swapping
sudo echo "swapon -p 5 /dev/zram0" >> init-zram-swapping
sudo systemctl enable --now zram-config
cd /lib/systemd/system/
sudo echo "[Unit]" >  snowflake-proxy.service
sudo echo "Description=snowflake-proxy" >>  snowflake-proxy.service
sudo echo "Documentation=man:snowflake-proxy" >>  snowflake-proxy.service
sudo echo "Documentation=https://snowflake.torproject.org/" >>  snowflake-proxy.service
sudo echo "After=network-online.target docker.socket firewalld.service" >>  snowflake-proxy.service
sudo echo "Wants=network-online.target" >>  snowflake-proxy.service
sudo echo "[Service]" >>  snowflake-proxy.service
sudo echo "ExecStart=/usr/bin/snowflake-proxy -capacity 128" >>  snowflake-proxy.service
sudo echo "Restart=always" >>  snowflake-proxy.service
sudo echo "RestartSec=5" >>  snowflake-proxy.service
sudo echo "[Install]" >>  snowflake-proxy.service
sudo echo "WantedBy=multi-user.target" >>  snowflake-proxy.service
sudo systemctl enable --now snowflake-proxy
cd /etc/tor/
sudo echo "BridgeRelay 1" > torrc
sudo echo "ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy" >> torrc
sudo echo "ServerTransportListenAddr obfs4 0.0.0.0:9001" >> torrc
sudo echo "ExtORPort auto" >> torrc
sudo echo "ORPort auto" >> torrc
sudo echo "KeepBindCapabilities auto" >> torrc
sudo echo "ExtendByEd25519ID auto" >> torrc
sudo echo "ConnectionPadding auto" >> torrc
sudo echo "RefuseUnknownExits auto" >> torrc
sudo echo "GeoIPExcludeUnknown 0" >> torrc
sudo echo "PreferIPv6Automap" >> torrc
sudo echo "HardwareAccel 1" >> torrc
sudo echo "ClientOnly 0" >> torrc
sudo echo "DNSPort auto" >> torrc
sudo echo "AvoidDiskWrites 0" >> torrc
sudo echo "UseGuardFraction auto" >> torrc
sudo echo "OptimisticData auto" >> torrc
sudo echo "UseMicrodescriptors auto" >> torrc
sudo echo "CacheDirectoryGroupReadable auto" >> torrc
sudo echo "ExitRelay auto" >> torrc
sudo echo "SocksPort auto" >> torrc
sudo echo "KeepBindCapabilities auto" >> torrc
sudo echo "ClientAutoIPv6ORPort 1" >> torrc
sudo echo "DoSCircuitCreationEnabled auto" >> torrc
sudo echo "DoSConnectionEnabled auto" >> torrc
sudo echo "DisableNetwork 0" >> torrc
sudo echo "DisableAllSwap 0" >> torrc
sudo echo "DoSRefuseSingleHopClientRendezvous auto" >> torrc
sudo setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy
cd /etc/systemd/system/
mkdir -p tor@.service.d/ tor@default.service.d/
echo -e "[Service]\nNoNewPrivileges=no" > tor@.service.d/override.conf
echo -e "[Service]\nNoNewPrivileges=no" > tor@default.service.d/override.conf
sudo systemctl enable --now tor
sudo mkdir -v /etc/systemd/system/fstrim.timer.d/
cd /etc/systemd/system/fstrim.timer.d/
sudo echo "[Timer]\nOnCalendar=\nOnCalendar=daily" > override.conf
sudo systemctl enable --now fstrim.timer
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
cd /etc/systemd/t/
echo "[Time]\nNTP=time.google.com\nFallbackNTP=time.windows.com" > timesyncd.conf
sudo apt-fast dist-upgrade -y
cd ~/