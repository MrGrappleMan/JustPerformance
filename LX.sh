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
sudo apt-fast install zsh microsoft-edge-dev cpufrequtils coreutils snowflake-proxy tor git obfs4proxy util-linux zram-config unattended-upgrades apt-listchanges -y
sudo apt-fast purge firefox chrome thunderbird -y
# ----------------------------------------------------------------------------------------------------
sudo systemctl enable --now unattended-upgrades
sudo systemctl stop unattended-upgrades
cd /etc/apt/apt.conf.d/
sudo chmod 777 /etc/apt/apt.conf.d/50unattended-upgrades
sudo cat > 50unattended-upgrades << 'EOL'
Unattended-Upgrade::Allowed-Origins {
	"${distro_id}:${distro_codename}";
	"${distro_id}:${distro_codename}-security";
	"${distro_id}ESMApps:${distro_codename}-apps-security";
	"${distro_id}ESM:${distro_codename}-infra-security";
	"${distro_id}:${distro_codename}-updates";
	"${distro_id}:${distro_codename}-proposed";
	"${distro_id}:${distro_codename}-backports";
	"TorProject:${distro_codename}";
};
Unattended-Upgrade::Package-Blacklist {
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::DevRelease "auto";
Unattended-Upgrade::MinimalSteps "false";
Unattended-Upgrade::InstallOnShutdown "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::SyslogEnable "false";
Unattended-Upgrade::Skip-Updates-On-Metered-Connections "true";
Unattended-Upgrade::Allow-downgrade "false";
Unattended-Upgrade::Verbose "false";
Unattended-Upgrade::Debug "false";
EOL
sudo chmod 777 /etc/apt/apt.conf.d/20auto-upgrades
sudo cat > 20auto-upgrades << 'EOL'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::AutocleanInterval "1";
APT::Periodic::Unattended-Upgrade "1";
EOL
sudo systemctl enable --now unattended-upgrades
# ----------------------------------------------------------------------------------------------------
sudo swapoff /swapfile
sudo systemctl enable --now zram-config
sudo systemctl stop zram-config
cd /usr/bin/
sudo chmod 777 /usr/bin/init-zram-swapping
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
sudo chmod 777 /lib/systemd/system/snowflake-proxy.service
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
sudo systemctl enable --now snowflake-proxy
# ----------------------------------------------------------------------------------------------------
sudo systemctl enable --now tor
sudo systemctl stop tor
cd /etc/tor/
sudo chmod 777 /etc/tor/torrc
sudo cat > torrc << 'EOL'
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
sudo mkdir tor@.service.d
sudo mkdir tor@default.service.d
sudo chmod 777 tor@.service.d tor@default.service.d
sudo echo -e '[Service]' > tor@.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf
sudo echo -e '[Service]' > tor@default.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf
sudo systemctl enable --now tor
# ----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/
cd /etc/systemd/system/fstrim.timer.d/
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf
sudo cat > override.conf << 'EOL'
[Timer]
OnCalendar=
OnCalendar=daily
EOL
sudo systemctl enable --now fstrim.timer
# ----------------------------------------------------------------------------------------------------
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
cd /etc/systemd/
sudo chmod 777 /etc/systemd/timesyncd.conf
sudo cat > timesyncd.conf << 'EOL'
[Time]
NTP=time.google.com
FallbackNTP=time.windows.com
EOL
# ----------------------------------------------------------------------------------------------------
cd /etc/
sudo chmod 777 /etc/sysctl.conf
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
sudo apt-fast autoremove -y
cd ~/
clear
echo Done!
