#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#Augaust 4,2025

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
#build noir_rt.patch,noir_xenomai.patch
    patch)
#        rm -r patches/linux/patch-$VERSIONPOINT
#        cd patches/linux
#        wget https://cdn.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/patch-$VERSIONPOINT.xz
#        if  [ -e patch-$VERSIONPOINT.xz ]; then
#            unxz patch-$VERSIONPOINT.xz
#        fi
#        cd ../../
        rm -r patches/other/*
        cd patches/other
        wget https://www.kernel.org/pub/linux/kernel/projects/rt/$VERSIONBASE/patch-$VERSIONRT.patch.xz
        unxz -kT0 patch-$VERSIONRT.patch.xz
        rm -r patch-$VERSIONRT.patch.xz
        wget https://github.com/zen-kernel/zen-kernel/releases/download/v$VERSIONBASE-zen1/linux-v$VERSIONPOINT-zen1.patch.zst
        unzstd linux-v$VERSIONBASE-zen1.patch.zst
        rm -r linux-v$VERSIONBASE-zen1.patch.zst
        wget https://github.com/zen-kernel/zen-kernel/releases/download/v$VERSIONPOINT-zen1/linux-v$VERSIONPOINT-zen1.patch.zst
        unzstd linux-v$VERSIONZEN-zen1.patch.zst
        rm -r linux-v$VERSIONZEN-zen1.patch.zst
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/futex-patches/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0002-clear-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/bbr3-patches/0001-tcp-bbr3-initial-import.patch
        cd ../../
        truncate noir.patch --size 0
#        cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        case $f_num in
            rt)
                cat patches/noir_base/noir_base.patch >> noir.patch
            ;;
            xenomai)
                cat patches/noir_base/noir_base_xenomai.patch >> noir.patch
            ;;
        esac
        cat patches/other/patch-$VERSIONRT.patch \
            patches/other/linux-v$VERSIONZEN-zen1.patch \
            patches/other/0002-clear-patches.patch \
            patches/other/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch \
            patches/other/0001-tcp-bbr3-initial-import.patch \
            >> noir.patch
            case $f_num in
                rt)
                    mv noir.patch noir_rt.patch
                   if [ -e patches/other/patch-$VERSIONRT.patch ]; then
                        cat patches/other/patch-$VERSIONRT.patch >> noir_rt.patch
                   fi 
                ;;
                xenomai)
                    mv noir.patch noir_xenomai.patch
                ;;
            esac
           ;;
    vanilla)
            case $f_num in
               rt)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
               xenomai)
                   wget https://source.denx.de/Xenomai/xenomai4/linux-evl/-/archive/v$VERSIONBASE-evl-rebase/linux-$VERSIONXENOMAI.tar.gz
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
               xenomai)
                   tar -zxvf linux-$VERSIONXENOMAI.tar.gz
                   cd linux-$VERSIONXENOMAI
                   patch -p1 < ../noir_xenomai.patch
                   cd ../
                   mv linux-$VERSIONXENOMAI linux-$VERSIONPOINT-$NOIR_VERSION-xenomai
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
                   sudo make clean
                   time sudo make -j$JOBS
                   time sudo make modules -j$JOBS
                   sudo make bindeb-pkg
                   ;;
               xenomai)
                   JOBS=$(grep processor /proc/cpuinfo | wc -l)
                   echo "Threads : $JOBS"
                   cd linux-$VERSIONPOINT-$NOIR_VERSION-xenomai
                   make menuconfig
                   #make xconfig
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
                   ;;
               xenomai)
                   cd linux-$VERSIONPOINT-$NOIR_VERSION-xenomai
                   sudo make clean
                   cd ../
                   sudo dpkg -i *.deb
                   sudo update-grub
                   sudo rm -r linux-$VERSIONPOINT-$NOIR_VERSION-xenomai
                   rm -r linux-$VERSIONXENOMAI.tar.gz
                   if  [ -e patches/linux/patch-$VERSIONPOINT ]; then
                       rm -r patches/linux/patch-$VERSIONPOINT
                   fi
                   ;;
           esac
           ;;                 
esac