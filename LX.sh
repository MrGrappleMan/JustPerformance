#!/bin/zsh
clear
cd
sudorefresh() {
    while true; do
        sudo -v
        sleep 60
    done
}
sudorefresh &
SUDOREFRESHP=$!
sudo swapoff -a
sudo rmmod zram
sudo fallocate -l 8G ~/swapfile
sudo chmod 777 ~/swapfile
sudo mkswap /swapfile
sudo swapon -p 32765 ~/swapfile
sudo sysctl vm.swappiness=1
# PackageMgmt---------------------------------------------------------------------------------------------------- 
sudo touch /etc/pacman.conf
sudo chmod 777 /etc/pacman.conf
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
[extra-testing]
Include = /etc/pacman.d/mirrorlist
[multilib-testing]
Include = /etc/pacman.d/mirrorlist
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
[gnome-unstable]
Include = /etc/pacman.d/mirrorlist
XIT
sudo rm -rf /var/lib/pacman/db.lck /var/cache/pacman/pkg/* ~/paru-git
sudo pacman -Syy --noconfirm base-devel git
git clone https://aur.archlinux.org/paru-git.git
cd paru-git
renice -n -20 -p $$
makepkg -si --noconfirm
renice -n 0 -p $$
cd
sudo touch /etc/paru.conf
sudo chmod 777 /etc/paru.conf
sudo cat > /etc/paru.conf << "XIT"
[options]
PgpFetch
Devel
Provides
DevelSuffixes = -git -cvs -svn -bzr -darcs -always -hg -fossil
CompletionInterval = 0
SudoLoop
SkipReview
[bin]
Makepkg = /usr/bin/nice -n -20 /usr/bin/makepkg "$@"
SudoFlags = -v
XIT
rm -rf paru-git
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
paru -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
paru -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
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
[extra-testing]
Include = /etc/pacman.d/mirrorlist
[multilib-testing]
Include = /etc/pacman.d/mirrorlist
[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
[gnome-unstable]
Include = /etc/pacman.d/mirrorlist
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
XIT
sudo touch /etc/pacman.d/mirrorlist
sudo chmod 777 /etc/pacman.d/mirrorlist
sudo cat /etc/pacman.d/mirrorlist << "XIT"
#
# Arch Linux repository mirrorlist
# Generated on 2024-08-14
#
# Worldwide
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
XIT
# PackageInst----------------------------------------------------------------------------------------------------
for pakges in\
 linux-xanmod-edge linux-xanmod-edge-headers ramroot-btrfs\
 pipewire-git libpipewire-git wireplumber-git libwireplumber-git\
 paru-git mc-git pi-hole-standalone snowflake-pt-proxy boinc-nox
#  hyprland-git eww-git flatpak
do paru -Syu --noconfirm $pakges
done
for pakgis in\
 linux linux-headers
do paru -Rns --noconfirm $pakgis
done
sudo bootctl update #SystemD-Boot
sudo grub-mkconfig -o /boot/grub/grub.cfg #GRUB
if [[ "$1" == "N" ]]; then
 paru -Syu --noconfirm nvidia-open-dkms-git opencl-nvidia-beta nvidia-utils-beta nvidia-settings-beta nvidia-vpf-git nvflash
fi
if [[ "$1" == "A" ]]; then
 paru -Syu --noconfirm opencl-amd-dev amdvbflash
fi
# ZRAMnRamRoot----------------------------------------------------------------------------------------------------
sudo touch /usr/bin/JPzram
sudo chmod 777 /usr/bin/JPzram
sudo cat > /usr/bin/JPzram > /dev/null << "XIT" 
#!/bin/sh
swapoff -a
rmmod zram
if [[ "$1" == "Y" ]]; then
modprobe zram
mem=$(((`LC_ALL=C free | grep -e "^Mem:" | sed -e 's/^Mem: *//' -e 's/  *.*//'`)*1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 32765 /dev/zram0
fi
XIT
sudo touch /lib/systemd/system/JPzram.service
sudo chmod 777 /lib/systemd/system/JPzram.service
sudo cat > /lib/systemd/system/JPzram.service > /dev/null << "XIT" 
[Unit]
Description=
Before=systemd-oomd.service

