#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#June 25,2022

VERSIONPOINT="5.18.6"
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
case $e_num in
518)
cat linux/patch-$VERSIONPOINT \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other518/0001-clearlinux-patches.patch \
      other518/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other518/0004-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other518/0005-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other518/zen.patch \
      noir_base/noir_base.patch \
      noir_base/custom_config.patch \
      > noir.patch
;;

esac
