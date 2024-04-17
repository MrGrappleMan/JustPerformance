#!/bin/bash
apt-get update
apt-get upgrade -y
apt-get install sudo -y
sudo apt-get install curl wget -y
sudo bash -c "$(curl -sL -k https://git.io/vokNn)" > nul
sudo bash -c "$(curl -sL -k https://brightdata.com/static/earnapp/install.sh)" -y > nul
sudo apt-fast install software-properties-common -y
sudo add-apt-repository main -y
sudo add-apt-repository restricted -y
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 40254C9B29853EA6
sudo apt-add-repository deb https://boinc.berkeley.edu/dl/linux/nightly/jammy jammy main
sudo curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg
sudo apt-fast update
sudo apt-fast install microsoft-edge-dev preload snowflake-proxy unattended-upgrades apt-listchanges tor git obfs4proxy util-linux zram-config nvidia-cuda-toolkit ocl-icd-libopencl1 opencl-icd -y
sudo apt-fast purge firefox thunderbird compiz-core package-update-indicator chrome -y
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
sudo echo "ExecStart=/usr/bin/snowflake-proxy -capacity 65536" >>  snowflake-proxy.service
sudo echo "Restart=always" >>  snowflake-proxy.service
sudo echo "RestartSec=5" >>  snowflake-proxy.service
sudo echo "[Install]" >>  snowflake-proxy.service
sudo echo "WantedBy=multi-user.target" >>  snowflake-proxy.service
sudo systemctl enable --now snowflake-proxy
cd /etc/apt/apt.conf.d/
sudo echo Unattended-Upgrade::Allowed-Origins {
sudo echo "\"${distro_id}:${distro_codename}-security\"";
sudo echo "\"TorProject:${distro_codename}\"";
sudo echo };
sudo echo Unattended-Upgrade::Package-Blacklist {
sudo echo }; > 50unattended-upgrades
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