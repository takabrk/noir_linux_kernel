#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#August 2,2022

VERSIONPOINT="5.19"
NOIR_VERSION="noir"
truncate noir.patch --size 0
truncate noir_base/custom_config.patch --size 0

#build custom_config.patch
diff -Naur /dev/null noir_base/.config | sed 1i"diff --git a/.config b/.config\nnew file mode 100644\nindex 000000000000..dcbcaa389249" > noir_base/custom_config.patch

while getopts e: OPT
do
  case $OPT in
      e) e_num=$OPTARG
         ;;
  esac
done

#build noir.patch
#linux/patch-$VERSIONPOINT \
      #other519/0001-bcachefs-5.18-introduce-bcachefs-patchset.patch \
      #other519/0001-clearlinux-patches.patch \
      #other519/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      #other519/0004-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      #other519/0005-mm-set-8-megabytes-for-address_space-level-file-read.patch \
case $e_num in
519)
cat  other519/zen.patch \
     other519/zen_sub.patch \
      noir_base/noir_base.patch \
      noir_base/custom_config.patch \
      > noir.patch
;;

esac
