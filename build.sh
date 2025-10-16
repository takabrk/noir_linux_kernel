#!/bin/bash
#custom linux kernel build script
#Created by takamitsu_h
#October 17,2025

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
#build noir_rt.patch,noir_bore.patch
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
        wget https://github.com/zen-kernel/zen-kernel/releases/download/v$VERSIONZEN/linux-v$VERSIONZEN.patch.zst
        unzstd linux-v$VERSIONZEN.patch.zst
        rm -r linux-v$VERSIONZEN.patch.zst
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/rt-patches-all/0001-rt-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/futex-patches/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0002-clear-patches.patch
        wget https://raw.githubusercontent.com/firelzrd/bore-scheduler/refs/heads/main/patches/stable/linux-$VERSIONBASE-bore/0001-linux$VERSIONBASE-bore-$VERSIONBORE.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/bbr3-patches/0001-tcp-bbr3-add-BBRv3-congestion-control.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/e6ee819a897b33f392a5fd0774d8cf5c7886d056.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/e6ee819a897b33f392a5fd0774d8cf5c7886d056.patch
        cd ../../
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi
        case $f_num in
            rt)
                cat patches/noir_base/noir_base.patch \
                    patches/other/0001-rt-patches.patch \
                    patches/other/linux-v$VERSIONZEN.patch \
                    >> noir.patch
            ;;
            bore)
                cat patches/noir_base/noir_base_bore.patch \
                    patches/other/0001-rt-patches.patch \
                    patches/other/0001-linux$VERSIONBASE-bore-$VERSIONBORE.patch \
                    patches/other/0001-tcp-bbr3-add-BBRv3-congestion-control.patch \
                    patches/other/e6ee819a897b33f392a5fd0774d8cf5c7886d056.patch \
                    patches/other/e6ee819a897b33f392a5fd0774d8cf5c7886d056.patch \
                    >> noir.patch
            ;;
        esac
        cat patches/other/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch \
            patches/other/0002-clear-patches.patch \
            >> noir.patch
            case $f_num in
                rt)
                   mv noir.patch noir_rt.patch
                ;;
                bore)
                    mv noir.patch noir_bore.patch
                ;;
            esac
           ;;
    vanilla)
            case $f_num in
               rt)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
               bore)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
            esac 
            ;;
    source)
           case $f_num in
               rt)
                   tar -Jxvf linux-$VERSIONBASE.tar.xz
                   cd linux-$VERSIONBASE
                   patch -p1 < ../noir_rt.patch
                   cd ../
                   mv linux-$VERSIONBASE linux-$VERSIONPOINT-$NOIR_VERSION
                   ;;
               bore)
                   tar -Jxvf linux-$VERSIONBASE.tar.xz
                   cd linux-$VERSIONBASE
                   patch -p1 < ../noir_bore.patch
                   cd ../
                   mv linux-$VERSIONBASE linux-$VERSIONPOINT-$NOIR_VERSION
                   ;;
           esac
           ;;                
    build)
           case $f_num in
               rt)
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
                   sudo make bindeb-pkg
                   ;;
               bore)
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
                   sudo make bindeb-pkg
                   ;;     
           esac
           ;;
    install_kernel)
           case $f_num in
               rt)
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
               bore)
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