#!/bin/bash

# Custom build script for Luv Kernel

# Constants
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# Define variables
KERNEL_DIR=$PWD
cd ..
mkdir out
cd $KERNEL_DIR
GCC_DIR=$OLDPWD
OUT_DIR=$OLDPWD/out
Anykernel_DIR=$KERNEL_DIR/AnyKernel3/
DATE=$(date +"%d%m%Y")
TIME=$(date +"-%H.%M.%S")
KERNEL_NAME="Luv-Kernel"
DEVICE="-kenzo-"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TIME"

BUILD_START=$(date +"%s")

# Cleanup before
rm -rf $Anykernel_DIR/*zip
rm -rf $Anykernel_DIR/Image.gz-dtb
rm -rf arch/arm64/boot/Image
rm -rf arch/arm64/boot/dts/qcom/kenzo-msm8956-mtp.dtb
rm -rf arch/arm64/boot/Image.gz
rm -rf arch/arm64/boot/Image.gz-dtb

# Export few variables
CROSS_COMPILE=$GCC_DIR/gcc/bin/aarch64-linux-gnu-
export KBUILD_BUILD_USER=You
export KBUILD_BUILD_HOST=Me
export CROSS_COMPILE
export ARCH="arm64"
export USE_CCACHE=1

# Finally build it
make clean && make mrproper
make luv_defconfig
make -j8

echo -e "$yellow***********************************************"
echo  "                Zipping up                    "
echo -e "***********************************************"

# Create the flashable zip
cp arch/arm64/boot/Image.gz-dtb $Anykernel_DIR
cd $Anykernel_DIR
zip -r9 $FINAL_ZIP.zip * -x .git README.md *placeholder
mv $FINAL_ZIP.zip $OUT_DIR
echo -e "$cyan***********************************************"
echo  "            Cleaning up the mess created               "
echo -e "***********************************************$default"

# Cleanup again
cd ../
rm -rf $Anykernel_DIR/Image.gz-dtb
rm -rf arch/arm64/boot/Image
rm -rf arch/arm64/boot/dts/qcom/kenzo-msm8956-mtp.dtb
rm -rf arch/arm64/boot/Image.gz
rm -rf arch/arm64/boot/Image.gz-dtb
make clean && make mrproper

# Build complete
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$default"
