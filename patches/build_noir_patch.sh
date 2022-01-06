#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#January 6,2022

VERSIONPOINT="5.15.13"
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
      other515/prjc_v5.15-r1.patch \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other515/0001-amd64-patches.patch \
      other515/0001-bbr2-5.15-introduce-BBRv2.patch \
      other515/0001-bcachefs-5.15-introduce-bcachefs-patchset.patch \
      other515/0001-clearlinux-patches.patch \
      other515/0001-cpu-patches.patch \
      other515/0001-cpufreq-patches.patch \
      other515/0001-futex2-resync-from-gitlab.collabora.com.patch \
      other515/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other515/0001-spadfs-5.15-merge-v1.0.14.patch \
      other515/0001-UKSM-for-5.15.patch \
      other515/0001-v4l2loopback-5.15-merge-v0.12.5.patch \
      other515/0001-zen-Allow-MSR-writes-by-default.patch \
      other515/0001-zstd-patches.patch \
      other515/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other515/0002-ZEN-intel-pstate-Implement-enable-parameter.patch \
      other515/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other515/0003-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other515/0004-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other515/le9ec-5.15.patch \
      other515/VHBA.patch \
      other515/OpenRGB.patch \
      other515/acso.patch \
      other515/0002-ZEN-intel-pstate-Implement-enable-parameter.patch \
      noir_base/noir_base.patch \
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
      other515/0001-amd64-patches.patch \
      other515/0001-bbr2-5.15-introduce-BBRv2.patch \
      other515/0001-bcachefs-5.15-introduce-bcachefs-patchset.patch \
      other515/0001-clearlinux-patches.patch \
      other515/0001-cpu-patches.patch \
      other515/0001-cpufreq-patches.patch \
      other515/0001-futex2-resync-from-gitlab.collabora.com.patch \
      other515/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other515/0001-spadfs-5.15-merge-v1.0.14.patch \
      other515/0001-UKSM-for-5.15.patch \
      other515/0001-v4l2loopback-5.15-merge-v0.12.5.patch \
      other515/0001-zen-Allow-MSR-writes-by-default.patch \
      other515/0001-zstd-patches.patch \
      other515/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other515/0002-ZEN-intel-pstate-Implement-enable-parameter.patch \
      other515/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other515/0003-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other515/0004-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other515/le9ec-5.15.patch \
      other515/VHBA.patch \
      other515/OpenRGB.patch \
      other515/acso.patch \
      noir_base/noir_base2.patch \
      noir_base/custom_config.patch \
      other515/tt-cfs-5.15.patch \
      > noir.patch
;;

esac
