#!/bin/bash
#custom linux kernel build script
#Created by takamitsu_h
#July 1,2026

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
        wget https://www.kernel.org/pub/linux/kernel/projects/rt/7.1/patch-7.1.1-rt2.patch.xz
        unxz patch-7.1.1-rt2.patch.xz
        rm -r patch-7.1.1-rt2.patch.xz
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/futex-patches/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0002-clear-patches.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0013-optimize_harder_O3.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0006-add-acs-overrides_iommu.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0014-OpenRGB.patch
        wget https://gitlab.com/xanmod/linux-patches/-/raw/master/linux-$VERSIONBASE.y-xanmod/xanmod/0009-XANMOD-block-Set-rq_affinity-to-force-complete-I-O-r.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/7c4891e860507a39b03f1a899b938089dffe3dcc.patch
        cd ../../
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi
        case $f_num in
            rt)
                cat patches/noir_base/noir_base.patch \
                    patches/other/patch-7.1.1-rt2.patch \
                    >> noir.patch
            ;;
        esac
        cat patches/other/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
            patches/other/0002-clear-patches.patch \
            patches/noir_base/default_kyber.patch \
            patches/other/0013-optimize_harder_O3.patch \
            patches/other/0006-add-acs-overrides_iommu.patch \
            patches/other/0014-OpenRGB.patch \
            patches/other/0009-XANMOD-block-Set-rq_affinity-to-force-complete-I-O-r.patch \
            patches/other/7c4891e860507a39b03f1a899b938089dffe3dcc.patch \
            >> noir.patch
           ;;
    vanilla)
            case $f_num in
               rt)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
            esac 
            ;;
    source)
           case $f_num in
               rt)
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
           esac
           ;;                 
esac