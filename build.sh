#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#April 11,2024

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
#build custom_config.patch
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT > noir.patch
        fi
        cat patches/noir_base/noir_base.patch \
            patches/other/linux-v6.8-zen1.patch \
            patches/other/patch-6.8.2-rt11.patch \
            patches/other/0001-amd-pstate-patches.patch \
            patches/other/0001-futex-6.8-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other/0007-v6.8-winesync.patch \
            patches/other/0001-bcachefs-6.8-merge-changes-from-dev-tree.patch \
            >> noir.patch
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
