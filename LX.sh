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
if DEVICES=$(grep -e "^/dev/zram" /proc/swaps | awk '{print $1}'); then
    for i in $DEVICES; do
        sudo swapoff $i
    done
fi
if lsmod | grep -q zram; then
    sudo rmmod zram
sudo modprobe zram
sudo mem=$(((LC_ALL=C free | grep -e "^Mem:" | sed -e "s/^Mem: *//" -e "s/  *.*//") * 1024))
sudo echo $mem > /sys/block/zram0/disksize
sudo mkswap /dev/zram0
sudo swapon -p 32765 /dev/zram0
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
XIT
sudo rm -rf /var/lib/pacman/db.lck /var/cache/pacman/pkg/* ~/paru-git
sudo pacman -Syy --noconfirm base-devel git
git clone https://aur.archlinux.org/paru-git.git
cd paru-git
makepkg -si --noconfirm
sudo touch /etc/paru.conf
sudo chmod 777 /etc/paru.conf
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
cd
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
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
[gnome-unstable]
Include = /etc/pacman.d/mirrorlist
XIT
sudo touch /etc/pacman.d/mirrorlist
sudo chmod 777 /etc/pacman.d/mirrorlist
sudo cat > /etc/pacman.d/mirrorlist << "XIT"
#
# Arch Linux repository mirrorlist
# Generated on 2024-08-14
#
# Worldwide
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
# Albania
Server = http://al.arch.niranjan.co/$repo/os/$arch
Server = https://al.arch.niranjan.co/$repo/os/$arch
# Australia
Server = https://mirror.aarnet.edu.au/pub/archlinux/$repo/os/$arch
Server = http://au.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://au.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.digitalpacific.com.au/$repo/os/$arch
Server = https://archlinux.mirror.digitalpacific.com.au/$repo/os/$arch
Server = http://gsl-syd.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://gsl-syd.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://sydney.mirror.pkgbuild.com/$repo/os/$arch
Server = http://ftp.iinet.net.au/pub/archlinux/$repo/os/$arch
Server = http://mirror.internode.on.net/pub/archlinux/$repo/os/$arch
Server = http://syd.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://syd.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = http://ftp.swin.edu.au/archlinux/$repo/os/$arch
# Austria
Server = http://mirror.alwyzon.net/archlinux/$repo/os/$arch
Server = https://mirror.alwyzon.net/archlinux/$repo/os/$arch
Server = http://at.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://at.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.digitalnova.at/archlinux/$repo/os/$arch
Server = http://mirror.easyname.at/archlinux/$repo/os/$arch
Server = https://at.arch.mirror.kescher.at/$repo/os/$arch
Server = http://mirror.reisenbauer.ee/archlinux/$repo/os/$arch
Server = https://mirror.reisenbauer.ee/archlinux/$repo/os/$arch
Server = http://arch.mirror.zachlge.org/$repo/os/$arch
Server = https://arch.mirror.zachlge.org/$repo/os/$arch
# Azerbaijan
Server = http://mirror.hostart.az/archlinux/$repo/os/$arch
Server = https://mirror.hostart.az/archlinux/$repo/os/$arch
Server = http://mirror.yer.az/archlinux/$repo/os/$arch
Server = https://mirror.yer.az/archlinux/$repo/os/$arch
# Bangladesh
Server = http://mirror.xeonbd.com/archlinux/$repo/os/$arch
# Belarus
Server = http://ftp.byfly.by/pub/archlinux/$repo/os/$arch
Server = http://mirror.datacenter.by/pub/archlinux/$repo/os/$arch
# Belgium
Server = http://archlinux.cu.be/$repo/os/$arch
Server = http://archlinux.mirror.kangaroot.net/$repo/os/$arch
Server = http://mirror.tiguinet.net/arch/$repo/os/$arch
# Bosnia and Herzegovina
Server = http://archlinux.mirror.ba/$repo/os/$arch
# Brazil
Server = http://archlinux.c3sl.ufpr.br/$repo/os/$arch
Server = https://archlinux.c3sl.ufpr.br/$repo/os/$arch
Server = http://www.caco.ic.unicamp.br/archlinux/$repo/os/$arch
Server = https://www.caco.ic.unicamp.br/archlinux/$repo/os/$arch
Server = http://br.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://br.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://linorg.usp.br/archlinux/$repo/os/$arch
Server = http://archlinux.pop-es.rnp.br/$repo/os/$arch
Server = http://mirror.ufam.edu.br/archlinux/$repo/os/$arch
Server = http://mirror.ufscar.br/archlinux/$repo/os/$arch
Server = https://mirror.ufscar.br/archlinux/$repo/os/$arch
# Bulgaria
Server = https://mirror.darklinux.uk/archlinux/$repo/os/$arch
Server = http://mirror.host.ag/archlinux/$repo/os/$arch
Server = http://mirrors.neterra.net/archlinux/$repo/os/$arch
Server = https://mirrors.neterra.net/archlinux/$repo/os/$arch
Server = http://mirrors.netix.net/archlinux/$repo/os/$arch
Server = http://mirror.telepoint.bg/archlinux/$repo/os/$arch
Server = https://mirror.telepoint.bg/archlinux/$repo/os/$arch
Server = http://mirrors.uni-plovdiv.net/archlinux/$repo/os/$arch
Server = https://mirrors.uni-plovdiv.net/archlinux/$repo/os/$arch
# Cambodia
Server = http://mirror.sabay.com.kh/archlinux/$repo/os/$arch
Server = https://mirror.sabay.com.kh/archlinux/$repo/os/$arch
# Canada
Server = http://mirror.0xem.ma/arch/$repo/os/$arch
Server = https://mirror.0xem.ma/arch/$repo/os/$arch
Server = http://mirror.accuris.ca/archlinux/$repo/os/$arch
Server = https://mirror.accuris.ca/archlinux/$repo/os/$arch
Server = https://arch.mirror.winslow.cloud/$repo/os/$arch
Server = http://mirror.cedille.club/archlinux/$repo/os/$arch
Server = http://ca.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://ca.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.colo-serv.net/$repo/os/$arch
Server = http://mirror.cpsc.ucalgary.ca/mirror/archlinux.org/$repo/os/$arch
Server = https://mirror.cpsc.ucalgary.ca/mirror/archlinux.org/$repo/os/$arch
Server = http://mirror.csclub.uwaterloo.ca/archlinux/$repo/os/$arch
Server = https://mirror.csclub.uwaterloo.ca/archlinux/$repo/os/$arch
Server = http://mirror2.evolution-host.com/archlinux/$repo/os/$arch
Server = https://mirror2.evolution-host.com/archlinux/$repo/os/$arch
Server = http://mirror.its.dal.ca/archlinux/$repo/os/$arch
Server = http://mirror.quantum5.ca/archlinux/$repo/os/$arch
Server = https://mirror.quantum5.ca/archlinux/$repo/os/$arch
Server = http://muug.ca/mirror/archlinux/$repo/os/$arch
Server = https://muug.ca/mirror/archlinux/$repo/os/$arch
Server = http://mirrors.pablonara.com/archlinux/$repo/os/$arch
Server = https://mirrors.pablonara.com/archlinux/$repo/os/$arch
Server = http://mirror.powerfly.ca/archlinux/$repo/os/$arch
Server = https://mirror.powerfly.ca/archlinux/$repo/os/$arch
Server = https://mirror.qctronics.com/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.rafal.ca/$repo/os/$arch
Server = http://mirror.scd31.com/arch/$repo/os/$arch
Server = https://mirror.scd31.com/arch/$repo/os/$arch
Server = http://mirror.xenyth.net/archlinux/$repo/os/$arch
Server = https://mirror.xenyth.net/archlinux/$repo/os/$arch
# Chile
Server = http://mirror.anquan.cl/archlinux/$repo/os/$arch
Server = https://mirror.anquan.cl/archlinux/$repo/os/$arch
Server = http://elmirror.cl/archlinux/$repo/os/$arch
Server = https://elmirror.cl/archlinux/$repo/os/$arch
Server = http://mirror.hnd.cl/archlinux/$repo/os/$arch
Server = https://mirror.hnd.cl/archlinux/$repo/os/$arch
Server = http://mirror.ufro.cl/archlinux/$repo/os/$arch
Server = https://mirror.ufro.cl/archlinux/$repo/os/$arch
# China
Server = http://mirrors.163.com/archlinux/$repo/os/$arch
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch
Server = http://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.hit.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.hit.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.hust.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.hust.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.jcut.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.jcut.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.jlu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.jlu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.jxust.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.jxust.edu.cn/archlinux/$repo/os/$arch
Server = http://mirror.lzu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.nju.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.njupt.edu.cn/archlinux/$repo/os/$arch
Server = http://mirror.nyist.edu.cn/archlinux/$repo/os/$arch
Server = https://mirror.nyist.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.qlu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.qvq.net.cn/archlinux/$repo/os/$arch
Server = https://mirrors.qvq.net.cn/archlinux/$repo/os/$arch
Server = http://mirror.redrock.team/archlinux/$repo/os/$arch
Server = https://mirror.redrock.team/archlinux/$repo/os/$arch
Server = http://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.wsyu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.wsyu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.zju.edu.cn/archlinux/$repo/os/$arch
# Colombia
Server = http://mirrors.atlas.net.co/archlinux/$repo/os/$arch
Server = https://mirrors.atlas.net.co/archlinux/$repo/os/$arch
Server = http://edgeuno-bog2.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://edgeuno-bog2.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://mirrors.udenar.edu.co/archlinux/$repo/os/$arch
# Croatia
Server = http://archlinux.iskon.hr/$repo/os/$arch
# Czechia
Server = http://mirror.dkm.cz/archlinux/$repo/os/$arch
Server = https://mirror.dkm.cz/archlinux/$repo/os/$arch
Server = http://ftp.fi.muni.cz/pub/linux/arch/$repo/os/$arch
Server = http://ftp.linux.cz/pub/linux/arch/$repo/os/$arch
Server = https://europe.mirror.pkgbuild.com/$repo/os/$arch
Server = http://gluttony.sin.cvut.cz/arch/$repo/os/$arch
Server = https://gluttony.sin.cvut.cz/arch/$repo/os/$arch
Server = http://mirror.it4i.cz/arch/$repo/os/$arch
Server = https://mirror.it4i.cz/arch/$repo/os/$arch
Server = http://mirrors.nic.cz/archlinux/$repo/os/$arch
Server = https://mirrors.nic.cz/archlinux/$repo/os/$arch
Server = http://ftp.sh.cvut.cz/arch/$repo/os/$arch
Server = https://ftp.sh.cvut.cz/arch/$repo/os/$arch
Server = http://mirror.vpsfree.cz/archlinux/$repo/os/$arch
# Denmark
Server = http://mirrors.dotsrc.org/archlinux/$repo/os/$arch
Server = https://mirrors.dotsrc.org/archlinux/$repo/os/$arch
Server = http://mirror.group.one/archlinux/$repo/os/$arch
Server = https://mirror.group.one/archlinux/$repo/os/$arch
Server = https://mirror.safe-con.dk/archlinux/$repo/os/$arch
# Ecuador
Server = http://mirror.cedia.org.ec/archlinux/$repo/os/$arch
Server = http://mirror.espoch.edu.ec/archlinux/$repo/os/$arch
# Estonia
Server = http://mirror.cspacehostings.com/archlinux/$repo/os/$arch
Server = https://mirror.cspacehostings.com/archlinux/$repo/os/$arch
Server = http://repo.br.ee/arch/$repo/os/$arch
Server = https://repo.br.ee/arch/$repo/os/$arch
Server = http://mirrors.xtom.ee/archlinux/$repo/os/$arch
Server = https://mirrors.xtom.ee/archlinux/$repo/os/$arch
# Finland
Server = https://arch.mcstrugs.org/$repo/os/$arch
Server = http://mirror.arctic.lol/ArchMirror/$repo/os/$arch
Server = https://mirror.arctic.lol/ArchMirror/$repo/os/$arch
Server = http://arch.mirror.far.fi/$repo/os/$arch
Server = http://mirror.hosthink.net/archlinux/$repo/os/$arch
Server = http://mirrors.janbruckner.de/archlinux/$repo/os/$arch
Server = https://mirrors.janbruckner.de/archlinux/$repo/os/$arch
Server = http://mirror.5i.fi/archlinux/$repo/os/$arch
Server = https://mirror.5i.fi/archlinux/$repo/os/$arch
Server = https://mirror1.sl-chat.ru/archlinux/$repo/os/$arch
Server = https://mirror.srv.fail/archlinux/$repo/os/$arch
Server = http://mirror.wuki.li/archlinux/$repo/os/$arch
Server = https://mirror.wuki.li/archlinux/$repo/os/$arch
Server = http://arch.yhtez.xyz/$repo/os/$arch
Server = https://arch.yhtez.xyz/$repo/os/$arch
# France
Server = http://mirror.archlinux.ikoula.com/archlinux/$repo/os/$arch
Server = http://archlinux.mirrors.benatherton.com/$repo/os/$arch
Server = http://fr.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://fr.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.cyberbits.eu/archlinux/$repo/os/$arch
Server = https://mirror.cyberbits.eu/archlinux/$repo/os/$arch
Server = http://archlinux.datagr.am/$repo/os/$arch
Server = https://mirrors.eric.ovh/arch/$repo/os/$arch
Server = http://mirrors.gandi.net/archlinux/$repo/os/$arch
Server = https://mirrors.gandi.net/archlinux/$repo/os/$arch
Server = http://archmirror.hogwarts.fr/$repo/os/$arch
Server = https://archmirror.hogwarts.fr/$repo/os/$arch
Server = https://mirror.ibakerserver.pt/Arch/$repo/os/$arch
Server = http://mirror.its-tps.fr/archlinux/$repo/os/$arch
Server = https://mirror.its-tps.fr/archlinux/$repo/os/$arch
Server = http://mirror.jordanrey.me/archlinux/$repo/os/$arch
Server = https://mirror.jordanrey.me/archlinux/$repo/os/$arch
Server = https://mirrors.jtremesay.org/archlinux/$repo/os/$arch
Server = https://arch.juline.tech/$repo/os/$arch
Server = http://mirroir.labhouse.fr/arch/$repo/os/$arch
Server = https://mirroir.labhouse.fr/arch/$repo/os/$arch
Server = http://mirror.lastmikoi.net/archlinux/$repo/os/$arch
Server = http://archlinux.mailtunnel.eu/$repo/os/$arch
Server = https://archlinux.mailtunnel.eu/$repo/os/$arch
Server = http://mir.archlinux.fr/$repo/os/$arch
Server = http://mirrors.celianvdb.fr/archlinux/$repo/os/$arch
Server = https://mirrors.celianvdb.fr/archlinux/$repo/os/$arch
Server = http://arch.nimukaito.net/$repo/os/$arch
Server = https://arch.nimukaito.net/$repo/os/$arch
Server = http://mirror.oldsql.cc/archlinux/$repo/os/$arch
Server = https://mirror.oldsql.cc/archlinux/$repo/os/$arch
Server = http://archlinux.mirrors.ovh.net/archlinux/$repo/os/$arch
Server = https://archlinux.mirrors.ovh.net/archlinux/$repo/os/$arch
Server = http://mirror.rznet.fr/archlinux/$repo/os/$arch
Server = https://mirror.rznet.fr/archlinux/$repo/os/$arch
Server = http://mirror.spaceint.fr/archlinux/$repo/os/$arch
Server = https://mirror.spaceint.fr/archlinux/$repo/os/$arch
Server = http://mirrors.standaloneinstaller.com/archlinux/$repo/os/$arch
Server = https://mirror.sysa.tech/archlinux/$repo/os/$arch
Server = https://mirror.thekinrar.fr/archlinux/$repo/os/$arch
Server = http://mirror.theo546.fr/archlinux/$repo/os/$arch
Server = https://mirror.theo546.fr/archlinux/$repo/os/$arch
Server = http://ftp.u-strasbg.fr/linux/distributions/archlinux/$repo/os/$arch
Server = https://mirror.wormhole.eu/archlinux/$repo/os/$arch
Server = http://arch.yourlabs.org/$repo/os/$arch
Server = https://arch.yourlabs.org/$repo/os/$arch
# Georgia
Server = http://archlinux.grena.ge/$repo/os/$arch
Server = https://archlinux.grena.ge/$repo/os/$arch
# Germany
Server = http://mirror.23m.com/archlinux/$repo/os/$arch
Server = https://mirror.23m.com/archlinux/$repo/os/$arch
Server = http://ftp.agdsn.de/pub/mirrors/archlinux/$repo/os/$arch
Server = https://ftp.agdsn.de/pub/mirrors/archlinux/$repo/os/$arch
Server = https://appuals.com/archlinux/$repo/os/$arch
Server = http://artfiles.org/archlinux.org/$repo/os/$arch
Server = https://mirror.bethselamin.de/$repo/os/$arch
Server = http://de.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://de.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.clientvps.com/archlinux/$repo/os/$arch
Server = https://mirror.clientvps.com/archlinux/$repo/os/$arch
Server = http://mirror.cmt.de/archlinux/$repo/os/$arch
Server = https://mirror.cmt.de/archlinux/$repo/os/$arch
Server = http://os.codefionn.eu/archlinux/$repo/os/$arch
Server = https://os.codefionn.eu/archlinux/$repo/os/$arch
Server = https://mirror.dogado.de/archlinux/$repo/os/$arch
Server = https://mirror.eto.dev/arch/$repo/os/$arch
Server = http://ftp.fau.de/archlinux/$repo/os/$arch
Server = https://ftp.fau.de/archlinux/$repo/os/$arch
Server = https://pkg.fef.moe/archlinux/$repo/os/$arch
Server = https://dist-mirror.fem.tu-ilmenau.de/archlinux/$repo/os/$arch
Server = http://mirror.fsrv.services/archlinux/$repo/os/$arch
Server = https://mirror.fsrv.services/archlinux/$repo/os/$arch
Server = https://mirror.gnomus.de/$repo/os/$arch
Server = http://www.gutscheindrache.com/mirror/archlinux/$repo/os/$arch
Server = http://ftp.gwdg.de/pub/linux/archlinux/$repo/os/$arch
Server = https://files.hadiko.de/pub/dists/arch/$repo/os/$arch
Server = https://archlinux.homeinfo.de/$repo/os/$arch
Server = http://ftp.hosteurope.de/mirror/ftp.archlinux.org/$repo/os/$arch
Server = http://ftp-stud.hs-esslingen.de/pub/Mirrors/archlinux/$repo/os/$arch
Server = http://mirror.hugo-betrugo.de/archlinux/$repo/os/$arch
Server = https://mirror.hugo-betrugo.de/archlinux/$repo/os/$arch
Server = http://mirror.informatik.tu-freiberg.de/arch/$repo/os/$arch
Server = https://mirror.informatik.tu-freiberg.de/arch/$repo/os/$arch
Server = http://archlinux.mirror.iphh.net/$repo/os/$arch
Server = https://mirror.iusearchbtw.nl/$repo/os/$arch
Server = http://arch.jensgutermuth.de/$repo/os/$arch
Server = https://arch.jensgutermuth.de/$repo/os/$arch
Server = https://de.arch.mirror.kescher.at/$repo/os/$arch
Server = http://mirror.kumi.systems/archlinux/$repo/os/$arch
Server = https://mirror.kumi.systems/archlinux/$repo/os/$arch
Server = https://arch.kurdy.org/$repo/os/$arch
Server = http://mirror.fra10.de.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.fra10.de.leaseweb.net/archlinux/$repo/os/$arch
Server = http://mirror.metalgamer.eu/archlinux/$repo/os/$arch
Server = https://mirror.metalgamer.eu/archlinux/$repo/os/$arch
Server = http://mirror.mikrogravitation.org/archlinux/$repo/os/$arch
Server = https://mirror.mikrogravitation.org/archlinux/$repo/os/$arch
Server = http://mirror.lcarilla.de/archlinux/$repo/os/$arch
Server = https://mirror.lcarilla.de/archlinux/$repo/os/$arch
Server = http://mirror.moson.org/arch/$repo/os/$arch
Server = https://mirror.moson.org/arch/$repo/os/$arch
Server = http://mirrors.n-ix.net/archlinux/$repo/os/$arch
Server = https://mirrors.n-ix.net/archlinux/$repo/os/$arch
Server = http://mirror.netcologne.de/archlinux/$repo/os/$arch
Server = https://mirror.netcologne.de/archlinux/$repo/os/$arch
Server = http://de.arch.niranjan.co/$repo/os/$arch
Server = https://de.arch.niranjan.co/$repo/os/$arch
Server = http://mirrors.niyawe.de/archlinux/$repo/os/$arch
Server = https://mirrors.niyawe.de/archlinux/$repo/os/$arch
Server = http://mirror.orbit-os.com/archlinux/$repo/os/$arch
Server = https://mirror.orbit-os.com/archlinux/$repo/os/$arch
Server = http://packages.oth-regensburg.de/archlinux/$repo/os/$arch
Server = https://packages.oth-regensburg.de/archlinux/$repo/os/$arch
Server = http://mirror.pagenotfound.de/archlinux/$repo/os/$arch
Server = https://mirror.pagenotfound.de/archlinux/$repo/os/$arch
Server = http://arch.phinau.de/$repo/os/$arch
Server = https://arch.phinau.de/$repo/os/$arch
Server = https://mirror.pseudoform.org/$repo/os/$arch
Server = https://archlinux.richard-neumann.de/$repo/os/$arch
Server = http://ftp.halifax.rwth-aachen.de/archlinux/$repo/os/$arch
Server = https://ftp.halifax.rwth-aachen.de/archlinux/$repo/os/$arch
Server = http://linux.rz.rub.de/archlinux/$repo/os/$arch
Server = http://mirror.satis-faction.de/archlinux/$repo/os/$arch
Server = https://mirror.satis-faction.de/archlinux/$repo/os/$arch
Server = http://mirror.selfnet.de/archlinux/$repo/os/$arch
Server = https://mirror.selfnet.de/archlinux/$repo/os/$arch
Server = http://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/$repo/os/$arch
Server = https://ftp.spline.inf.fu-berlin.de/mirrors/archlinux/$repo/os/$arch
Server = http://mirror.sunred.org/archlinux/$repo/os/$arch
Server = https://mirror.sunred.org/archlinux/$repo/os/$arch
Server = http://archlinux.thaller.ws/$repo/os/$arch
Server = https://archlinux.thaller.ws/$repo/os/$arch
Server = http://ftp.tu-chemnitz.de/pub/linux/archlinux/$repo/os/$arch
Server = http://mirror.ubrco.de/archlinux/$repo/os/$arch
Server = https://mirror.ubrco.de/archlinux/$repo/os/$arch
Server = http://mirror.undisclose.de/archlinux/$repo/os/$arch
Server = https://mirror.undisclose.de/archlinux/$repo/os/$arch
Server = http://ftp.uni-bayreuth.de/linux/archlinux/$repo/os/$arch
Server = http://ftp.uni-hannover.de/archlinux/$repo/os/$arch
Server = http://ftp.uni-kl.de/pub/linux/archlinux/$repo/os/$arch
Server = http://mirror.united-gameserver.de/archlinux/$repo/os/$arch
Server = https://arch.unixpeople.org/$repo/os/$arch
Server = http://ftp.wrz.de/pub/archlinux/$repo/os/$arch
Server = https://ftp.wrz.de/pub/archlinux/$repo/os/$arch
Server = http://mirror.wtnet.de/archlinux/$repo/os/$arch
Server = https://mirror.wtnet.de/archlinux/$repo/os/$arch
Server = http://mirrors.xtom.de/archlinux/$repo/os/$arch
Server = https://mirrors.xtom.de/archlinux/$repo/os/$arch
# Greece
Server = http://ftp.cc.uoc.gr/mirrors/linux/archlinux/$repo/os/$arch
Server = https://repo.greeklug.gr/data/pub/linux/archlinux/$repo/os/$arch
Server = http://mirrors.myaegean.gr/linux/archlinux/$repo/os/$arch
Server = http://ftp.ntua.gr/pub/linux/archlinux/$repo/os/$arch
Server = http://ftp.otenet.gr/linux/archlinux/$repo/os/$arch
# Hong Kong
Server = https://asia.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror-hk.koddos.net/archlinux/$repo/os/$arch
Server = https://mirror-hk.koddos.net/archlinux/$repo/os/$arch
Server = http://hkg.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://hkg.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://arch-mirror.wtako.net/$repo/os/$arch
Server = http://mirror.xtom.com.hk/archlinux/$repo/os/$arch
Server = https://mirror.xtom.com.hk/archlinux/$repo/os/$arch
# Hungary
Server = https://ftp.ek-cer.hu/pub/mirrors/ftp.archlinux.org/$repo/os/$arch
Server = http://archmirror.hbit.sztaki.hu/archlinux/$repo/os/$arch
Server = http://nova.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = http://quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = http://super.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = https://nova.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = https://quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
Server = https://super.quantum-mirror.hu/mirrors/pub/archlinux/$repo/os/$arch
# Iceland
Server = http://is.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = https://is.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = http://mirrors.opensource.is/archlinux/$repo/os/$arch
Server = https://mirrors.opensource.is/archlinux/$repo/os/$arch
Server = http://mirror.system.is/arch/$repo/os/$arch
Server = https://mirror.system.is/arch/$repo/os/$arch
# India
Server = http://mirror.4v1.in/archlinux/$repo/os/$arch
Server = https://mirror.4v1.in/archlinux/$repo/os/$arch
Server = https://mirrors.abhy.me/archlinux/$repo/os/$arch
Server = https://mirror.albony.in/archlinux/$repo/os/$arch
Server = https://mirror.maa.albony.in/archlinux/$repo/os/$arch
Server = https://mirror.nag.albony.in/archlinux/$repo/os/$arch
Server = http://in.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://in.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.cse.iitk.ac.in/archlinux/$repo/os/$arch
Server = http://in-mirror.garudalinux.org/archlinux/$repo/os/$arch
Server = https://in-mirror.garudalinux.org/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.net.in/archlinux/$repo/os/$arch
Server = https://archlinux.mirror.net.in/archlinux/$repo/os/$arch
Server = http://arch.niranjan.co/$repo/os/$arch
Server = https://arch.niranjan.co/$repo/os/$arch
Server = http://mirrors.nxtgen.com/archlinux-mirror/$repo/os/$arch
Server = https://mirrors.nxtgen.com/archlinux-mirror/$repo/os/$arch
Server = http://mirrors.piconets.webwerks.in/archlinux-mirror/$repo/os/$arch
Server = https://mirrors.piconets.webwerks.in/archlinux-mirror/$repo/os/$arch
Server = http://mirror.sahil.world/archlinux/$repo/os/$arch
Server = https://mirror.sahil.world/archlinux/$repo/os/$arch
# Indonesia
Server = http://mirror.citrahost.com/archlinux/$repo/os/$arch
Server = https://mirror.citrahost.com/archlinux/$repo/os/$arch
Server = http://mirror.cloudweeb.com/archlinux/$repo/os/$arch
Server = http://mirror.faizuladib.com/archlinux/$repo/os/$arch
Server = http://mirror.gi.co.id/archlinux/$repo/os/$arch
Server = https://mirror.gi.co.id/archlinux/$repo/os/$arch
Server = http://vpsmurah.jagoanhosting.com/archlinux/$repo/os/$arch
Server = https://vpsmurah.jagoanhosting.com/archlinux/$repo/os/$arch
Server = http://kebo.pens.ac.id/archlinux/$repo/os/$arch
Server = http://mirror.labkom.id/archlinux/$repo/os/$arch
Server = http://mirror.ditatompel.com/archlinux/$repo/os/$arch
Server = https://mirror.ditatompel.com/archlinux/$repo/os/$arch
Server = http://mirror.papua.go.id/archlinux/$repo/os/$arch
Server = https://mirror.papua.go.id/archlinux/$repo/os/$arch
Server = http://mirror.poliwangi.ac.id/archlinux/$repo/os/$arch
Server = http://mirror.repository.id/archlinux/$repo/os/$arch
Server = https://mirror.repository.id/archlinux/$repo/os/$arch
Server = http://mirror.telkomuniversity.ac.id/archlinux/$repo/os/$arch
Server = https://mirror.telkomuniversity.ac.id/archlinux/$repo/os/$arch
Server = https://kacabenggala.uny.ac.id/archlinux/$repo/os/$arch
# Iran
Server = http://mirror.arvancloud.ir/archlinux/$repo/os/$arch
Server = https://mirror.arvancloud.ir/archlinux/$repo/os/$arch
Server = http://mirror.bardia.tech/archlinux/$repo/os/$arch
Server = https://mirror.bardia.tech/archlinux/$repo/os/$arch
Server = http://mirror.hostiran.ir/archlinux/$repo/os/$arch
Server = https://mirror.hostiran.ir/archlinux/$repo/os/$arch
Server = http://repo.iut.ac.ir/repo/archlinux/$repo/os/$arch
Server = http://mirror.nak-mci.ir/arch/$repo/os/$arch
# Israel
Server = http://archlinux.interhost.co.il/$repo/os/$arch
Server = https://archlinux.interhost.co.il/$repo/os/$arch
Server = http://mirror.isoc.org.il/pub/archlinux/$repo/os/$arch
Server = https://mirror.isoc.org.il/pub/archlinux/$repo/os/$arch
Server = https://archlinux.mivzakim.net/$repo/os/$arch
# Italy
Server = http://it.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://it.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.garr.it/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.server24.net/$repo/os/$arch
Server = https://archlinux.mirror.server24.net/$repo/os/$arch
# Japan
Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
Server = https://mirrors.cat.net/archlinux/$repo/os/$arch
Server = http://jp.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://jp.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = http://repo.jing.rocks/archlinux/$repo/os/$arch
Server = https://repo.jing.rocks/archlinux/$repo/os/$arch
Server = http://www.miraa.jp/archlinux/$repo/os/$arch
Server = https://www.miraa.jp/archlinux/$repo/os/$arch
Server = http://mirror.nishi.network/archlinux/$repo/os/$arch
Server = https://mirror.nishi.network/archlinux/$repo/os/$arch
Server = https://mirror.saebasol.org/archlinux/$repo/os/$arch
# Kazakhstan
Server = http://mirror.hoster.kz/archlinux/$repo/os/$arch
Server = https://mirror.hoster.kz/archlinux/$repo/os/$arch
Server = http://mirror.ps.kz/archlinux/$repo/os/$arch
Server = https://mirror.ps.kz/archlinux/$repo/os/$arch
# Kenya
Server = http://archlinux.mirror.liquidtelecom.com/$repo/os/$arch
Server = https://archlinux.mirror.liquidtelecom.com/$repo/os/$arch
# Latvia
Server = http://archlinux.koyanet.lv/archlinux/$repo/os/$arch
Server = https://archlinux.koyanet.lv/archlinux/$repo/os/$arch
# Lithuania
Server = http://mirrors.atviras.lt/archlinux/$repo/os/$arch
Server = https://mirrors.atviras.lt/archlinux/$repo/os/$arch
Server = http://mirrors.ims.nksc.lt/archlinux/$repo/os/$arch
Server = https://mirrors.ims.nksc.lt/archlinux/$repo/os/$arch
# Luxembourg
Server = http://archmirror.xyz/archlinux/$repo/os/$arch
Server = https://archmirror.xyz/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.root.lu/$repo/os/$arch
# Mauritius
Server = http://archlinux-mirror.cloud.mu/$repo/os/$arch
Server = https://archlinux-mirror.cloud.mu/$repo/os/$arch
# Mexico
Server = http://lidsol.fi-b.unam.mx/archlinux/$repo/os/$arch
Server = https://lidsol.fi-b.unam.mx/archlinux/$repo/os/$arch
Server = https://arch.jsc.mx/$repo/os/$arch
# Moldova
Server = http://md.mirrors.hacktegic.com/archlinux/$repo/os/$arch
Server = https://md.mirrors.hacktegic.com/archlinux/$repo/os/$arch
Server = http://mirror.ihost.md/archlinux/$repo/os/$arch
Server = https://mirror.ihost.md/archlinux/$repo/os/$arch
Server = http://mirror.mangohost.net/archlinux/$repo/os/$arch
Server = https://mirror.mangohost.net/archlinux/$repo/os/$arch
# Monaco
Server = http://mirrors.qontinuum.space/archlinux/$repo/os/$arch
Server = https://mirrors.qontinuum.space/archlinux/$repo/os/$arch
# Netherlands
Server = http://mirror.bouwhuis.network/archlinux/$repo/os/$arch
Server = https://mirror.bouwhuis.network/archlinux/$repo/os/$arch
Server = http://nl.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://nl.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.cj2.nl/archlinux/$repo/os/$arch
Server = https://mirror.cj2.nl/archlinux/$repo/os/$arch
Server = https://mirrors.daan.vodka/archlinux/$repo/os/$arch
Server = http://mirrors.evoluso.com/archlinux/$repo/os/$arch
Server = http://nl.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = https://nl.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = http://mirror.i3d.net/pub/archlinux/$repo/os/$arch
Server = https://mirror.i3d.net/pub/archlinux/$repo/os/$arch
Server = https://arch.jeweet.net/$repo/os/$arch
Server = http://mirror.koddos.net/archlinux/$repo/os/$arch
Server = https://mirror.koddos.net/archlinux/$repo/os/$arch
Server = http://arch.mirrors.lavatech.top/$repo/os/$arch
Server = https://arch.mirrors.lavatech.top/$repo/os/$arch
Server = http://mirror.ams1.nl.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.ams1.nl.leaseweb.net/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.liteserver.nl/$repo/os/$arch
Server = https://archlinux.mirror.liteserver.nl/$repo/os/$arch
Server = http://mirror.lyrahosting.com/archlinux/$repo/os/$arch
Server = https://mirror.lyrahosting.com/archlinux/$repo/os/$arch
Server = http://mirror.mijn.host/archlinux/$repo/os/$arch
Server = https://mirror.mijn.host/archlinux/$repo/os/$arch
Server = http://mirror.neostrada.nl/archlinux/$repo/os/$arch
Server = https://mirror.neostrada.nl/archlinux/$repo/os/$arch
Server = http://ftp.nluug.nl/os/Linux/distr/archlinux/$repo/os/$arch
Server = http://mirror.serverion.com/archlinux/$repo/os/$arch
Server = https://mirror.serverion.com/archlinux/$repo/os/$arch
Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/$repo/os/$arch
Server = http://mirror.tarellia.net/distr/archlinux/$repo/os/$arch
Server = https://mirror.tarellia.net/distr/archlinux/$repo/os/$arch
Server = http://mirrors.viflcraft.top/archlinux/$repo/os/$arch
Server = https://mirrors.viflcraft.top/archlinux/$repo/os/$arch
Server = http://archlinux.mirror.wearetriple.com/$repo/os/$arch
Server = https://archlinux.mirror.wearetriple.com/$repo/os/$arch
Server = http://mirror-archlinux.webruimtehosting.nl/$repo/os/$arch
Server = https://mirror-archlinux.webruimtehosting.nl/$repo/os/$arch
Server = http://mirrors.xtom.nl/archlinux/$repo/os/$arch
Server = https://mirrors.xtom.nl/archlinux/$repo/os/$arch
# New Caledonia
Server = http://mirror.lagoon.nc/pub/archlinux/$repo/os/$arch
Server = http://archlinux.nautile.nc/archlinux/$repo/os/$arch
Server = https://archlinux.nautile.nc/archlinux/$repo/os/$arch
# New Zealand
Server = http://mirror.2degrees.nz/archlinux/$repo/os/$arch
Server = https://mirror.2degrees.nz/archlinux/$repo/os/$arch
Server = http://mirror.fsmg.org.nz/archlinux/$repo/os/$arch
Server = https://mirror.fsmg.org.nz/archlinux/$repo/os/$arch
Server = https://archlinux.ourhome.kiwi/$repo/os/$arch
Server = http://mirror.smith.geek.nz/archlinux/$repo/os/$arch
Server = https://mirror.smith.geek.nz/archlinux/$repo/os/$arch
# North Macedonia
Server = http://arch.softver.org.mk/archlinux/$repo/os/$arch
Server = http://mirror.onevip.mk/archlinux/$repo/os/$arch
Server = http://mirror.t-home.mk/archlinux/$repo/os/$arch
Server = https://mirror.t-home.mk/archlinux/$repo/os/$arch
# Norway
Server = http://mirror.archlinux.no/$repo/os/$arch
Server = https://mirror.archlinux.no/$repo/os/$arch
Server = http://archlinux.uib.no/$repo/os/$arch
Server = http://lysakermoen.com/Software/Linux/Mirrors/ArchLinux/$repo/os/$arch
Server = https://lysakermoen.com/Software/Linux/Mirrors/ArchLinux/$repo/os/$arch
Server = http://mirror.neuf.no/archlinux/$repo/os/$arch
Server = https://mirror.neuf.no/archlinux/$repo/os/$arch
Server = http://mirror.terrahost.no/linux/archlinux/$repo/os/$arch
# Paraguay
Server = http://archlinux.mirror.py/archlinux/$repo/os/$arch
# Poland
Server = https://mirror.eloteam.tk/archlinux/$repo/os/$arch
Server = http://ftp.icm.edu.pl/pub/Linux/dist/archlinux/$repo/os/$arch
Server = https://ftp.icm.edu.pl/pub/Linux/dist/archlinux/$repo/os/$arch
Server = http://mirror.juniorjpdj.pl/archlinux/$repo/os/$arch
Server = https://mirror.juniorjpdj.pl/archlinux/$repo/os/$arch
Server = http://arch.midov.pl/arch/$repo/os/$arch
Server = https://arch.midov.pl/arch/$repo/os/$arch
Server = http://mirroronet.pl/pub/mirrors/archlinux/$repo/os/$arch
Server = https://mirroronet.pl/pub/mirrors/archlinux/$repo/os/$arch
Server = http://piotrkosoft.net/pub/mirrors/ftp.archlinux.org/$repo/os/$arch
Server = http://ftp.psnc.pl/linux/archlinux/$repo/os/$arch
Server = https://ftp.psnc.pl/linux/archlinux/$repo/os/$arch
Server = http://arch.sakamoto.pl/$repo/os/$arch
Server = https://arch.sakamoto.pl/$repo/os/$arch
Server = http://repo.skni.umcs.pl/archlinux/$repo/os/$arch
Server = https://repo.skni.umcs.pl/archlinux/$repo/os/$arch
Server = http://arch.takehiko.pl/$repo/os/$arch
Server = https://arch.takehiko.pl/$repo/os/$arch
Server = http://ftp.vectranet.pl/archlinux/$repo/os/$arch
# Portugal
Server = http://mirror.barata.pt/archlinux/$repo/os/$arch
Server = https://mirror.barata.pt/archlinux/$repo/os/$arch
Server = http://glua.ua.pt/pub/archlinux/$repo/os/$arch
Server = https://glua.ua.pt/pub/archlinux/$repo/os/$arch
Server = http://mirror.leitecastro.com/archlinux/$repo/os/$arch
Server = https://mirror.leitecastro.com/archlinux/$repo/os/$arch
Server = http://mirrors.up.pt/pub/archlinux/$repo/os/$arch
Server = https://mirrors.up.pt/pub/archlinux/$repo/os/$arch
Server = http://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/$repo/os/$arch
Server = https://ftp.rnl.tecnico.ulisboa.pt/pub/archlinux/$repo/os/$arch
# Romania
Server = http://mirrors.chroot.ro/archlinux/$repo/os/$arch
Server = https://mirrors.chroot.ro/archlinux/$repo/os/$arch
Server = http://mirror.efect.ro/archlinux/$repo/os/$arch
Server = https://mirror.efect.ro/archlinux/$repo/os/$arch
Server = http://ro.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = https://ro.mirror.flokinet.net/archlinux/$repo/os/$arch
Server = http://mirrors.go.ro/archlinux/$repo/os/$arch
Server = https://mirrors.go.ro/archlinux/$repo/os/$arch
Server = http://mirrors.hosterion.ro/archlinux/$repo/os/$arch
Server = https://mirrors.hosterion.ro/archlinux/$repo/os/$arch
Server = http://mirrors.hostico.ro/archlinux/$repo/os/$arch
Server = https://mirrors.hostico.ro/archlinux/$repo/os/$arch
Server = http://archlinux.mirrors.linux.ro/$repo/os/$arch
Server = http://linuxromania.ro/archlinux/$repo/os/$arch
Server = https://linuxromania.ro/archlinux/$repo/os/$arch
Server = http://mirrors.m247.ro/archlinux/$repo/os/$arch
Server = http://mirrors.nav.ro/archlinux/$repo/os/$arch
Server = http://mirrors.nxthost.com/archlinux/$repo/os/$arch
Server = https://mirrors.nxthost.com/archlinux/$repo/os/$arch
Server = http://mirrors.pidginhost.com/arch/$repo/os/$arch
Server = https://mirrors.pidginhost.com/arch/$repo/os/$arch
# Russia
Server = http://ru.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://ru.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.kamtv.ru/archlinux/$repo/os/$arch
Server = https://mirror.kamtv.ru/archlinux/$repo/os/$arch
Server = http://mirror.kpfu.ru/archlinux/$repo/os/$arch
Server = https://mirror.kpfu.ru/archlinux/$repo/os/$arch
Server = http://mirror.lebedinets.ru/archlinux/$repo/os/$arch
Server = https://mirror.lebedinets.ru/archlinux/$repo/os/$arch
Server = http://mirror.nw-sys.ru/archlinux/$repo/os/$arch
Server = https://mirror.nw-sys.ru/archlinux/$repo/os/$arch
Server = http://mirrors.powernet.com.ru/archlinux/$repo/os/$arch
Server = http://repository.su/archlinux/$repo/os/$arch
Server = https://repository.su/archlinux/$repo/os/$arch
Server = http://mirror.rol.ru/archlinux/$repo/os/$arch
Server = https://mirror.rol.ru/archlinux/$repo/os/$arch
Server = https://mirror2.sl-chat.ru/archlinux/$repo/os/$arch
Server = https://mirror3.sl-chat.ru/archlinux/$repo/os/$arch
Server = http://mirror.truenetwork.ru/archlinux/$repo/os/$arch
Server = https://mirror.truenetwork.ru/archlinux/$repo/os/$arch
Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch
Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch
Server = http://archlinux.zepto.cloud/$repo/os/$arch
# RÃ©union
Server = http://arch.mithril.re/$repo/os/$arch
# Saudi Arabia
Server = http://sa.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://sa.mirrors.cicku.me/archlinux/$repo/os/$arch
# Serbia
Server = http://arch.petarmaric.com/$repo/os/$arch
Server = http://mirror.pmf.kg.ac.rs/archlinux/$repo/os/$arch
Server = http://mirror1.sox.rs/archlinux/$repo/os/$arch
Server = https://mirror1.sox.rs/archlinux/$repo/os/$arch
# Singapore
Server = http://mirror.0x.sg/archlinux/$repo/os/$arch
Server = https://mirror.0x.sg/archlinux/$repo/os/$arch
Server = http://mirror.aktkn.sg/archlinux/$repo/os/$arch
Server = https://mirror.aktkn.sg/archlinux/$repo/os/$arch
Server = http://sg.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://sg.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://download.nus.edu.sg/mirror/archlinux/$repo/os/$arch
Server = http://mirror.guillaumea.fr/archlinux/$repo/os/$arch
Server = https://mirror.guillaumea.fr/archlinux/$repo/os/$arch
Server = http://mirror.jingk.ai/archlinux/$repo/os/$arch
Server = https://mirror.jingk.ai/archlinux/$repo/os/$arch
Server = http://ossmirror.mycloud.services/os/linux/archlinux/$repo/os/$arch
Server = http://mirror.sg.gs/archlinux/$repo/os/$arch
Server = https://mirror.sg.gs/archlinux/$repo/os/$arch
# Slovakia
Server = http://mirror.lnx.sk/pub/linux/archlinux/$repo/os/$arch
Server = https://mirror.lnx.sk/pub/linux/archlinux/$repo/os/$arch
Server = http://tux.rainside.sk/archlinux/$repo/os/$arch
# Slovenia
Server = http://mirror.tux.si/arch/$repo/os/$arch
Server = https://mirror.tux.si/arch/$repo/os/$arch
# South Africa
Server = http://archlinux.za.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = https://archlinux.za.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = http://za.mirror.archlinux-br.org/$repo/os/$arch
Server = http://za.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://za.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.is.co.za/mirror/archlinux.org/$repo/os/$arch
Server = http://mirrors.urbanwave.co.za/archlinux/$repo/os/$arch
Server = https://mirrors.urbanwave.co.za/archlinux/$repo/os/$arch
# South Korea
Server = http://kr.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://kr.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://ftp.kaist.ac.kr/ArchLinux/$repo/os/$arch
Server = http://mirror.funami.tech/arch/$repo/os/$arch
Server = https://mirror.funami.tech/arch/$repo/os/$arch
Server = https://seoul.mirror.pkgbuild.com/$repo/os/$arch
Server = http://ftp.harukasan.org/archlinux/$repo/os/$arch
Server = https://ftp.harukasan.org/archlinux/$repo/os/$arch
Server = http://ftp.lanet.kr/pub/archlinux/$repo/os/$arch
Server = https://ftp.lanet.kr/pub/archlinux/$repo/os/$arch
Server = http://mirror.morgan.kr/archlinux/$repo/os/$arch
Server = https://mirror.morgan.kr/archlinux/$repo/os/$arch
Server = http://mirror.siwoo.org/archlinux/$repo/os/$arch
Server = https://mirror.siwoo.org/archlinux/$repo/os/$arch
Server = http://mirror.yuki.net.uk/archlinux/$repo/os/$arch
Server = https://mirror.yuki.net.uk/archlinux/$repo/os/$arch
# Spain
Server = http://es.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://es.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://mirror.cloroformo.org/archlinux/$repo/os/$arch
Server = http://mirror.librelabucm.org/archlinux/$repo/os/$arch
Server = https://mirror.librelabucm.org/archlinux/$repo/os/$arch
Server = http://mirrors.marquitos.space/archlinux/$repo/os/$arch
Server = https://mirrors.marquitos.space/archlinux/$repo/os/$arch
Server = https://nox.panibrez.com/archlinux/$repo/os/$arch
Server = http://mirror.raiolanetworks.com/archlinux/$repo/os/$arch
Server = https://mirror.raiolanetworks.com/archlinux/$repo/os/$arch
Server = http://ftp.rediris.es/mirror/archlinux/$repo/os/$arch
# Sweden
Server = http://mirror.accum.se/mirror/archlinux/$repo/os/$arch
Server = https://mirror.accum.se/mirror/archlinux/$repo/os/$arch
Server = https://mirror.braindrainlan.nu/archlinux/$repo/os/$arch
Server = http://ftpmirror.infania.net/mirror/archlinux/$repo/os/$arch
Server = https://ftp.ludd.ltu.se/mirrors/archlinux/$repo/os/$arch
Server = http://ftp.lysator.liu.se/pub/archlinux/$repo/os/$arch
Server = https://ftp.lysator.liu.se/pub/archlinux/$repo/os/$arch
Server = http://mirror.bahnhof.net/pub/archlinux/$repo/os/$arch
Server = https://mirror.bahnhof.net/pub/archlinux/$repo/os/$arch
Server = http://ftp.myrveln.se/pub/linux/archlinux/$repo/os/$arch
Server = https://ftp.myrveln.se/pub/linux/archlinux/$repo/os/$arch
Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch
# Switzerland
Server = http://pkg.adfinis-on-exoscale.ch/archlinux-pkgbuild/$repo/os/$arch
Server = http://pkg.adfinis-on-exoscale.ch/archlinux/$repo/os/$arch
Server = https://pkg.adfinis-on-exoscale.ch/archlinux-pkgbuild/$repo/os/$arch
Server = https://pkg.adfinis-on-exoscale.ch/archlinux/$repo/os/$arch
Server = http://pkg.adfinis.com/archlinux/$repo/os/$arch
Server = https://pkg.adfinis.com/archlinux/$repo/os/$arch
Server = http://ch.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://ch.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.init7.net/archlinux/$repo/os/$arch
Server = https://mirror.init7.net/archlinux/$repo/os/$arch
Server = http://mirror.metanet.ch/archlinux/$repo/os/$arch
Server = https://mirror.metanet.ch/archlinux/$repo/os/$arch
Server = http://mirror.puzzle.ch/archlinux/$repo/os/$arch
Server = https://mirror.puzzle.ch/archlinux/$repo/os/$arch
Server = https://theswissbay.ch/archlinux/$repo/os/$arch
Server = https://mirror.ungleich.ch/mirror/packages/archlinux/$repo/os/$arch
Server = https://mirror.worldhotspot.org/archlinux/$repo/os/$arch
# Taiwan
Server = http://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
Server = https://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
Server = http://archlinux.ccns.ncku.edu.tw/archlinux/$repo/os/$arch
Server = http://tw.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://tw.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://free.nchc.org.tw/arch/$repo/os/$arch
Server = https://free.nchc.org.tw/arch/$repo/os/$arch
Server = https://ncuesaweb.ncue.edu.tw/linux/archlinux/$repo/os/$arch
Server = http://archlinux.cs.nycu.edu.tw/$repo/os/$arch
Server = https://archlinux.cs.nycu.edu.tw/$repo/os/$arch
Server = http://ftp.tku.edu.tw/Linux/ArchLinux/$repo/os/$arch
Server = http://mirror.twds.com.tw/archlinux/$repo/os/$arch
Server = https://mirror.twds.com.tw/archlinux/$repo/os/$arch
Server = http://ftp.yzu.edu.tw/Linux/archlinux/$repo/os/$arch
Server = https://ftp.yzu.edu.tw/Linux/archlinux/$repo/os/$arch
# Thailand
Server = https://mirror.cyberbits.asia/archlinux/$repo/os/$arch
Server = http://mirror.kku.ac.th/archlinux/$repo/os/$arch
Server = https://mirror.kku.ac.th/archlinux/$repo/os/$arch
Server = http://mirror2.totbb.net/archlinux/$repo/os/$arch
# TÃ¼rkiye
Server = http://ftp.linux.org.tr/archlinux/$repo/os/$arch
Server = http://depo.turkiye.linux.web.tr/archlinux/$repo/os/$arch
Server = https://depo.turkiye.linux.web.tr/archlinux/$repo/os/$arch
Server = http://mirror.timtal.com.tr/archlinux/$repo/os/$arch
Server = https://mirror.timtal.com.tr/archlinux/$repo/os/$arch
Server = http://mirror.veriteknik.net.tr/archlinux/$repo/os/$arch
# Ukraine
Server = http://archlinux.astra.in.ua/$repo/os/$arch
Server = https://archlinux.astra.in.ua/$repo/os/$arch
Server = http://repo.hyron.dev/archlinux/$repo/os/$arch
Server = https://repo.hyron.dev/archlinux/$repo/os/$arch
Server = http://fastmirror.pp.ua/archlinux/$repo/os/$arch
Server = https://fastmirror.pp.ua/archlinux/$repo/os/$arch
Server = http://archlinux.ip-connect.vn.ua/$repo/os/$arch
Server = https://archlinux.ip-connect.vn.ua/$repo/os/$arch
Server = http://mirror.mirohost.net/archlinux/$repo/os/$arch
Server = https://mirror.mirohost.net/archlinux/$repo/os/$arch
Server = http://mirrors.nix.org.ua/linux/archlinux/$repo/os/$arch
Server = https://mirrors.nix.org.ua/linux/archlinux/$repo/os/$arch
# United Kingdom
Server = http://archlinux.uk.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = https://archlinux.uk.mirror.allworldit.com/archlinux/$repo/os/$arch
Server = http://mirror.bytemark.co.uk/archlinux/$repo/os/$arch
Server = https://mirror.bytemark.co.uk/archlinux/$repo/os/$arch
Server = http://gb.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://gb.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://london.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirrors.gethosted.online/archlinux/$repo/os/$arch
Server = https://mirrors.gethosted.online/archlinux/$repo/os/$arch
Server = http://mirrors.manchester.m247.com/arch-linux/$repo/os/$arch
Server = http://mirrors.melbourne.co.uk/archlinux/$repo/os/$arch
Server = https://mirrors.melbourne.co.uk/archlinux/$repo/os/$arch
Server = http://mirror.infernocomms.net/archlinux/$repo/os/$arch
Server = https://mirror.infernocomms.net/archlinux/$repo/os/$arch
Server = http://www.mirrorservice.org/sites/ftp.archlinux.org/$repo/os/$arch
Server = https://www.mirrorservice.org/sites/ftp.archlinux.org/$repo/os/$arch
Server = http://mirror.netweaver.uk/archlinux/$repo/os/$arch
Server = https://mirror.netweaver.uk/archlinux/$repo/os/$arch
Server = http://lon.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://lon.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = http://arch.serverspace.co.uk/arch/$repo/os/$arch
Server = https://repo.slithery.uk/$repo/os/$arch
Server = https://mirror.st2projects.com/archlinux/$repo/os/$arch
Server = http://mirrors.ukfast.co.uk/sites/archlinux.org/$repo/os/$arch
Server = https://mirrors.ukfast.co.uk/sites/archlinux.org/$repo/os/$arch
Server = http://mirror.cov.ukservers.com/archlinux/$repo/os/$arch
Server = https://mirror.cov.ukservers.com/archlinux/$repo/os/$arch
Server = http://mirror.vinehost.net/archlinux/$repo/os/$arch
Server = https://mirror.vinehost.net/archlinux/$repo/os/$arch
# United States
Server = http://mirrors.acm.wpi.edu/archlinux/$repo/os/$arch
Server = http://mirror.adectra.com/archlinux/$repo/os/$arch
Server = https://mirror.adectra.com/archlinux/$repo/os/$arch
Server = http://mirrors.advancedhosters.com/archlinux/$repo/os/$arch
Server = http://mirrors.aggregate.org/archlinux/$repo/os/$arch
Server = http://il.us.mirror.archlinux-br.org/$repo/os/$arch
Server = http://mirror.arizona.edu/archlinux/$repo/os/$arch
Server = https://mirror.arizona.edu/archlinux/$repo/os/$arch
Server = http://arlm.tyzoid.com/$repo/os/$arch
Server = https://arlm.tyzoid.com/$repo/os/$arch
Server = https://mirror.ava.dev/archlinux/$repo/os/$arch
Server = http://mirrors.bjg.at/arch/$repo/os/$arch
Server = https://mirrors.bjg.at/arch/$repo/os/$arch
Server = http://mirrors.bloomu.edu/archlinux/$repo/os/$arch
Server = https://mirrors.bloomu.edu/archlinux/$repo/os/$arch
Server = http://ca.us.mirror.archlinux-br.org/$repo/os/$arch
Server = http://mirrors.cat.pdx.edu/archlinux/$repo/os/$arch
Server = http://mirror.cc.columbia.edu/pub/linux/archlinux/$repo/os/$arch
Server = http://us.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://us.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://mirror.clarkson.edu/archlinux/$repo/os/$arch
Server = https://mirror.clarkson.edu/archlinux/$repo/os/$arch
Server = http://mirror.colonelhosting.com/archlinux/$repo/os/$arch
Server = https://mirror.colonelhosting.com/archlinux/$repo/os/$arch
Server = http://arch.mirror.constant.com/$repo/os/$arch
Server = https://arch.mirror.constant.com/$repo/os/$arch
Server = http://mirror.cs.pitt.edu/archlinux/$repo/os/$arch
Server = http://mirror.cs.vt.edu/pub/ArchLinux/$repo/os/$arch
Server = http://mirror.cybersecurity.nmt.edu/archlinux/$repo/os/$arch
Server = https://mirror.cybersecurity.nmt.edu/archlinux/$repo/os/$arch
Server = http://distro.ibiblio.org/archlinux/$repo/os/$arch
Server = http://mirror.es.its.nyu.edu/archlinux/$repo/os/$arch
Server = http://mirror.ette.biz/archlinux/$repo/os/$arch
Server = https://mirror.ette.biz/archlinux/$repo/os/$arch
Server = http://codingflyboy.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://coresite.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://forksystems.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://irltoolkit.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://mirror.fcix.net/archlinux/$repo/os/$arch
Server = http://mnvoip.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://nnenix.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://nocix.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://ohioix.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://opencolo.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://ridgewireless.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://southfront.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://uvermont.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://volico.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://ziply.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://codingflyboy.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://coresite.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://forksystems.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://irltoolkit.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://mirror.fcix.net/archlinux/$repo/os/$arch
Server = https://mnvoip.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://nnenix.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://nocix.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://ohioix.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://opencolo.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://ridgewireless.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://southfront.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://uvermont.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://volico.mm.fcix.net/archlinux/$repo/os/$arch
Server = https://ziply.mm.fcix.net/archlinux/$repo/os/$arch
Server = http://mirror.fossable.org/archlinux/$repo/os/$arch
Server = https://america.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirrors.gigenet.com/archlinux/$repo/os/$arch
Server = http://arch.goober.cloud/$repo/os/$arch
Server = https://arch.goober.cloud/$repo/os/$arch
Server = http://www.gtlib.gatech.edu/pub/archlinux/$repo/os/$arch
Server = https://mirror.hodgepodge.dev/archlinux/$repo/os/$arch
Server = http://mirror.hostup.org/archlinux/$repo/os/$arch
Server = https://mirror.hostup.org/archlinux/$repo/os/$arch
Server = http://arch.hu.fo/archlinux/$repo/os/$arch
Server = https://arch.hu.fo/archlinux/$repo/os/$arch
Server = http://repo.ialab.dsu.edu/archlinux/$repo/os/$arch
Server = https://repo.ialab.dsu.edu/archlinux/$repo/os/$arch
Server = http://mirrors.iu13.net/archlinux/$repo/os/$arch
Server = https://mirrors.iu13.net/archlinux/$repo/os/$arch
Server = https://arch.mirror.k0.ae/$repo/os/$arch
Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = http://mirror.dal10.us.leaseweb.net/archlinux/$repo/os/$arch
Server = http://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
Server = http://mirror.sfo12.us.leaseweb.net/archlinux/$repo/os/$arch
Server = http://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.dal10.us.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.mia11.us.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.sfo12.us.leaseweb.net/archlinux/$repo/os/$arch
Server = https://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
Server = http://mirrors.liquidweb.com/archlinux/$repo/os/$arch
Server = http://mirror.lty.me/archlinux/$repo/os/$arch
Server = https://mirror.lty.me/archlinux/$repo/os/$arch
Server = http://mirrors.lug.mtu.edu/archlinux/$repo/os/$arch
Server = https://mirrors.lug.mtu.edu/archlinux/$repo/os/$arch
Server = https://m.lqy.me/arch/$repo/os/$arch
Server = http://archlinux.macarne.com/$repo/os/$arch
Server = https://archlinux.macarne.com/$repo/os/$arch
Server = http://mirror.math.princeton.edu/pub/archlinux/$repo/os/$arch
Server = http://mirror.metrocast.net/archlinux/$repo/os/$arch
Server = http://mirror.kaminski.io/archlinux/$repo/os/$arch
Server = https://mirror.kaminski.io/archlinux/$repo/os/$arch
Server = http://iad.mirrors.misaka.one/archlinux/$repo/os/$arch
Server = https://iad.mirrors.misaka.one/archlinux/$repo/os/$arch
Server = http://repo.miserver.it.umich.edu/archlinux/$repo/os/$arch
Server = http://mirrors.mit.edu/archlinux/$repo/os/$arch
Server = https://mirrors.mit.edu/archlinux/$repo/os/$arch
Server = http://us.arch.niranjan.co/$repo/os/$arch
Server = https://us.arch.niranjan.co/$repo/os/$arch
Server = http://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
Server = http://archmirror1.octyl.net/$repo/os/$arch
Server = https://archmirror1.octyl.net/$repo/os/$arch
Server = http://ftp.osuosl.org/pub/archlinux/$repo/os/$arch
Server = https://ftp.osuosl.org/pub/archlinux/$repo/os/$arch
Server = http://arch.mirrors.pair.com/$repo/os/$arch
Server = https://mirror.pilotfiber.com/archlinux/$repo/os/$arch
Server = http://dfw.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = http://iad.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = http://ord.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://dfw.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://iad.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://ord.mirror.rackspace.com/archlinux/$repo/os/$arch
Server = http://mirrors.radwebhosting.com/archlinux/$repo/os/$arch
Server = https://mirrors.radwebhosting.com/archlinux/$repo/os/$arch
Server = http://plug-mirror.rcac.purdue.edu/archlinux/$repo/os/$arch
Server = https://plug-mirror.rcac.purdue.edu/archlinux/$repo/os/$arch
Server = http://mirrors.rit.edu/archlinux/$repo/os/$arch
Server = https://mirrors.rit.edu/archlinux/$repo/os/$arch
Server = http://mirrors.rutgers.edu/archlinux/$repo/os/$arch
Server = https://mirrors.rutgers.edu/archlinux/$repo/os/$arch
Server = http://mirror.siena.edu/archlinux/$repo/os/$arch
Server = http://mirrors.sonic.net/archlinux/$repo/os/$arch
Server = https://mirrors.sonic.net/archlinux/$repo/os/$arch
Server = http://mirror.phx1.us.spryservers.net/archlinux/$repo/os/$arch
Server = https://mirror.phx1.us.spryservers.net/archlinux/$repo/os/$arch
Server = http://arch.mirror.square-r00t.net/$repo/os/$arch
Server = https://arch.mirror.square-r00t.net/$repo/os/$arch
Server = http://mirror.stjschools.org/arch/$repo/os/$arch
Server = https://mirror.stjschools.org/arch/$repo/os/$arch
Server = http://ftp.sudhip.com/archlinux/$repo/os/$arch
Server = https://ftp.sudhip.com/archlinux/$repo/os/$arch
Server = http://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
Server = https://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
Server = https://mirror.theash.xyz/arch/$repo/os/$arch
Server = https://mirror.tmmworkshop.com/archlinux/$repo/os/$arch
Server = http://mirror.umd.edu/archlinux/$repo/os/$arch
Server = https://mirror.umd.edu/archlinux/$repo/os/$arch
Server = http://mirrors.vectair.net/archlinux/$repo/os/$arch
Server = https://mirrors.vectair.net/archlinux/$repo/os/$arch
Server = http://mirror.vtti.vt.edu/archlinux/$repo/os/$arch
Server = http://wcbmedia.io:8000/$repo/os/$arch
Server = http://mirrors.xmission.com/archlinux/$repo/os/$arch
Server = http://mirrors.xtom.com/archlinux/$repo/os/$arch
Server = https://mirrors.xtom.com/archlinux/$repo/os/$arch
Server = https://mirror.zackmyers.io/archlinux/$repo/os/$arch
Server = https://zxcvfdsa.com/arch/$repo/os/$arch
# Uzbekistan
Server = http://mirror.dc.uz/arch/$repo/os/$arch
Server = https://mirror.dc.uz/arch/$repo/os/$arch
# Vietnam
Server = http://mirror.bizflycloud.vn/archlinux/$repo/os/$arch
Server = https://mirrors.huongnguyen.dev/arch/$repo/os/$arch
Server = http://mirror.kirbee.tech/archlinux/$repo/os/$arch
Server = https://mirror.kirbee.tech/archlinux/$repo/os/$arch
Server = https://mirrors.nguyenhoang.cloud/archlinux/$repo/os/$arch
XIT
# PackageInst----------------------------------------------------------------------------------------------------
for pakges in\
 linux-xanmod-edge linux-xanmod-edge-headers ramroot-btrfs\
 pipewire-git libpipewire-git wireplumber-git libwireplumber-git\
 paru-git mc-git pi-hole-standalone snowflake-pt-proxy boinc-nox
#  hyprland-git eww-git flatpak
do paru -Syyu --noconfirm $pakges
done
for pakgis in\
 linux linux-headers
do paru -Rns --noconfirm $pakgis
done
sudo bootctl update #SystemD-Boot
sudo grub-mkconfig -o /boot/grub/grub.cfg #GRUB
if [[ "$1" == "N" ]]; then
 paru -Syyu --noconfirm nvidia-open-dkms-git opencl-nvidia-beta nvidia-utils-beta nvidia-settings-beta nvidia-vpf-git nvflash
fi
if [[ "$1" == "A" ]]; then
 paru -Syyu --noconfirm opencl-amd-dev amdvbflash
fi
# ZRAMnRamRoot----------------------------------------------------------------------------------------------------
sudo touch /usr/bin/JPzram
sudo chmod 777 /usr/bin/JPzram
sudo cat > /usr/bin/JPzram << "XIT"
#!/bin/zsh
if DEVICES=$(grep -e "^/dev/zram" /proc/swaps | awk '{print $1}'); then
    for i in $DEVICES; do
        swapoff $i
    done
fi
if lsmod | grep -q zram; then
    rmmod zram
fi
if [[ "$1" == "Y" ]]; then
modprobe zram
mem=$(((LC_ALL=C free | grep -e "^Mem:" | sed -e "s/^Mem: *//" -e "s/  *.*//") * 1024))
echo $mem > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon -p 32765 /dev/zram0
fi
XIT
sudo touch /lib/systemd/system/JPzram.service
sudo chmod 777 /lib/systemd/system/JPzram.service
sudo cat > /lib/systemd/system/JPzram.service << "XIT"
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
#sudo flatpak remote-add --if-not-exists --noninteractive flathub https://dl.flathub.org/repo/flathub.flatpakrepo
#sudo flatpak remote-add --if-not-exists --noninteractive flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# Pi-Hole----------------------------------------------------------------------------------------------------
sudo touch /etc/pihole/pihole-FTL.conf
sudo chmod 777 /etc/pihole/pihole-FTL.conf
sudo cat > /etc/pihole/pihole-FTL.conf << "XIT"
RATE_LIMIT=0/0
XIT
sudo touch /etc/pihole/adlists.list
sudo chmod 777 /etc/pihole/adlists.list
sudo cat > /etc/pihole/adlists.list << "XIT"
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
sudo touch /etc/tor/torrc
sudo chmod 777 /etc/tor/torrc
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
sudo touch /etc/systemd/system/fstrim.timer.d/override.conf
sudo chmod 777 /etc/systemd/system/fstrim.timer.d/override.conf
sudo cat > /etc/systemd/system/fstrim.timer.d/override.conf << "XIT"
[Timer]
OnCalendar=
OnCalendar=daily
XIT
sudo systemctl enable --now fstrim.timer
sudo touch /etc/systemd/timesyncd.conf
sudo chmod 777 /etc/systemd/timesyncd.conf
sudo cat > /etc/systemd/timesyncd.conf << "XIT"
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
sudo cat > /etc/sysctl.conf << "XIT"
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
sudo cat > /etc/systemd/resolved.conf << "XIT"
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
echo Done!