#!/bin/zsh
clear
cd
if [[ "$USER" == "root" ]]; then
echo Running as root by default is not allowed.
echo There are a few instances where you need to be a regular user...
sleep 5
exit
fi
netrf() {
    while true; do
        sudo -v
        sleep 240
    done
}
netrf &
NETRP=$!
sudo swapoff -a
sudorefresh() {
    while true; do
        sudo -v
        sleep 240
    done
}
sudorefresh &
SUDOREFRESHP=$!
sudo swapoff -a
sudo rmmod zram
sudo rm -rf ~/swapfile
sudo touch ~/swapfile
sudo fallocate -l 8G ~/swapfile
sudo chmod 755 ~/swapfile
sudo mkswap ~/swapfile
sudo swapon -p 32765 ~/swapfile
sudo sysctl vm.swappiness=1
# PkgConfigs---------------------------------------------------------------------------------------------------- 
pacmanrcf() {
sudo rm -rf /var/lib/pacman/db.lck /etc/pacman.d/gnupg /var/lib/pacman/sync/* ~/pacman-git
sudo pacman -Sc --noconfirm
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo touch /etc/pacman.conf
sudo chmod 755 /etc/pacman.conf

sudo chmod 755 /etc/pacman.d/mirrorlist
}

jppkgrcf() {
sudo touch /usr/bin/JPpkg
sudo chmod 755 /usr/bin/JPpkg
sudo tee /usr/bin/JPpkg > /dev/null << "XIT"
#!/bin/bash
sudo systemctl enable JPpkg.timer
sudo systemctl disable JPpkg.service
if [[ "$1" == "upd" && "$(cat /sys/class/power_supply/AC/online)" == "1" ]]; then
sudo reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
paru -Syyu --noconfirm
fi
if [[ "$1" == "stop" ]]; then
sudo systemctl stop JPpkg.service
sudo systemctl stop JPpkg.timer
sudo pkill -f paru
fi
if [[ "$1" == "start" ]]; then
sudo systemctl enable --now JPpkg.timer
fi
if [[ "$1" == "make" ]]; then
multicore=false
for arg in "$@"; do
    if [[ "$arg" == -j* ]]; then
        multicore=true
        break
    fi
done
if [ "$multicore" = false ]; then
    set -- "$@" "-j$(nproc)"
fi
sudo renice -n -20 -p $BASHPID
exec makepkg "$@"
sudo renice -n 0 -p $BASHPID
fi
XIT
sudo touch /lib/systemd/system/JPpkg.service
sudo chmod 755 /lib/systemd/system/JPpkg.service
sudo tee /lib/systemd/system/JPpkg.service > /dev/null << "XIT"
[Unit]
Description=

[Service]
ExecStart=/usr/bin/JPpkg upd
Type=oneshot
XIT
sudo touch /lib/systemd/system/JPpkg.timer
sudo chmod 755 /lib/systemd/system/JPpkg.timer
sudo tee /lib/systemd/system/JPpkg.timer > /dev/null << "XIT"
[Unit]
Description=

[Timer]
OnCalendar=*-*-* *:00/1:00
Persistent=true

[Install]
WantedBy=timers.target
XIT
}
pacmanrcf
sudo pacman -Syy --noconfirm base-devel base git
git clone https://aur.archlinux.org/git-git.git
git clone https://aur.archlinux.org/paru-git.git
git clone https://aur.archlinux.org/pacman-git.git
sudo pacman -Rns --noconfirm git pacman
cd pacman-git
sudo renice -n -20 -p $BASHPID
makepkg -si --noconfirm
sudo renice -n 0 -p $BASHPID
cd
sudo rm -rf ~/pacman-git
cd git-git
sudo renice -n -20 -p $BASHPID
makepkg -si --noconfirm
sudo renice -n 0 -p $BASHPID
cd
sudo rm -rf ~/git-git
git clone https://aur.archlinux.org/paru-git.git
cd paru-git
sudo renice -n -20 -p $BASHPID
makepkg -si --noconfirm
sudo renice -n 0 -p $BASHPID
cd
sudo rm -rf ~
# PackageInst----------------------------------------------------------------------------------------------------
for pakges in\
 linux-xanmod-edge linux-xanmod-edge-headers ramroot-btrfs\
 pipewire-git libpipewire-git wireplumber-git libwireplumber-git\
 paru-git mc-git pi-hole-standalone snowflake-pt-proxy flatpak
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
sudo ramroot -CEY
# Flatpak----------------------------------------------------------------------------------------------------
sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Pi-Hole----------------------------------------------------------------------------------------------------
sudo touch /etc/pihole/pihole-FTL.conf
sudo chmod 755 /etc/pihole/pihole-FTL.conf
sudo tee /etc/pihole/pihole-FTL.conf > /dev/null << "XIT"
RATE_LIMIT=0/0
XIT
sudo touch /etc/pihole/adlists.list
sudo chmod 755 /etc/pihole/adlists.list
sudo tee /etc/pihole/adlists.list > /dev/null << "XIT"
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
sudo systemctl enable --now snowflake-proxy
# Tor----------------------------------------------------------------------------------------------------
sudo setcap cap_net_bind_service=+ep /usr/bin/obfs4proxy
cd /etc/systemd/system/
sudo mkdir tor@.service.d
sudo mkdir tor@default.service.d
sudo chmod 755 tor@.service.d tor@default.service.d
sudo echo -e '[Service]' > tor@.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@.service.d/override.conf
sudo echo -e '[Service]' > tor@default.service.d/override.conf
sudo echo -e "NoNewPrivileges=no" >> tor@default.service.d/override.conf
sudo systemctl enable --now tor
# FS Trim----------------------------------------------------------------------------------------------------
sudo mkdir -p /etc/systemd/system/fstrim.timer.d/
sudo touch /etc/systemd/system/fstrim.timer.d/override.conf
sudo chmod 755 /etc/systemd/system/fstrim.timer.d/override.conf
sudo tee /etc/systemd/system/fstrim.timer.d/override.conf > /dev/null << "XIT"
[Timer]
OnCalendar=
OnCalendar=daily
XIT
sudo systemctl enable --now fstrim.timer
sudo chmod 755 /etc/systemd/timesyncd.conf
# DNS Setup----------------------------------------------------------------------------------------------------
sudo systemctl enable --now systemd-resolved
sudo systemctl enable --now systemd-networkd
# End----------------------------------------------------------------------------------------------------
kill $SUDOREFRESHP
echo Done
