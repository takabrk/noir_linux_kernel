#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#March 7,2024

. ./config

while getopts e: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
  esac
done
if  [ -e patches/linux/patch-$VERSIONPOINT ]; then
    rm -r patches/linux/patch-$VERSIONPOINT
fi
if  [ -e patches/linux/patch-$VERSIONPOINT.xz ]; then
    xz -k -d patches/linux/patch-$VERSIONPOINT.xz
fi

case $e_num in
#build noir.patch
    patch)
        truncate noir.patch --size 0
        truncate patches/noir_base/custom_config.patch --size 0

#build custom_config.patch
        diff -Naur /dev/null patches/noir_base/.config | sed 1i"diff --git a/.config b/.config\nnew file mode 100644\nindex 000000000000..dcbcaa389249" > patches/noir_base/custom_config.patch
        cat patches/linux/patch-$VERSIONPOINT \
            patches/noir_base/noir_base.patch \
            patches/noir_base/custom_config.patch \
            patches/other/linux-v6.7-zen1.patch \
            patches/other/patch-6.7-rc5-rt5.patch \
            patches/other/0001-futex-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-opcode.patch \
            patches/other/0001-winesync-Introduce-the-winesync-driver-and-character.patch \
            patches/other/0010-XANMOD-kconfig-add-500Hz-timer-interrupt-kernel-conf.patch \
            patches/other/0011-XANMOD-dcache-cache_pressure-50-decreases-the-rate-a.patch \
            patches/other/0012-XANMOD-mm-vmscan-vm_swappiness-30-decreases-the-amou.patch \
            patches/other/0001-bcachefs-6.7-merge-changes-from-dev-tree.patch \
            > noir.patch
           ;;
    vanilla)  
            wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-$VERSIONBASE.tar.xz
           ;;
    source)
           tar -Jxvf linux-$VERSIONBASE.tar.xz
           cd linux-$VERSIONBASE
           patch -p1 < ../noir.patch
           cd ../
           mv linux-$VERSIONBASE linux-$VERSIONPOINT-$NOIR_VERSION
           ;;
    build)
           cd linux-$VERSIONPOINT-$NOIR_VERSION
           make menuconfig
           #make xconfig
           sudo make clean
           time sudo make -j3
           time sudo make modules -j3
           sudo make bindeb-pkg
           ;;
    install_kernel)
           cd linux-$VERSIONPOINT-$NOIR_VERSION
           sudo make clean
           cd ../
           sudo dpkg -i *.deb
           sudo update-grub
           sudo rm -r linux-$VERSIONPOINT-$NOIR_VERSION
           rm -r linux-$VERSIONBASE.tar.xz
           ;;
esac
