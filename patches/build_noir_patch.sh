#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#August 28,2022

VERSIONPOINT="5.19.4"
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
519)
cat noir_base/noir_base.patch \
    noir_base/custom_config.patch \
    other519/zen_interactive_tune.patch \
    other519/zen_other.patch \
    other519/LL.patch \
    other519/xanmod.patch \
    other519/0001-futex-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-opcode.patch \
    other519/patch-5.19-rt10.patch \
    linux/patch-$VERSIONPOINT \
    other519/MGLRU.patch \
    other519/sched_fair_Avoid_unnecessary_migrations_within_SMT_domains.patch \
    > noir.patch
;;

esac
