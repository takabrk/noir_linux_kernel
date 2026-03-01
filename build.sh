#!/bin/bash
#custom linux kernel build script
#Created by takamitsu_h
#March 2,2026

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
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/rt-patches/0001-rt-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/futex-patches/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0002-clear-patches.patch
        wget https://raw.githubusercontent.com/sirlucjan/kernel-patches/refs/heads/master/$VERSIONBASE/bore-patches/0001-linux$VERSIONBASE-bore$VERSIONBORE.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0013-optimize_harder_O3.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0006-add-acs-overrides_iommu.patch
        wget https://raw.githubusercontent.com/Frogging-Family/linux-tkg/refs/heads/master/linux-tkg-patches/$VERSIONBASE/0014-OpenRGB.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/dbc40c577cbb482c1d5c92d97724a026113e4526.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/64164f0372696265baef02378f2ce21a82a6c8ab.patch
        wget https://github.com/zen-kernel/zen-kernel/commit/eb68d2d67da641462df6344a9de5231a5db8956d.patch
        wget github.com/zen-kernel/zen-kernel/commit/f8c0b5e54aa1437257286553b6ebedf839703cb2.patch
        cd ../../
        truncate noir.patch --size 0
        if [ -e patches/linux/patch-$VERSIONPOINT ]; then
            cat patches/linux/patch-$VERSIONPOINT >> noir.patch
        fi
        case $f_num in
            bore)
                cat patches/noir_base/noir_base_bore.patch \
                    patches/other/0001-rt-patches.patch \
                    patches/other/0001-linux$VERSIONBASE-bore$VERSIONBORE.patch \
                    >> noir.patch
            ;;
        esac
        cat patches/other/0001-futex-$VERSIONBASE-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-o.patch \
            patches/other/0002-clear-patches.patch \
            patches/other/0013-optimize_harder_O3.patch \
            patches/other/0006-add-acs-overrides_iommu.patch \
            patches/other/0014-OpenRGB.patch \
            patches/noir_base/default_kyber.patch \
            patches/other/dbc40c577cbb482c1d5c92d97724a026113e4526.patch \
            patches/other/64164f0372696265baef02378f2ce21a82a6c8ab.patch \
            patches/other/eb68d2d67da641462df6344a9de5231a5db8956d.patch \
            patches/other/f8c0b5e54aa1437257286553b6ebedf839703cb2.patch \
            >> noir.patch
            case $f_num in
                bore)
                    mv noir.patch noir_bore.patch
                ;;
            esac
           ;;
    vanilla)
            case $f_num in
               bore)
                   wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$VERSIONBASE.tar.xz
                   ;;
            esac 
            ;;
    source)
           case $f_num in
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