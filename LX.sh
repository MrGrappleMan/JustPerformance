clear
echo Procedure will take a longtime to complete.
echo Please wait...
apt update >/dev/null 2>&1
apt install sudo -y >/dev/null 2>&1
sudo apt update >/dev/null 2>&1
sudo apt install curl git wget -y >/dev/null 2>&1
sudo /bin/bash -c "$(sudo curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)" >/dev/null 2>&1
sudo /bin/bash -c "$(sudo curl -sL https://brightdata.com/static/earnapp/install.sh)" -y >/dev/null 2>&1
sudo apt-fast update >/dev/null 2>&1
sudo apt-fast install software-properties-common -y >/dev/null 2>&1
sudo add-apt-repository main -y >/dev/null 2>&1
sudo add-apt-repository restricted -y >/dev/null 2>&1
sudo add-apt-repository universe -y >/dev/null 2>&1
sudo add-apt-repository multiverse -y >/dev/null 2>&1
sudo apt-fast update >/dev/null 2>&1
sudo apt-fast install coreutils unattended-upgrades util-linux zram-config snowflake-proxy tor obfs4proxy -y >/dev/null 2>&1
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker container package-update-indicator runc; do sudo apt-get remove $pkg; done
cd /tmp/ >/dev/null 2>&1
curl -fsSL https://test.docker.com -o dck.sh >/dev/null 2>&1
sudo sh dck.sh >/dev/null 2>&1
sudo systemctl enable --now docker >/dev/null 2>&1
sudo docker run -d --name mgmpsclient -e CID=69eg packetstream/psclient:latest >/dev/null 2>&1
sudo docker run -d --name mgmearnfm-client -e EARNFM_TOKEN="a0d3ff10-5d3c-4c24-a80a-d0c0120ddf76" earnfm/earnfm-client:latest >/dev/null 2>&1
# ----------------------------------------------------------------------------------------------------
sudo systemctl enable --now zram-config >/dev/null 2>&1
sudo systemctl stop zram-config >/dev/null 2>&1
cd /usr/bin/ >/dev/null 2>&1
sudo chmod 777 /usr/bin/init-zram-swapping >/dev/null 2>&1
sudo cat > init-zram-swapping << 'EOL'
#!/bin/sh
modprobe zram
totalmem=`LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`
mem=$((totalmem * 1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 32764 /dev/zram0
EOL
sudo systemctl enable --now zram-config >/dev/null 2>&1
# ----------------------------------------------------------------------------------------------------
cd /lib/systemd/system/ >/dev/null 2>&1
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
ORPort auto
ExitRelay 0
SocksPort 0
BridgeRelay 1
ServerTransportPlugin obfs4 exec /usr/bin/obfs4proxy
ServerTransportListenAddr obfs4 0.0.0.0:9001
ExtORPort auto
AvoidDiskWrites 0
BandwidthBurst 16 TBytes
BandwidthRate 16 TBytes
ConnLimit 2048
DisableOOSCheck 0
DisableDebuggerAttachment 1
DisableAllSwap 0
DisableNetwork 0
ExtendByEd25519ID 1
FetchDirInfoEarly 1
FetchHidServDescriptors 1
FetchServerDescriptors 1
FetchUselessDescriptors 0
HardwareAccel 1
KeepBindCapabilities 1
NoExec 0
ClientPreferIPv6DirPort 1
ClientPreferIPv6ORPort 1
ClientUseIPv6 1
DownloadExtraInfo 1
IPv6Exit 1
DirCache 1
EOL
sudo setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy >/dev/null 2>&1
cd /etc/systemd/system/ >/dev/null 2>&1
sudo mkdir tor@.service.d >/dev/null 2>&1
sudo mkdir tor@default.service.d >/dev/null 2>&1
sudo chmod 777 tor@.service.d tor@default.service.d >/dev/null 2>&1
sudo echo -e '[Service]' > tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e '[Service]' > tor@default.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf >/dev/null 2>&1
sudo systemctl enable --now tor >/dev/null 2>&1
# ----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/ >/dev/null 2>&1
cd /etc/systemd/system/fstrim.timer.d/ >/dev/null 2>&1
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf >/dev/null 2>&1
sudo cat > override.conf << 'EOL'
[Timer]
OnCalendar=
OnCalendar=daily
EOL
sudo systemctl enable --now fstrim.timer >/dev/null 2>&1
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf >/dev/null 2>&1
cd /etc/systemd/
sudo chmod 777 /etc/systemd/timesyncd.conf >/dev/null 2>&1
sudo cat > timesyncd.conf << 'EOL'
[Time]
NTP=time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com pool.ntp.org
FallbackNTP=time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com pool.ntp.org
EOL
# ----------------------------------------------------------------------------------------------------
cd /etc/ >/dev/null 2>&1
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
# ----------------------------------------------------------------------------------------------------u
/etc/apt/apt.conf.d/
# ----------------------------------------------------------------------------------------------------
sudo apt-fast update >/dev/null 2>&1
sudo apt-fast dist-upgrade -y >/dev/null 2>&1
cd
clear
echo Done!
