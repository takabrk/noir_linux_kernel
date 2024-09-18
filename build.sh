#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#August 7,2024

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
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
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
        cat patches/other/patch-6.11-rt7.patch \
            patches/other/linux-v6.11-zen1.patch \
            patches/other/0001-amd-pstate-patches.patch \
            patches/other/0001-futex-6.11-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch \
            patches/other/0001-intel-pstate-patches.patch \
            patches/other/0002-clear-patches.patch \
            patches/other/0011-XANMOD-kconfig-add-500Hz-timer-interrupt-kernel-conf.patch \
            patches/other/0012-XANMOD-dcache-cache_pressure-50-decreases-the-rate-a.patch \
            >> noir.patch
            case $f_num in
                rt)
                    mv noir.patch noir_rt.patch
                    if [ -e patches/other/patch-6.11.1-rt7.patch ]; then
                        cat patches/other/patch-6.11.1-rt7.patch >> noir_rt.patch
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
