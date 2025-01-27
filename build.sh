#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#January 27,2025

. ./config

while getopts e:f: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
      f) f_num=$OPTARG
  esac
done

if  [ -e patches/linux/patch-$VERSIONPOINT ]; then
    rm -r patches/linux/patch-$VERSIONPOINT
fi
if  [ -e patches/linux/patch-$VERSIONPOINT.xz ]; then
    xz -k -d patches/linux/patch-$VERSIONPOINT.xz
fi

case $e_num in
#build noir_rt.patch,noir_xenomai.patch
    patch)
        rm -r patches/other/*
        cd patches/other
        wget https://www.kernel.org/pub/linux/kernel/projects/rt/6.13/patch-6.13-rc6-rt3.patch.xz
        unxz -kT0 patch-6.13-rc6-rt3.patch.xz
        wget https://github.com/zen-kernel/zen-kernel/releases/download/v6.13-zen1/linux-v6.13-zen1.patch.zst
        unzstd linux-v6.13-zen1.patch.zst
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/6.13/amd-pstate-patches-all/0001-amd-pstate-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/6.13/clearlinux-patches/0001-clearlinux-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/6.13/futex-patches/0001-futex-6.13-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch

        wget https://raw.githubusercontent.com/xanmod/linux-patches/refs/heads/master/linux-6.11.y-xanmod/xanmod/0011-XANMOD-kconfig-add-500Hz-timer-interrupt-kernel-conf.patch
        wget https://raw.githubusercontent.com/xanmod/linux-patches/refs/heads/master/linux-6.11.y-xanmod/xanmod/0012-XANMOD-dcache-cache_pressure-50-decreases-the-rate-a.patch
        wget https://raw.githubusercontent.com/xanmod/linux-patches/refs/heads/master/linux-6.11.y-xanmod/xanmod/0007-XANMOD-block-mq-deadline-Increase-write-priority-to-.patch
        wget https://raw.githubusercontent.com/xanmod/linux-patches/refs/heads/master/linux-6.11.y-xanmod/xanmod/0008-XANMOD-block-mq-deadline-Disable-front_merges-by-def.patch
        cd ../../
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cd patches/linux
            wget https://cdn.kernel.org/pub/linux/kernel/v6.x/patch-$VERSIONPOINT.xz
            unxz patch-$VERSIONPOINT.xz
            cd ../../
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi
        case $f_num in
            rt)
                cat patches/noir_base/noir_base.patch >> noir.patch
            ;;
            xenomai)
                cat patches/noir_base/noir_base_xenomai.patch >> noir.patch
            ;;
        esac
        cat patches/other/patch-$VERSIONBASE-rc6-rt3.patch \
            patches/other/linux-v$VERSIONBASE-zen1.patch \
            patches/other/0001-amd-pstate-patches.patch \
            patches/other/0001-clearlinux-patches.patch \
            patches/other/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch \
            patches/other/0011-XANMOD-kconfig-add-500Hz-timer-interrupt-kernel-conf.patch \
            patches/other/0012-XANMOD-dcache-cache_pressure-50-decreases-the-rate-a.patch \
            patches/other/0007-XANMOD-block-mq-deadline-Increase-write-priority-to-.patch \
            patches/other/0008-XANMOD-block-mq-deadline-Disable-front_merges-by-def.patch \
            >> noir.patch
            case $f_num in
                rt)
                    mv noir.patch noir_rt.patch
                    if [ -e patches/other/patch-$VERSIONBASE-rc6-rt3.patch ]; then
                        cat patches/other/patch-$VERSIONBASE-rc6-rt3.patch >> noir_rt.patch
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
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-$VERSIONBASE.tar.xz
                   ;;
               xenomai)
                   wget https://source.denx.de/Xenomai/xenomai4/linux-evl/-/archive/v6.9-evl-rebase/linux-$VERSIONXENOMAI.tar.gz
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