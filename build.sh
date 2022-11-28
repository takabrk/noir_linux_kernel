#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#November 28,2022

. ./config

while getopts e: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
  esac
done

case $e_num in
#build noir.patch
    600)
        truncate noir.patch --size 0
        truncate patches/noir_base/custom_config.patch --size 0

#build custom_config.patch
        diff -Naur /dev/null patches/noir_base/.config | sed 1i"diff --git a/.config b/.config\nnew file mode 100644\nindex 000000000000..dcbcaa389249" > patches/noir_base/custom_config.patch
        cat patches/noir_base/noir_base.patch \
            patches/noir_base/custom_config.patch \
            patches/other6/zen_interactive_tune.patch \
            patches/other6/zen_other.patch \
            patches/other6/LL.patch \
            patches/other6/patch-6.0-rt11.patch \
            patches/linux/patch-$VERSIONPOINT \
            patches/other6/0001-futex-6.0-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other6/0002-clear-patches.patch \
            patches/other6/0007-v6.0-winesync.patch \
            patches/other6/0001-tcp_bbr2-introduce-BBRv2.patch \
            patches/other6/0001-zram-cachyos-patches.patch \
            > noir.patch
            ;;

    base)
           wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-$VERSIONBASE.tar.xz
           tar -Jxvf linux-$VERSIONBASE.tar.xz
           #wget https://git.kernel.org/torvalds/t/linux-$VERSIONBASE.tar.gz
           #tar -zxvf linux-$VERSIONBASE.tar.gz
           cd linux-$VERSIONBASE
           patch -p1 < ../noir.patch
           cd ../
           mv linux-$VERSIONBASE linux-$VERSIONPOINT-noir
           #rm -r linux-$VERSIONBASE.tar.gz
           rm -r linux-$VERSIONBASE.tar.xz
           ;;
    core)
           cd linux-$VERSIONPOINT-noir
           make menuconfig
           #make xconfig
           sudo make-kpkg clean
           time sudo make-kpkg -j3 --initrd linux_image linux_headers
           #cd linux-$VERSIONBASE-noir
           #sudo make modules_install -j4
           #cd ../
           #rm -r linux_modules
           #mkdir linux_modules
           #cd linux-$VERSIONPOINT-noir
           #make INSTALL_MOD_PATH=../linux_modules modules_install -j4
           sudo make-kpkg clean
           cd ../
           #zip -r linux-$VERSIONPOINT-noir.zip linux-$VERSIONPOINT-noir
           sudo rm -r linux-$VERSIONPOINT-noir
           sudo dpkg -i *.deb
           sudo update-grub
           ;;

    distcc)
           cd linux-$VERSIONPOINT-noir
           make xconfig
           sudo make-kpkg clean
           #sudo CC="distcc gcc" CXX="distcc g++" make-kpkg -j4 --initrd linux_image linux_headers
           #sudo CONCURRENCY_LEVEL=4 MAKEFLAGS="CC=distcc gcc" make-kpkg -j4 --initrd linux_image linux_headers
            sudo MAKEFLAGS="CC=distcc" BUILD_TIME="/usr/bin/time" CONCURRENCY_LEVEL=$(distcc -j) make-kpkg --rootcmd fakeroot --initrd kernel_image kernel_headers
           cd ../
           sudo dpkg -i *.deb
           cd linux-$VERSIONPOINT-noir
           #sudo make modules_install -j4
           #cd ../
           #rm -r linux_modules
           #mkdir linux_modules
           #cd linux-$VERSIONBASE-noir
           #make INSTALL_MOD_PATH=../linux_modules modules_install -j4
           sudo make-kpkg clean
           cd ../
           #zip -r linux-$VERSIONPOINT-noir.zip linux-$VERSIONPOINT-noir
           sudo rm -r linux-$VERSIONPOINT-noir
           sudo update-grub
           ;;
esac
