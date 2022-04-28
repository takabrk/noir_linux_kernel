#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#April 28,2022

while getopts e: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
  esac
done
VERSIONBASE="5.17"
VERSIONPOINT="5.17.5"

case $e_num in
    base)
           wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$VERSIONBASE.tar.xz
           tar -Jxvf linux-$VERSIONBASE.tar.xz
           #wget https://git.kernel.org/torvalds/t/linux-$VERSIONBASE.tar.gz
           #tar -zxvf linux-$VERSIONBASE.tar.gz
           cd linux-$VERSIONBASE
           patch -p1 < ../patches/noir.patch
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
