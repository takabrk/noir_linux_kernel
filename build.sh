#!/bin/bash
#custom linux kernel build script
#Created by takamitsu_h
#September 10,2026

. ./config

while getopts e:f: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
      f) f_num=$OPTARG
  esac
done

case $e_num in
#build noir.patch
    patch)
        rm -r patches/linux/patch-$VERSIONPOINT
        cd patches/linux
        if  [ ${VERSIONPOINT: -2} != ".0" ]; then
            wget https://cdn.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/patch-$VERSIONPOINT.xz
            unxz patch-$VERSIONPOINT.xz
        fi
        cd ../../
        cd patches/other
        rm -r *.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/rt-patches/0001-rt-patches.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0013-optimize_harder_O3.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0002-clear-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/bbr3-patches/0001-tcp-bbr3-add-BBRv3-congestion-control.patch
        wget https://gitlab.com/xanmod/linux-patches/-/raw/master/linux-7.2.y-xanmod/xanmod/0007-XANMOD-block-mq-deadline-Increase-write-priority-to-.patch
        wget https://gitlab.com/xanmod/linux-patches/-/raw/master/linux-7.2.y-xanmod/xanmod/0013-XANMOD-mm-Raise-max_map_count-default-value.patch?ref_type=heads
        cd ../../
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi
        case $f_num in
            noir)
                cat patches/noir_base/noir_base.patch \
                    >> noir.patch
            ;;
        esac
        cat patches/other/0002-clear-patches.patch \
            patches/other/0001-tcp-bbr3-add-BBRv3-congestion-control.patch \
            patches/other/0013-optimize_harder_O3.patch \
            patches/other/0001-rt-patches.patch \
            patches/other/0007-XANMOD-block-mq-deadline-Increase-write-priority-to-.patch \
            patches/other/0013-XANMOD-mm-Raise-max_map_count-default-value.patch?ref_type=heads \
            >> noir.patch
           ;;
    vanilla)
            case $f_num in
               noir)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
            esac 
            ;;
    source)
           case $f_num in
               noir)
                   tar -Jxvf linux-$VERSIONBASE.tar.xz
                   cd linux-$VERSIONBASE
                   patch -p1 < ../noir.patch
                   cd ../
                   mv linux-$VERSIONBASE linux-$VERSIONPOINT-$NOIR_VERSION
                   ;;
           esac
           ;;                
    build)
           case $f_num in
               noir)
                   JOBS=$(grep processor /proc/cpuinfo | wc -l)
                   echo "Threads : $JOBS"
                   cd linux-$VERSIONPOINT-$NOIR_VERSION
                   make menuconfig
                   #make xconfig
                   #./scripts/config --disable CONFIG_NFT_SET_PIPAPO_AVX2
                   #make olddefconfig
                   sudo make clean
                   time sudo make -j$JOBS
                   time sudo make modules -j$JOBS
                   sudo make modules_install
                   sudo make bindeb-pkg
                   ;;     
           esac
           ;;
    install_kernel)
           case $f_num in
               noir)
                   cd linux-$VERSIONPOINT-$NOIR_VERSION
                   sudo make clean
                   cd ../
                   sudo dpkg -i *.deb
                   sudo update-grub
                   sudo rm -r linux-$VERSIONPOINT-$NOIR_VERSION
                   rm -r linux-$VERSIONBASE.tar.xz
                   if  [ -e patches/linux/patch-$VERSIONPOINT ]; then
                       rm -r patches/linux/patch-$VERSIONPOINT
                   fi
                   rm -r patches/other/*
                   ;;
           esac
           ;;                 
esac