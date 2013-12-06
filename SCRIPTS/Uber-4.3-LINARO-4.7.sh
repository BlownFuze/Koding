#!/bin/bash
#Cl3Kener's UBER 4.3 Script

# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
pnk=$(tput bold ; tput setaf 5) # pink
yel=$(tput bold ; tput setaf 3) # yellow
pur=$(tput setaf 5) # purple
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldyel=${txtbld}$(tput bold ; tput setaf 3) # yellow
bldblu=${txtbld}$(tput setaf 4) # blue
bldpur=${txtbld}$(tput setaf 5) # purple
bldpnk=${txtbld}$(tput bold ; tput setaf 5) # pink
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset

# Use this line to change Defconfig
DEFCONFIG=cyanogenmod_hercules_defconfig

export KERNELDIR=~/android/kernel/
export INITRAMFS_DEST=~/android/kernel/usr/initramfs
export PACKAGEDIR=~/android/kernel/OUT
export Meta=~/android/kernel/Cl3Kener/META-INF
export Etc=~/android/kernel/Cl3Kener/etc
export Scripts=~/android/kernel/Cl3Kener/scripts
export ARCH=arm
export CROSS_COMPILE=~/android/kernel/toolchains/linaro-4.7/bin/arm-eabi-

echo "${bldyel}                                          ${txtrst}"
echo "${bldyel}                                          ${txtrst}"
echo "${bldyel} ________________________________________ ${txtrst}"
echo "${bldyel}|                                        |${txtrst}"
echo "${bldyel}| _|    _|  _|_|_|    _|_|_|_|  _|_|_|   |${txtrst}"
echo "${bldyel}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldyel}| _|    _|  _|_|_|    _|_|_|    _|_|_|   |${txtrst}"
echo "${bldyel}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldyel}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldyel}|   _|_|    _|_|_|    _|_|_|_|  _|    _| |${txtrst}"
echo "${bldyel}|________________________________________|${txtrst}"
echo "${bldyel}                                          ${txtrst}"
echo "${bldyel}                                          ${txtrst}"

echo "${bldcya} Remove old Package Files ${txtrst}"
rm -rf $PACKAGEDIR/*

echo "${bldpur} Setup Package Directory ${txtrst}"
mkdir -p $PACKAGEDIR/system/lib/modules

echo "${bldgrn} Setup Init.d Directory ${txtrst}"
mkdir -p $PACKAGEDIR/system/etc

echo "${bldyel} Setup Scripts Directory ${txtrst}"
mkdir -p $PACKAGEDIR/scripts

echo "${bldblu} Remove old zImage ${txtrst}"
rm $PACKAGEDIR/zImage
rm arch/arm/boot/zImage

echo "${bldcya} Remove old ramdisk ${txtrst}"
rm $KERNELDIR/ramdisk.img.gz

echo -e "${bldred} Removing pesky backup files ${txtrst}"
cd ~/android/kernel
find ./ -name '*~' | xargs rm

echo "${bldpnk} Make the kernel ${txtrst}"
make $DEFCONFIG

echo "${bldyel} Clean Environment ${txtrst}"
make clean
rm $KERNELDIR/.version
rm $KERNELDIR/.config.old
make menuconfig

echo "${bldcya} Compiling ${txtrst}"
script -q ~/Compile.log -c " 
make -j16 "

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then

	echo "${bldgrn} Copy modules to OUT ${txtrst}"
	cp -a $(find . -name *.ko -print |grep -v initramfs) $PACKAGEDIR/system/lib/modules/

	echo "${bldred} Copy zImage to OUT ${txtrst}"
	cp $KERNELDIR/arch/arm/boot/zImage $PACKAGEDIR/zImage

	echo "${bldblu} Packaging Ramdisk ${txtrst}"
	cd $KERNELDIR/
	mkbootfs ./ramdisk | gzip > ramdisk.img.gz

	echo "${bldcya} Make boot.img ${txtrst}"
	cp $KERNELDIR/ramdisk.img.gz $PACKAGEDIR/ramdisk.img.gz
	cd $PACKAGEDIR
	mkbootimg --cmdline 'console = null androidboot.hardware=qcom user_debug=31 zcache' --kernel $PACKAGEDIR/zImage --ramdisk $PACKAGEDIR/ramdisk.img.gz --base 0x40400000 --pagesize 2048 --ramdiskaddr 0x41800000 --output $PACKAGEDIR/boot.img

	echo "${bldgrn} Import of META-INF ${txtrst}"
	cp -R $Meta $PACKAGEDIR

	echo "${bldcya} Import Init.d Tweaks ${txtrst}"
	cp -R $Etc/init.d $PACKAGEDIR/system/etc
	cp $Etc/sysctl.conf $PACKAGEDIR/system/etc/sysctl.conf

	echo "${bldblu} Import Scripts ${txtrst}"
	cp -R $Scripts $PACKAGEDIR

	export curdate=`date "+%m-%d-%Y"`
        cp ~/Compile.log ~/android/Logs/Completed-Uber-4.3-LINARO-$curdate.log
        rm ~/Compile.log

	cd $PACKAGEDIR
	rm ramdisk.img.gz
	rm zImage
	rm ../UBER-4.3-LINARO-Cl3Kener-Nightly*.zip\
	rm -R .fr-7q5stU
	zip -r ../UBER-4.3-LINARO-Cl3Kener-Nightly-$curdate.zip .

	echo "${bldgrn}                                          ${txtrst}"
	echo "${bldgrn}                                          ${txtrst}"
	echo "${bldgrn} ________________________________________ ${txtrst}"
	echo "${bldgrn}|                                        |${txtrst}"
	echo "${bldgrn}| _|    _|  _|_|_|    _|_|_|_|  _|_|_|   |${txtrst}"
	echo "${bldgrn}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldgrn}| _|    _|  _|_|_|    _|_|_|    _|_|_|   |${txtrst}"
	echo "${bldgrn}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldgrn}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldgrn}|   _|_|    _|_|_|    _|_|_|_|  _|    _| |${txtrst}"
	echo "${bldgrn}|________________________________________|${txtrst}"
	echo "${bldgrn}                                          ${txtrst}"
	echo "${bldgrn}                                          ${txtrst}"

	echo "${bldgrn} Kernel has completed!!! MAKE SURE THAT YOU REALIZE THE ZIP FILE CREATED IS NOT READY. YOU MUST APPEND THE RAMDISK MANUALLY BECAUSE THIS SERVER DOESN'T KNOW HOW ${txtrst}"

else
	echo "${bldred}                                          ${txtrst}"
	echo "${bldred}                                          ${txtrst}"
	echo "${bldred} ________________________________________ ${txtrst}"
	echo "${bldred}|                                        |${txtrst}"
	echo "${bldred}| _|    _|  _|_|_|    _|_|_|_|  _|_|_|   |${txtrst}"
	echo "${bldred}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldred}| _|    _|  _|_|_|    _|_|_|    _|_|_|   |${txtrst}"
	echo "${bldred}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldred}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
	echo "${bldred}|   _|_|    _|_|_|    _|_|_|_|  _|    _| |${txtrst}"
	echo "${bldred}|________________________________________|${txtrst}"
	echo "${bldred}                                          ${txtrst}"
	echo "${bldred}                                          ${txtrst}"
	echo "{$bldred} KERNEL IMAGE DID NOT BUILD PROPERLY! Check Compile log! ${txtrst}"
	export curdate=`date "+%m-%d-%Y"`
	cp ~/Compile.log ~/android/Logs/Failed-Uber-4.4-LINARO-$curdate.log
fi;

read -p "Press ENTER to Exit"