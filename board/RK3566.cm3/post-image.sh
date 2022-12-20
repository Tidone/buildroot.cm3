#!/bin/dash

RKBIN=$BINARIES_DIR/rkbin
RKCHIP_LOADER=$2
RKCHIP=$2

# copy uboot variable file over
cp -a $BR2_EXTERNAL_RK3308_PATH/board/RK3566.cm3/uboot/vars.txt $BINARIES_DIR/

# copy overlays over
linuxDir=`find $BASE_DIR/build -name 'vmlinux' -type f | xargs dirname`
mkdir -p $BINARIES_DIR/rockchip/overlays
if [ -d ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay ]; then
  cp -a ${linuxDir}/arch/arm64/boot/dts/rockchip/overlay/*.dtbo $BINARIES_DIR/rockchip/overlays
fi

# Put the device trees into the correct location
mkdir -p $BINARIES_DIR/rockchip; cp -a $BINARIES_DIR/*.dtb $BINARIES_DIR/rockchip
$BASE_DIR/../support/scripts/genimage.sh -c $BR2_EXTERNAL_RK3308_PATH/board/RK3566.cm3/genimage.cfg

echo
echo
echo compilation done
echo
echo
echo
echo write your image to the using rkdeveloptool
echo use the following commands...
echo
echo 'sudo rkdeveloptool db rk356x_spl_loader_ddr1056_v1.10.111.bin'
echo 'sudo rkdeveloptool wl 0 buildroot/output/images/sdcard.img'
echo 'sudo rkdeveloptool rd'
echo
