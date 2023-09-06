# Rockchip CM3 and Pine64 SOQuartz Buildroot System

This repo generates a bootable 64-bit eMMC image for the RK3566 platform.
Based on buildroot, this directory is an external buildroot tree - it integrates into the main buildroot tree seamlessly.

## Differences from the Original Repo

This repo is forked from [Flatmax's RK3566 buildroot system](https://github.com/flatmax/buildroot.rockchip).
It is heavily modified to support a newer version of U-Boot.\
This enables us to use some fancy new U-Boot features, like compressed kernel images and better handling of U-Boot environments.
This branch uses the full Radxa 4.19 Kernel. Everything that works on the official Debian image, should work here too.


- Custom U-Boot v22.04
- Full Radxa Linux Kernel 4.19

# Caveats

This Kernel continuously spams the following messages on the serial output and on the Kernel logs:
```
[  144.113433] dwmmc_rockchip fe2b0000.dwmmc: could not set regulator OCR (-22)
[  144.113500] dwmmc_rockchip fe2b0000.dwmmc: failed to enable vmmc regulator
```
[This Kernel mailing list message](https://lore.kernel.org/lkml/20210805124650.GM26252@sirena.org.uk/T/) describes the same issue and some possible fixes.

# Initial Setup

Clone buildroot and this external tree:

```
cd yourPath
git clone git://git.busybox.net/buildroot buildroot
git clone https://github.com/Tidone/buildroot.cm3.git buildroot.cm3
cd buildroot && git checkout 2022.08
```

Install all requirements:
```
sudo apt install -y build-essential gcc g++ autoconf automake libtool bison flex gettext
sudo apt install -y patch texinfo wget git gawk curl lzma bc quilt expect
```

***The above instructions apply to Debian-based distros. Buildroot works on other distros, but installing the above dependencies is beyond the scope of this README; check your distro's package manager documentation.  Additionally a bash shell is required on distros where it is not the default.***


# Compiling

```
cd buildroot
git reset --hard
rm -f .applied_patches_list
source ../buildroot.cm3/setup.cm3.sh .
mkdir ../buildroot.dl
utils/brmake
```

# Installing

Write the image (`output/images/sdcard.img`) to the eMMC using `rkdeveloptool`

# Using

Connect to the console uart with a serial cable (1500000 Baud, 8n1). Or add the openssh-server pacakge to the buildsystem, then ssh in as user root, no password.

## Device Tree Overlays

This repo uses the default CM3-on-Raspberry-CM4-IO-Board Linux DTBO.\

## SSH RSA Keys

To use ssh, put your id_rsa.pub into the authorized_keys in the overlays directory. This will autoload your public RSA key to the embedded system so that you can login.
```
$ mkdir -p overlays/root/.ssh; chmod go-rwx overlays/root/.ssh
$ ls -ld overlays/root/.ssh
drwx------ 2 me me 4096 Aug  3  2016 overlays/root/.ssh
$ cat ~/.ssh/id_rsa.pub > overlays/root/.ssh/authorized_keys
$ ls -l overlays/root/.ssh/authorized_keys
-rw-r--r-- 1 me me 748 Feb 24 11:17 overlays/root/.ssh/authorized_keys
```
