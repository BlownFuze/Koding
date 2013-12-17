#!/bin/bash
#Cl3Kener's 4.4 Script

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
DEFCONFIG=cyanogenmod_quincyatt_defconfig

export KERNELDIR=~/android/kernel/
export INITRAMFS_DEST=~/android/kernel/usr/initramfs
export PACKAGEDIR=~/android/kernel/OUT
export Meta=~/android/kernel/Cl3Kener/META-INF
export Etc=~/android/kernel/Cl3Kener/etc
export Scripts=~/android/kernel/Cl3Kener/scripts
export BuildBoot=~/android/kernel/BuildBootUBER
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

echo "${bldpnk} Make the kernel ${txtrst}"
cd $KERNELDIR
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

	echo "${bldgrn} Import of META-INF ${txtrst}"
	cp -R $Meta $PACKAGEDIR

	echo "${bldcya} Import Init.d Tweaks ${txtrst}"
	cp -R $Etc/init.d $PACKAGEDIR/system/etc

	echo "${bldblu} Import Scripts ${txtrst}"
	cp -R $Scripts $PACKAGEDIR

	export curdate=`date "+%m-%d-%Y"`
        cp ~/Compile.log ~/android/Logs/Completed-Uber-4.4-LINARO-$curdate.log
        rm ~/Compile.log

	cd $PACKAGEDIR
	rm ../UBER-Android-4.4-LINARO-Cl3Kener-Nightly*.zip\
	rm -R .fr-7q5stU
	zip -r ../UBER-Android-4.4-LINARO-Cl3Kener-Nightly-$curdate.zip .

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
