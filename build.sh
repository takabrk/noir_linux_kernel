#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#May 15,2024

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
#build custom_config.patch
    patch)
        truncate noir.patch --size 0
        truncate patches/noir_base/custom_config.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT > noir.patch
        fi     
        cat patches/noir_base/noir_base.patch \
            patches/other/0001-amd-6.9-merge-changes-from-dev-tree.patch \
            patches/other/0001-bcachefs-6.9-merge-changes-from-dev-tree.patch \
            patches/other/0001-futex-6.9-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other/0001-tcp-bbr3-initial-import.patch \
            patches/other/0002-clear-patches.patch \
            >> noir.patch
            if [ -e patches/other/patch-6.9-rc6-rt4.patch ]; then
                cat patches/other/patch-6.9-rc6-rt4.patch >> noir.patch
            elif [ -e patches/other/linux-v6.9-zen1.patch ]; then
                cat patches/other/linux-v6.9-zen1.patch >> noir.patch
            fi
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
