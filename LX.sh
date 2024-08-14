#!/bin/zsh
clear
sudo pacman -Syu --noconfirm base-devel git
# Paru----------------------------------------------------------------------------------------------------
git clone https://aur.archlinux.org/paru-git.git /tmp/paru-git
cd /tmp/paru-git
makepkg -si --noconfirm
sudo cat > /etc/paru.conf << "XIT"
[options]
PgpFetch
Devel
Provides
DevelSuffixes = -git -cvs -svn -bzr -darcs -always -hg -fossil
CompletionInterval = 1
SudoLoop
SkipReview
XIT
# Chaotic-AUR----------------------------------------------------------------------------------------------------
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
paru -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
paru -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
# Pacman----------------------------------------------------------------------------------------------------
sudo cat > /etc/pacman.conf << "XIT"
[options]
HoldPkg = pacman glibc paru-git
CleanMethod = KeepInstalled
Architecture = auto
Color
CheckSpace
DisableDownloadTimeout
VerbosePkgLists
ParallelDownloads = 262144
[core-testing]
Include = /etc/pacman.d/mirrorlist
[core]
Include = /etc/pacman.d/mirrorlist
[extra-testing]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib-testing]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
XIT
paru -Syu --noconfirm\
 linux-xanmod-edge linux-xanmod-edge-headers zram-generator ramroot-btrfs\
 pipewire-git libpipewire-git wireplumber-git libwireplumber-git\
 hyprland-git eww-git\
 flatpak paru-git pi-hole-standalone snowflake-pt-proxy\
# nvidia-open-dkms-git opencl-nvidia-beta nvidia-utils-beta nvidia-settings-beta nvidia-vpf-git nvflash
# opencl-amd-dev amdvbflash
# ZRAM----------------------------------------------------------------------------------------------------
cat > /usr/bin/JPzram << "XIT"
#!/bin/zsh
if [[ "$1" == "Y" ]]; then
 modprobe zram
 mem=$(((LC_ALL=C free | grep -e "^Mem:" | sed -e "s/^Mem: *//" -e "s/  *.*//") * 1024))
 echo $mem > /sys/block/zram0/disksize
 mkswap /dev/zram0
 swapon -p 32764 /dev/zram0
fi
if [[ "$1" == "N" ]]; then
 if DEVICES=$(grep zram /proc/swaps | awk '{print $1}'); then
   for i in $DEVICES; do
     swapoff $i
   done
 fi
 rmmod zram
fi
XIT
cat > /lib/systemd/system/JPzram.service << "XIT"
[Unit]
Description=
Before=systemd-oomd.service

[Service]
ExecStart=/usr/bin/JPzram Y
ExecStop=/usr/bin/JPzram N
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
XIT
# Flatpak----------------------------------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Pi-Hole----------------------------------------------------------------------------------------------------
sudo systemctl enable --now pihole-FTL
sudo systemctl stop pihole-FTL
sudo tee /etc/dnsmasq.d/02-custom.conf <<EOF
listen-address=127.0.0.1
bind-interfaces
EOF
sudo systemctl enable --now pihole-FTL
sudo pihole restartdns
# Snowflake----------------------------------------------------------------------------------------------------
sudo cat > /lib/systemd/system/snowflake-proxy.service << "XIT"
[Service]
ExecStart=/usr/bin/snowflake-proxy -capacity 0 -allow-non-tls-relay
Restart=always
RestartSec=5
DynamicUser=true
NoNewPrivileges=true
PrivateTmp=true
PrivateDevices=true
PrivateMounts=true
PrivateIPC=true
ProtectHome=true
ProtectControlGroups=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectKernelLogs=true
ProtectProc=invisible
ProtectHostname=true
ProtectClock=true
ProtectSystem=strict
MemoryDenyWriteExecute=true
RestrictRealtime=true
[Install]
WantedBy=multi-user.target
XIT
sudo systemctl enable --now snowflake-proxy
# Tor----------------------------------------------------------------------------------------------------
sudo cat > /etc/tor/torrc << "XIT"
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
XIT
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
# FS Trim----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/
cd /etc/systemd/system/fstrim.timer.d/
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf
sudo cat > override.conf << 'EOL'
[Timer]
OnCalendar=
OnCalendar=daily
EOL
sudo systemctl enable --now fstrim.timer
sudo sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
cd /etc/systemd/
sudo chmod 777 /etc/systemd/timesyncd.conf
sudo cat > timesyncd.conf << "XIT
[Time]
NTP=pool.ntp.org time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com
FallbackNTP=pool.ntp.org time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com
XIT
# sysctl.conf----------------------------------------------------------------------------------------------------
sudo cat > sysctl.conf << "XIT"
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
XIT
# DNS Setup----------------------------------------------------------------------------------------------------
sudo cat > /etc/resolvconf/resolv.conf.d/base << "XIT"
nameserver 2.56.220.2
XIT
sudo systemctl enable --now resolvconf
# End----------------------------------------------------------------------------------------------------
clear
echo Done!
