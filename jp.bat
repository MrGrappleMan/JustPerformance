@echo off
cd C:\
setlocal enabledelayedexpansion
title JustPerformance
net session
set el=!errorlevel!
if !el!==2 (
color 04
cls
echo Please run with administrator rights!
echo Press any key to exit...
pause>nul
exit
)
set spr=echo ______________________________________________________________________________________________________________________________________________________________________________________________________
set svcopt="if !el!==1 (sc stop "!svcnme!" ^& sc config "!svcnme!" start=disabled) ^& if !el!==2 (sc start "!svcnme!" ^& sc config "!svcnme!" start=auto)"
set dsoren="%spr% ^& echo Options: ^& echo X.Return ^& echo 1.Disable ^& echo 2.Enable ^& choice /C 12X /N"
color 07
:home
cls
echo 	_________             _____                                                                             
echo 	______  /___  __________  /_                                                                            
echo 	___ _  /_  / / /_  ___/  __/_______            ________                                                 
echo 	/ /_/ / / /_/ /_(__  )/ /_ ___  __ \______________  __/___________________ _________ __________________ 
echo 	\____/  \____/ /____/ \__/ __  /_/ /  _ \_  ___/_  /_ _  __ \_  ___/_  __ `__ \  __ `/_  __ \  ___/  _ \
echo 	                           _  ____//  __/  /   _  __/ / /_/ /  /   _  / / / / / /_/ /_  / / / /__ /  __/
echo 	                           /_/     \___//_/    /_/    \____//_/    /_/ /_/ /_/\__,_/ /_/ /_/\___/ \___/
%spr%
echo Hello %username%! I not responsible for any data loss, malfunctioning or any kind of damage done to your device.
echo YOU have chosen to do this modification.
echo BEFORE YOU PROCEED, see the script on GitHub so that you can debug your system easily.
echo Exit only by using the provided option.
%spr%
echo Options:
echo X.Exit
echo 1.Apply Common Tweaks
echo 2.Search Indexing (WSearch)
echo 3.Printing (Spooler, Fax)
echo 4.Windows Image Acquisition (StiSvc)
echo 5.Blutooth (BTAGService, bthserv)
echo 6.Remote Desktop (SessionEnv, TermService, UmRdpService)
echo 7.Remote Registry (RemoteRegistry)
echo 8.Time Tweaks
echo 9.System accuracy(HPET and Dynamic Ticks)
echo A.Hypervisor
echo B.Pagedisk Creator
echo C.Audio
echo D.Import Dedicated Power Plans
choice /C 123456789ABCDEX /N
cls
if !el!==1 (
	echo Name: Main Tweaks
	echo Applies tweaks that disable visual effects, boosts network and system performance,
	echo Disables unnecessary elements, prioritizes games, enables useful navigation methods
	echo and additional settings that many users may find helpful.
	echo Exit only by using the provided option for removal of cache and no leftovers of the script.
	echo Consider rebooting after exiting for all changes to take effect.
	%spr%
	echo Options:
	echo X.Return
	echo 1.Use
	choice /C 1X /N
	if !el!==1 (
		regedit /s jp.reg
		::If you doubt the line below this, reddit.com/r/computers/s/Pa11pjBory
		sc start "SysMain">nul & sc config "SysMain" start=auto>nul
	)
	goto home
)
if !el!==2 (
	echo Name: Windows Search(WSearch)
	echo Type: Service
	echo Indexes and searches files. Improves the speed of searches and provides more accurate results.
	echo By disabling it, searches would take some more time including explorer.exe, but would give a performance boost. If you use system utilites often,
	echo you can make a habit of opening them using Run.exe for fast access if you know their filenames. Desktop icons are also recommended.
	echo Use 'shell:AppsFolder' in run.exe to create shortcuts of UWP apps..
	!dsoren!
	set svcnme=WSearch
	!svcopt!
	goto home
)
if !el!==3 (
	echo Name: Printing(Spooler, Fax)
	echo Manages print jobs sent from the computer to the printer or print server.
	echo It can store multiple print jobs in the print queue or buffer retrieved by the printer or print server.
	echo Runs in the background regardless whether you have a printer or not.
	!dsoren!
	set svcnme=Spooler
	!svcopt!
	set svcnme=Fax
	!svcopt!
	goto home
)
if !el!==4 (
	echo Name: Windows Image Acquisition(StiSvc)
	echo Waits until you press the button on your scanner and then manages the process of getting the image where it needs to go.
	echo This also affects communication with digital cameras and video cameras that you connect directly to your computer, so be aware of that if you need this function.
	!dsoren!
	set svcnme=StiSvc
	!svcopt!
	goto home
)
if !el!==5 (
	echo Name: Blutooth(BTAGService, bthserv)
	echo BTAGService: Service supporting the audio gateway role of the Bluetooth Handsfree Profile.
	echo bthserv: The Bluetooth service supports discovery and association of remote Bluetooth devices.
	echo Stopping or disabling this service may cause paired Bluetooth devices to fail to operate properly and prevent new devices from being discovered or paired.
	echo This can also serve as a safety measure from attacks. eg. KNOB, BLUFFS.
	!dsoren!
	set svcnme=BTAGService
	!svcopt!
	set svcnme=bthserv
	!svcopt!
	goto home
)
if !el!==6 (
	echo Name: Remote Desktop(SessionEnv, TermService, UmRdpService)
	echo These services make remote control of your computer possible.
	echo If you don't use the remote desktop functionality of Windows, disable all three of these services.
	echo However, Microsoft Support can use remote desktop technology to help fix issues you might be experiencing.
	echo Windows's Remote support won't work if you disable these services.
	echo This may also be a serious security issue and is used in fake support scams.
	echo So, disabling these services can also help improve the security and performance of your computer.
	echo You may use Chrome Remote Desktop or most other 3rd party apps without any issues.
	!dsoren!
	set svcnme=SessionEnv
	!svcopt!
	set svcnme=TermService
	!svcopt!
	set svcnme=UmRdpService
	!svcopt!
	goto home
)
if !el!==7 (
	echo Name: Remote Registry(RemoteRegistry)
	echo Enables remote users to modify registry settings on this computer.
	echo If this service is stopped, the registry can be modified only by users on this computer.
	echo If this service is disabled, any services that explicitly depend on it will fail to start.
	echo Use only if you want to make registry changes remotely to your computer.
	echo Leaving it enabled may compromise your security.
	!dsoren!
	set svcnme=StiSvc
	!svcopt!
	goto home
)
if !el!==8 (
	echo Name: NTP Tweaks
	echo Modifies w32tm to refresh system time every hour.
	echo Uses many reliable NTP servers along with backup.
	echo Use if not using a device provided by an organisation.
	%spr%
	echo Options:
	echo X.Return
	echo 1.Apply (Preferred for most users)
	choice /C 1X /N
	if !el!==1 (w32tm /config /syncfromflags:manual /manualpeerlist:"time.google.com time1.google.com time2.google.com time3.google.com time4.google.com time.windows.com time.cloudflare.com 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org time.facebook.com time1.facebook.com time2.facebook.com time3.facebook.com time4.facebook.com time5.facebook.com time.apple.com time1.apple.com time2.apple.com time3.apple.com time4.apple.com time5.apple.com time6.apple.com time7.apple.com" /reliable:YES /update & net stop w32time & net start w32time & w32tm /resync /force)
	goto home
)
if !el!==9 (
	echo Name: System accuracy(HPET and Dynamic Ticks)
	echo Type: Program
	echo This command forces the kernel timer to constantly poll for interrupts instead of wait for them.
	echo Dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance.
	echo Do not change on laptops or as a result, battery life will affected.
	!dsoren!
	if !el!==1 (bcdedit /set disabledynamictick no & bcdedit /set useplatformclock true)
	if !el!==2 (bcdedit /set disabledynamictick yes & bcdedit /deletevalue useplatformclock)
	goto home
)
if !el!==10 (
	echo Name: Hypervisor(using bcdedit)
	echo Type: Program
	echo Used for VMs, Emulators and Subsystems.
	echo Useless and consumes extra resources if not utilized by any program.
	echo Disable if not in use.
	!dsoren!
	if !el!==1 (bcdedit /set hypervisorlaunchtype off)
	if !el!==2 (bcdedit /set hypervisorlaunchtype on)
	goto home
)
if !el!==11 (
	echo Name: Pagedisk
	echo This can make an NTFS partition with 2MB allocation unit size. Use the partition to keep a pagefile in it,
	echo giving your device a faster read and write speed to the file compared to storing it on a regular 4KB partition.
	echo Use a partition of size^>=[2 x Physical RAM] and be located on a faster storage type.
	echo Use diskmgmt.msc for finding your target partition.
	echo WARNING: Formatting the partition will erase all data on it.
	echo Ensure you have backed up any important data before proceeding.
	%spr%
	echo Options:
	echo X.Return
	echo 1.Proceed
	choice /C 1X /N
	if !el!==1 (
		echo list disk>jperftmp
		diskpart /s jperftmp
		set /p disk=Disk Number:
		echo select disk !disk!>jperftmp
		echo list partition>>jperftmp
		diskpart /s jperftmp
		set /p part=Partition Number:
		set /p labl=New Partition Name:
		echo select disk %disk%>jperftmp
		echo select partition %part%>>jperftmp
		echo format quick unit=2048K fs=ntfs label="!labl!">>jperftmp
		diskpart /s jperftmp
		del jperftmp
		goto home
	)
)
if !el!==12 (
	echo Name: Audio(Audiosrv,AudioEndpointBuilder)
	echo Controls and enables functionality of audio on Windows.
	!dsoren!
	set svcnme=Audiosrv
	!svcopt!
	set svcnme=AudioEndpointBuilder
	!svcopt!
	goto home
)
if !el!==13 (
	echo Name: Dedicated Power Plans
	echo Overheating is the cause of how your system handles heavy load, which is modified by this.
	echo Use your UEFI/BIOS setup utility if it has any options or SpeedFan for boosting fan speed. Laptop manufacturers may keep it locked.
	echo It is recommended to switch the Power Plan from JPIntensive to JPNormal once your resource intensive task(s) has been completed.
	echo Imports 2 power plans to powercfg.cpl. Use each power plan according to your needs only. Use the Intensive variant at your own risk.
	echo The automatic variant is the best variant for portable devices with a battery.
	echo JPNormal: Maximizes all options except for processor to use resources in a performant manner.
	echo JPIntensive: Device is forced to achieve the best possible performance.
	echo JPAutomatic: Power management and Performance are automatically determined comparatively better than Windows' Balanced power plan. 
	%spr%
	echo Options:
	echo X.Return
	echo 1.Import
	choice /C 1X /N
	if !el!==1 (
		powercfg.exe -import "C:\JPNormal.pow">nul
		powercfg.exe -import "C:\JPIntensive.pow">nul
		powercfg.exe -import "C:\JPAutomatic.pow">nul
	)
	goto home
)
net stop wuauserv>nul
del /F /S /Q %windir%\SoftwareDistribution\Download\*>nul
del /F /S /Q %tmp%\*>nul
del /F /S /Q %windir%\Temp\*>nul
del /F /S /Q %windir%\Prefetch\*>nul
ipconfig /flushdns>nul
ipconfig /registerdns>nul
ipconfig /release>nul
ipconfig /renew>nul
net start wuauserv>nul
endlocal
exit