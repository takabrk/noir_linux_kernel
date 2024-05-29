#!/bin/sh
#custom linux kernel build script
#Created by takamitsu hamada
#May 30,2024

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
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi     
        cat patches/noir_base/noir_base.patch \
            patches/other/0001-bcachefs-6.9-merge-changes-from-dev-tree.patch \
            patches/other/0001-futex-6.9-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other/0001-tcp-bbr3-initial-import.patch \
            patches/other/0002-clear-patches.patch \
            patches/other/0006-add-acs-overrides_iommu.patch \
            patches/other/0014-OpenRGB.patch \
            patches/other/Add_grayskys_more-uarches.patch \
            patches/other/Add_VHBA_driver.patch \
            patches/other/0007-XANMOD-block-mq-deadline-Increase-write-priority-to-.patch \
            patches/other/0008-XANMOD-block-mq-deadline-Disable-front_merges-by-def.patch \
            patches/other/0009-XANMOD-block-set-rq_affinity-to-force-full-multithre.patch \
            patches/other/0011-XANMOD-dcache-cache_pressure-50-decreases-the-rate-a.patch \
            >> noir.patch
            if [ -e patches/other/patch-6.9-rt5.patch ]; then
                cat patches/other/patch-6.9-rt5.patch >> noir.patch
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
    install_kernel)
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
esac
