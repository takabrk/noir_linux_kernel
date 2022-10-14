#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#October 13,2022

VERSIONPOINT="6.0.1"
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
600)
cat noir_base/noir_base.patch \
    noir_base/custom_config.patch \
    other6/zen_interactive_tune.patch \
    other6/zen_other.patch \
    other6/LL.patch \
    other6/patch-6.0-rt11.patch \
    linux/patch-$VERSIONPOINT \
    other6/0001-futex-6.0-Add-entry-point-for-FUTEX_WAIT_MULTIPLE-op.patch \
    > noir.patch
;;

esac
