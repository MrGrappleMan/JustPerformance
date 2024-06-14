clear
echo Procedure will take a long time to complete.
echo Please wait...
apt-get update >/dev/null 2>&1
apt-get install sudo -y >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
for epkg in curl git dkms wget build-essential; do sudo apt install $epkg -y >/dev/null 2>&1; done
sudo /bin/bash -c "$(sudo curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)" >/dev/null 2>&1
sudo /bin/bash -c "$(sudo curl -sL https://brightdata.com/static/earnapp/install.sh)" -y >/dev/null 2>&1
sudo apt-fast update >/dev/null 2>&1
sudo apt-fast install software-properties-common -y >/dev/null 2>&1
sudo add-apt-repository main -y >/dev/null 2>&1
sudo add-apt-repository restricted -y >/dev/null 2>&1
sudo add-apt-repository universe -y >/dev/null 2>&1
sudo add-apt-repository multiverse -y >/dev/null 2>&1
sudo add-apt-repository ppa:graphics-drivers/ppa -y >/dev/null 2>&1
sudo add-apt-repository ppa:kubuntu-ppa/backports -y >/dev/null 2>&1
sudo add-apt-repository ppa:system76-dev/pre-stable -y >/dev/null 2>&1
sudo sh -c 'echo "deb http://archive.neon.kde.org/user focal main" > /etc/apt/sources.list.d/neon.list'
sudo wget -qO - http://archive.neon.kde.org/public.key | sudo apt-key add - >/dev/null 2>&1
sudo apt-fast update >/dev/null 2>&1
for ipkg in systemd ubuntu-drivers-common coreutils flatpak resolvconf nvidia-cuda-toolkit ocl-icd-libopencl1 opencl-icd util-linux plymouth zram-config snowflake-proxy tor obfs4proxy; do sudo apt-fast install $ipkg -y; done
for rpkg in package-update-indicator; do sudo apt-fast remove $rpkg -y --autoremove; done
# Flatpak----------------------------------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1
sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo >/dev/null 2>&1
# ZRAM----------------------------------------------------------------------------------------------------
sudo systemctl enable --now zram-config >/dev/null 2>&1
sudo systemctl stop zram-config >/dev/null 2>&1
cd /usr/bin/
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
# Snowflake----------------------------------------------------------------------------------------------------
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
# Tor----------------------------------------------------------------------------------------------------
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
cd /etc/systemd/system/
sudo mkdir tor@.service.d >/dev/null 2>&1
sudo mkdir tor@default.service.d >/dev/null 2>&1
sudo chmod 777 tor@.service.d tor@default.service.d >/dev/null 2>&1
sudo echo -e '[Service]' > tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf >/dev/null 2>&1
sudo echo -e '[Service]' > tor@default.service.d/override.conf >/dev/null 2>&1
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf >/dev/null 2>&1
sudo systemctl enable --now tor >/dev/null 2>&1
# FS Trim----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/ >/dev/null 2>&1
cd /etc/systemd/system/fstrim.timer.d/
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
# sysctl.conf----------------------------------------------------------------------------------------------------
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
# No Boot Logo----------------------------------------------------------------------------------------------------
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub >/dev/null 2>&1
sudo update-grub >/dev/null 2>&1
# Crontab----------------------------------------------------------------------------------------------------
cat <<EOF | sudo crontab -
*/20 * * * * boinccmd --acct_mgr sync >/dev/null 2>&1
@hourly (sudo apt-fast autoremove >/dev/null 2>&1; sudo apt-fast -f install >/dev/null 2>&1; sudo apt-fast clean >/dev/null 2>&1; sudo apt-fast autoclean >/dev/null 2>&1; sudo apt-fast update >/dev/null 2>&1; sudo apt-fast dist-upgrade >/dev/null 2>&1; sudo ubuntu-drivers autoinstall >/dev/null 2>&1)
EOF
# DNS Setup----------------------------------------------------------------------------------------------------
sudo systemctl enable --now resolvconf >/dev/null 2>&1
sudo systemctl stop resolvconf >/dev/null 2>&1
sudo chmod 777 /etc/resolvconf/resolv.conf.d/base >/dev/null 2>&1
cd /etc/resolvconf/resolv.conf.d/
sudo cat > base << 'EOL'
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 9.9.9.9
nameserver 149.112.112.112
nameserver 208.67.222.222
nameserver 208.67.220.220
nameserver 91.239.100.100
nameserver 89.233.43.71
nameserver 45.33.97.5
nameserver 37.235.1.177
nameserver 94.140.14.140
nameserver 94.140.14.141
nameserver 95.85.95.85
nameserver 2.56.220.2
EOL
sudo systemctl enable --now resolvconf >/dev/null 2>&1
# End----------------------------------------------------------------------------------------------------
clear
echo Done!