#!/bin/zsh
clear
sudo pacman -Syu --noconfirm base-devel powerpill flatpak git
# Paru----------------------------------------------------------------------------------------------------
cd
git clone https://aur.archlinux.org/paru-git.git /tmp/paru-git
cd /tmp/paru-git
makepkg -si --noconfirm
sudo cat > /etc/paru.conf << "XIT"
[options]
PgpFetch
Devel
Provides
DevelSuffixes = -git -cvs -svn -bzr -darcs -always -hg -fossil
CleanAfter
SudoLoop
CompletionInterval = 1
SaveChanges
CombinedUpgrade
PacmanBin = /usr/bin/powerpill
XIT
# Powerpill----------------------------------------------------------------------------------------------------
sudo cat > /etc/powerpill/powerpill.json << "XIT"
{
  "aria2": {
    "args": [
	"--no-conf",
      "--allow-overwrite=true",
      "--always-resume=false",
      "--auto-file-renaming=true",
      "--check-integrity=true",
      "--conditional-get=true",
      "--continue=true",
      "--file-allocation=falloc",
      "--log-level=error",
      "--max-concurrent-downloads=262144",
      "--max-connection-per-server=262144",
      "--min-split-size=5M",
      "--remote-time=true",
      "--show-console-readout=true"
    ],
    "path": "/usr/bin/aria2c"
  },
  "pacman": {
    "config": "/etc/pacman.conf",
    "path": "/usr/bin/pacman"
  },
  "pacserve": {
    "server": null
  },
  "powerpill": {
    "select": true,
    "reflect databases": false
  },
  "reflector": {
    "args.unused": [
      "--protocol",
      "http",
      "--latest",
      "50"
    ]
  },
  "rsync": {
    "args": [
      "--no-motd",
      "--progress"
    ],
    "db only": true,
    "path": "/usr/bin/rsync",
    "servers": 
    [
	"rsync://mirror.csclub.uwaterloo.ca/archlinux/$repo/os/$arch",
	"rsync://rsync.localmsp.org/arch/$repo/os/$arch",
	"rsync://lug.mtu.edu/archlinux/$repo/os/$arch",
	"rsync://mirrors.kernel.org/archlinux/$repo/os/$arch",
	"rsync://mirror.lty.me/archlinux/$repo/os/$arch",
	"rsync://archlinux.polymorf.fr/archlinux/$repo/os/$arch",
	"rsync://mirror.js-webcoding.de/pub/archlinux/$repo/os/$arch",
	"rsync://ftp.nluug.nl/archlinux/$repo/os/$arch",
	"rsync://mirror.de.leaseweb.net/archlinux/$repo/os/$arch",
	"rsync://mirror.neuf.no/archlinux/$repo/os/$arch",
	"rsync://archlinux.honkgong.info/archlinux/$repo/os/$arch",
	"rsync://mirrors.uni-plovdiv.net/archlinux/$repo/os/$arch",
	"rsync://ftp.sh.cvut.cz/arch/$repo/os/$arch",
	"rsync://archlinux.mirror.pkern.at/archlinux/$repo/os/$arch",
	"rsync://mirror.f4st.host/archlinux/$repo/os/$arch",
	"rsync://mirror.datacenter.by/archlinux/$repo/os/$arch",
	"rsync://ftp.swin.edu.au/archlinux/$repo/os/$arch",
	"rsync://archlinux.c3sl.ufpr.br/archlinux/$repo/os/$arch",
	"rsync://mirror.dkm.cz/archlinux/$repo/os/$arch",
	"rsync://ftp.yzu.edu.tw/Linux/archlinux/$repo/os/$arch"
    ]
  }
}
XIT
# Chaotic-AUR----------------------------------------------------------------------------------------------------
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
paru -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
paru -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
# Pi-Hole----------------------------------------------------------------------------------------------------
sudo curl -sSL https://install.pi-hole.net | bash
# Drivers----------------------------------------------------------------------------------------------------
for drvpkg in ubuntu-drivers-common system76-driver system76-driver-nvidia nvidia-cuda-toolkit ocl-icd-libopencl1 opencl-icd
do sudo apt-fast install $drvpkg -y
done
sudo systemctl enable --now nvidia-persistenced
sudo systemctl enable --now firmware-manager
# System Packages----------------------------------------------------------------------------------------------------
for syspkg in systemd coreutils flatpak resolvconf util-linux zram-config snowflake-proxy tor obfs4proxy; do sudo apt-fast install $syspkg -y; done
# Flatpak----------------------------------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Pi-Hole----------------------------------------------------------------------------------------------------
curl -sSL https://install.pi-hole.net | bash
sudo systemctl enable --now pihole-FTL
sudo systemctl stop pihole-FTL
sudo tee /etc/dnsmasq.d/02-custom.conf <<EOF
listen-address=127.0.0.1
bind-interfaces
EOF
sudo systemctl enable --now pihole-FTL
sudo pihole restartdns
# ZRAM----------------------------------------------------------------------------------------------------
sudo systemctl enable --now zram-config
sudo systemctl stop zram-config
sudo chmod 777 /usr/bin/init-zram-swapping
sudo zsh -c 'cat > /usr/local/bin/init-zram-swapping << "EOL"
#!/bin/zsh
modprobe zram
totalmem=$(LC_ALL=C free | grep -e "^Mem:" | sed -e "s/^Mem: *//" -e "s/  *.*//")
mem=$((totalmem * 1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 32764 /dev/zram0
EOL'
sudo systemctl enable --now zram-config
# Snowflake----------------------------------------------------------------------------------------------------
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
# Tor----------------------------------------------------------------------------------------------------
sudo systemctl enable --now tor
sudo systemctl stop tor
cd /etc/tor/
sudo chmod 777 /etc/tor/torrc
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
sudo cat > timesyncd.conf << 'EOL'
[Time]
NTP=time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com pool.ntp.org
FallbackNTP=time.google.com time.windows.com time.cloudflare.com time.facebook.com time.apple.com pool.ntp.org
EOL
# sysctl.conf----------------------------------------------------------------------------------------------------
sudo zsh -c 'cat > /etc/sysctl.conf << "EOL"
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
EOL'
# Boot debug----------------------------------------------------------------------------------------------------
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT=""/' /etc/default/grub
sudo update-grub
# Crontab----------------------------------------------------------------------------------------------------
cat <<EOF | sudo crontab -
*/20 * * * * boinccmd --acct_mgr sync
@hourly (sudo apt-fast autoremove; sudo apt-fast -f install; sudo apt-fast clean; sudo apt-fast autoclean; sudo apt-fast update; sudo apt-fast dist-upgrade; sudo ubuntu-drivers autoinstall)
EOF
# DNS Setup----------------------------------------------------------------------------------------------------
sudo systemctl enable --now resolvconf
sudo systemctl stop resolvconf
sudo chmod 777 /etc/resolvconf/resolv.conf.d/base
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
sudo systemctl enable --now resolvconf
# End----------------------------------------------------------------------------------------------------
clear
echo Done!