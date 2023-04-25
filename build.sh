#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#April 25,2023

. ./config

while getopts e: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
  esac
done
#if  [ -e patches/linux/patch-$VERSIONPOINT ]; then
#    rm -r patches/linux/patch-$VERSIONPOINT
#fi
#if  [ -e patches/linux/patch-$VERSIONPOINT.xz ]; then
#    xz -k -d patches/linux/patch-$VERSIONPOINT.xz
#fi

case $e_num in
#build noir.patch
    patch)
        truncate noir.patch --size 0
        truncate patches/noir_base/custom_config.patch --size 0

#build custom_config.patch
        diff -Naur /dev/null patches/noir_base/.config | sed 1i"diff --git a/.config b/.config\nnew file mode 100644\nindex 000000000000..dcbcaa389249" > patches/noir_base/custom_config.patch
        cat patches/noir_base/noir_base.patch \
            patches/noir_base/custom_config.patch \
            patches/other/0001-amd-pstate-patches.patch \
            patches/other/0001-futex-6.3-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other/0001-tcp_bbr2-introduce-BBRv2.patch \
            patches/other/patch-6.3-rc7-rt9.patch \
            > noir.patch
            ;;

    source)
           wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-$VERSIONBASE.tar.xz
           tar -Jxvf linux-$VERSIONBASE.tar.xz
           cd linux-$VERSIONBASE
           patch -p1 < ../noir.patch
           cd ../
           mv linux-$VERSIONBASE linux-$VERSIONPOINT-$NOIR_VERSION
           rm -r linux-$VERSIONBASE.tar.xz
           ;;
    build)
           cd linux-$VERSIONPOINT-$NOIR_VERSION
           make menuconfig
           #make xconfig
           sudo make-kpkg clean
           time sudo make-kpkg -j3 --initrd linux_image linux_headers
           sudo make-kpkg clean
           cd ../
           sudo rm -r linux-$VERSIONPOINT-$NOIR_VERSION
           sudo dpkg -i *.deb
           sudo update-grub
           ;;
esac
