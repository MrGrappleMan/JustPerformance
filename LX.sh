sudo apt update
sudo apt install curl wget -y
sudo /bin/bash -c "$(sudo curl -sL https://git.io/vokNn)"
sudo /bin/bash -c "$(sudo curl -sL https://brightdata.com/static/earnapp/install.sh)" -y > nul
sudo apt-fast update
sudo apt-fast install software-properties-common -y
sudo add-apt-repository main -y
sudo add-apt-repository restricted -y
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 40254C9B29853EA6
sudo apt-add-repository deb https://boinc.berkeley.edu/dl/linux/nightly/jammy jammy main -y
sudo curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg
sudo apt-fast update
sudo apt-fast install zsh microsoft-edge-dev cpufrequtils coreutiles preload snowflake-proxy tor git obfs4proxy util-linux zram-config unattended-upgrades -y
sudo apt-fast purge firefox thunderbird -y
sudo systemctl enable --now preload
sudo systemctl enable --now unattended-upgrades
sudo systemctl enable --now zram-config
sudo systemctl enable --now tor
sudo systemctl stop zram-config
cd /usr/bin/
cat > file << 'EOL'
#!/bin/sh
modprobe zram
totalmem=`LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`
mem=$((totalmem * 1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 16 /dev/zram0
EOL
cd /lib/systemd/system/
cat > snowflake-proxy.service << 'EOL'
[Unit]
Description=snowflake-proxy
Documentation=man:snowflake-proxy
Documentation=https://snowflake.torproject.org/
After=network-online.target docker.socket firewalld.service
Wants=network-online.target
[Service]
ExecStart=/usr/bin/snowflake-proxy -capacity 65536
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
EOL
sudo systemctl enable --now snowflake-proxy
cd /etc/tor/
sudo systemctl stop tor
cat > torrc << 'EOL'
BridgeRelay 1" > torrc
ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy
ServerTransportListenAddr obfs4 0.0.0.0:9001
ExtORPort auto
ORPort auto
KeepBindCapabilities auto
ExtendByEd25519ID auto
ConnectionPadding auto
RefuseUnknownExits auto
GeoIPExcludeUnknown 0
PreferIPv6Automap
HardwareAccel 1
ClientOnly 0
DNSPort auto
AvoidDiskWrites 0
UseGuardFraction auto
OptimisticData auto
UseMicrodescriptors auto
CacheDirectoryGroupReadable auto
ExitRelay auto
SocksPort auto
KeepBindCapabilities auto
ClientAutoIPv6ORPort 1
DoSCircuitCreationEnabled auto
DoSConnectionEnabled auto
DisableNetwork 0
DisableAllSwap 0
DoSRefuseSingleHopClientRendezvous auto
EOL
sudo setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy
cd /etc/systemd/system/
mkdir -p tor@.service.d/ tor@default.service.d/
sudo echo -e '[Service]' > tor@.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf
sudo echo -e '[Service]' > tor@default.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf
sudo systemctl enable --now tor
sudo mkdir -v /etc/systemd/system/fstrim.timer.d/
cd /etc/systemd/system/fstrim.timer.d/
sudo echo '[Timer]' > override.conf
sudo echo "OnCalendar=\nOnCalendar=daily" >> override.conf
sudo systemctl enable --now fstrim.timer
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
cd /etc/systemd/t/
sudo echo '[Time]' > timesyncd.conf
sudo echo "NTP=time.google.com\nFallbackNTP=time.windows.com" >> timesyncd.conf
cd ~/
clear
echo Done!
