#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#February 13,2022

VERSIONPOINT="5.16.9"
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
pds)
cat   linux/patch-$VERSIONPOINT \
      other516/0001-PRJC-for-5.16.patch \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other516/0001-amd64-patches.patch \
      other516/0001-bbr2-5.16-introduce-BBRv2.patch \
      other516/0001-clearlinux-patches.patch \
      other516/0001-cpu-patches.patch \
      other516/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other516/0001-spadfs-5.16-merge-v1.0.15.patch \
      other516/0001-UKSM-for-5.16.patch \
      other516/0001-v4l2loopback-5.16-merge-v0.12.5.patch \
      other516/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other516/0002-ZEN-intel-pstate-Implement-enable-parameter.patch \
      other516/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other516/0004-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other516/0005-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other516/0001-pci-Enable-overrides-for-missing-ACS-capabilities.patch \
      other516/0001-futex-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-opcode.patch \
      noir_base/noir_base3.patch \
      noir_base/custom_config.patch \
      > noir.patch
;;

TT)
cat   linux/patch-$VERSIONPOINT \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other516/0001-amd64-patches.patch \
      other516/0001-bbr2-5.16-introduce-BBRv2.patch \
      other516/0001-clearlinux-patches.patch \
      other516/0001-cpu-patches.patch \
      other516/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other516/0001-spadfs-5.16-merge-v1.0.15.patch \
      other516/0001-UKSM-for-5.16.patch \
      other516/0001-v4l2loopback-5.16-merge-v0.12.5.patch \
      other516/0001-zen-Allow-MSR-writes-by-default.patch \
      other516/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other516/0002-ZEN-intel-pstate-Implement-enable-parameter.patch \
      other516/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other516/0004-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other516/0005-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other516/0001-ZEN-Add-VHBA-driver.patch \
      other516/0001-zen-Allow-MSR-writes-by-default.patch \
      other516/tt-5.16.patch \
      noir_base/noir_base3.patch \
      noir_base/custom_config.patch \
      > noir.patch
;;

esac