[Service]
ExecStart=/usr/bin/JPzram Y
ExecStop=/usr/bin/JPzram
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
XIT
sudo systemctl enable --now JPzram
sudo ramroot -CEY
# Flatpak----------------------------------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Pi-Hole----------------------------------------------------------------------------------------------------
sudo touch /etc/pihole/pihole-FTL.conf
sudo chmod 777 /etc/pihole/pihole-FTL.conf
sudo cat > /etc/pihole/pihole-FTL.conf > /dev/null << "XIT" 
RATE_LIMIT=0/0
XIT
sudo touch /etc/pihole/adlists.list
sudo chmod 777 /etc/pihole/adlists.list
sudo cat > /etc/pihole/adlists.list > /dev/null << "XIT" 
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts
https://v.firebog.net/hosts/static/w3kbl.txt
https://adaway.org/hosts.txt
https://v.firebog.net/hosts/AdguardDNS.txt
https://v.firebog.net/hosts/Admiral.txt
https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt
https://v.firebog.net/hosts/Easylist.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts
https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts
https://v.firebog.net/hosts/Easyprivacy.txt
https://v.firebog.net/hosts/Prigent-Ads.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt
https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt
https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt
https://v.firebog.net/hosts/Prigent-Crypto.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts
https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt
https://phishing.army/download/phishing_army_blocklist_extended.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
https://v.firebog.net/hosts/RPiList-Malware.txt
https://v.firebog.net/hosts/RPiList-Phishing.txt
https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt
https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts
https://urlhaus.abuse.ch/downloads/hostfile/
XIT
sudo systemctl enable --now pihole-FTL
sudo pihole restartdns
# Snowflake----------------------------------------------------------------------------------------------------
sudo touch /lib/systemd/system/snowflake-proxy.service
sudo chmod 777 /lib/systemd/system/snowflake-proxy.service
sudo cat > /lib/systemd/system/snowflake-proxy.service > /dev/null << "XIT" 
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
sudo touch /etc/tor/torrc
sudo chmod 777 /etc/tor/torrc
sudo cat > /etc/tor/torrc > /dev/null << "XIT" 
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
sudo touch /etc/systemd/system/fstrim.timer.d/override.conf
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf
sudo cat > /etc/systemd/system/fstrim.timer.d/override.conf > /dev/null << "XIT" 
[Timer]
OnCalendar=
OnCalendar=daily
XIT
sudo systemctl enable --now fstrim.timer
sudo touch /etc/systemd/timesyncd.conf
sudo chmod 777 /etc/systemd/timesyncd.conf
sudo cat > /etc/systemd/timesyncd.conf > /dev/null << "XIT" 
[Time]
NTP=pool.ntp.org
NTP=time.cloudflare.com
NTP=time.google.com
NTP=time.windows.com
NTP=time.facebook.com
NTP=time.apple.com
XIT
# sysctl.conf----------------------------------------------------------------------------------------------------
sudo touch /etc/sysctl.conf
sudo chmod 777 /etc/sysctl.conf
sudo cat > /etc/sysctl.conf > /dev/null << "XIT" 
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
sudo touch /etc/systemd/resolved.conf
sudo chmod 777 /etc/systemd/resolved.conf
sudo cat > /etc/systemd/resolved.conf > /dev/null << "XIT" 
[Resolve]
DNS=dot-sg.blahdns.com
DNS=dot-de.blahdns.com
DNS=p2.freedns.controld.com
DNS=base.dns.mullvad.net
DNS=dns.adguard.com
DNS=one.one.one.one
DNS=dns.quad9.net
DNS=dns.google
DNSSEC=no
DNSOverTLS=yes
Domains=~.
XIT
sudo systemctl enable --now systemd-resolved
sudo systemctl enable --now systemd-networkd
# End----------------------------------------------------------------------------------------------------
kill $SUDOREFRESHP
echo Done