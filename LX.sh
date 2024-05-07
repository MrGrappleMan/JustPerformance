cd /tmp/
clear
apt update
apt install sudo -y
sudo apt update
sudo apt install curl wget -y
sudo /bin/bash -c "$(sudo curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"
sudo /bin/bash -c "$(sudo curl -sL https://brightdata.com/static/earnapp/install.sh)" -y >/dev/null 2>&1
sudo apt-fast update
sudo apt-fast install software-properties-common -y
sudo add-apt-repository main -y
sudo add-apt-repository restricted -y
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo add-apt-repository partner -y
sudo apt-fast update
sudo apt-fast install microsoft-edge-dev coreutils util-linux synaptic zram-config -y
sudo apt-fast install snowflake-proxy tor obfs4proxy -y >/dev/null 2>&1
sudo apt-fast purge package-update-indicator -y
# ----------------------------------------------------------------------------------------------------
sudo swapoff /swapfile
sudo systemctl enable --now zram-config
sudo systemctl stop zram-config
cd /usr/bin/
sudo chmod 777 /usr/bin/init-zram-swapping >/dev/null 2>&1
sudo cat > init-zram-swapping << 'EOL'
#!/bin/sh
modprobe zram
totalmem=`LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`
mem=$((totalmem * 1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 64 /dev/zram0
EOL
sudo systemctl enable --now zram-config
# ----------------------------------------------------------------------------------------------------
cd /lib/systemd/system/
sudo chmod 777 /lib/systemd/system/snowflake-proxy.service >/dev/null 2>&1
sudo cat > snowflake-proxy.service << 'EOL'
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
sudo systemctl enable --now snowflake-proxy >/dev/null 2>&1
# ----------------------------------------------------------------------------------------------------
sudo systemctl enable --now tor >/dev/null 2>&1
sudo systemctl stop tor >/dev/null 2>&1
cd /etc/tor/
sudo chmod 777 /etc/tor/torrc >/dev/null 2>&1
sudo cat > torrc << 'EOL'
BridgeRelay 1
ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy
ServerTransportListenAddr obfs4 0.0.0.0:9001
ExtORPort auto
ORPort auto
KeepBindCapabilities auto
ExtendByEd25519ID auto
ConnectionPadding auto
RefuseUnknownExits auto
GeoIPExcludeUnknown 0
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
sudo setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy >/dev/null 2>&1
cd /etc/systemd/system/
sudo mkdir tor@.service.d >/dev/null 2>&1
sudo mkdir tor@default.service.d >/dev/null 2>&1
sudo chmod 777 tor@.service.d tor@default.service.d >/dev/null 2>&1
sudo echo -e '[Service]' > tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e '[Service]' > tor@default.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf >/dev/null 2>&1
sudo systemctl enable --now tor >/dev/null 2>&1
# ----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/
cd /etc/systemd/system/fstrim.timer.d/
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf >/dev/null 2>&1
sudo cat > override.conf << 'EOL'
[Timer]
OnCalendar=
OnCalendar=daily
EOL
sudo systemctl enable --now fstrim.timer
# ----------------------------------------------------------------------------------------------------
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
cd /etc/systemd/
sudo chmod 777 /etc/systemd/timesyncd.conf >/dev/null 2>&1
sudo cat > timesyncd.conf << 'EOL'
[Time]
NTP=time.google.com
FallbackNTP=time.windows.com
EOL
# ----------------------------------------------------------------------------------------------------
cd /etc/
sudo chmod 777 /etc/sysctl.conf >/dev/null 2>&1
sudo cat > sysctl.conf << 'EOL'
vm.vfs_cache_pressure = 50
vm.dirty_background_ratio = 1
vm.dirty_ratio = 1
vm.dirty_writeback_centisecs = 100
vm.dirty_expire_centisecs = 100
zswap.enabled = 0
vm.swappiness = 200
vm.max_map_count = 2147483647
fs.file-max = 9223372036800000000
net.core.wmem_default = 31457280
net.core.rmem_default = 31457280
net.core.wmem_max = 999999999
net.core.rmem_max = 999999999
net.core.somaxconn = 2147483647
net.core.netdev_max_backlog = 999999999
net.core.optmem_max = 999999999
net.ipv4.tcp_mem = 65536 9999999999999999999 9999999999999999999
net.ipv4.udp_mem = 65536 9999999999999999999 9999999999999999999
net.ipv4.tcp_rmem = 16384 1999999999 1999999999
net.ipv4.tcp_wmem = 16384 1999999999 1999999999
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_low_latency = 1
kernel.sched_migration_cost_ns = 5000000
EOL
# ----------------------------------------------------------------------------------------------------
cd
clear
echo Done!
