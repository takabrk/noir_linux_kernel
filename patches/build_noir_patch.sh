#!/bin/sh
#noir linux kernel patchsets build script
#Created by takamitsu hamada
#October 21,2021

VERSIONPOINT="5.14.14"
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
      other/prjc_v5.14-r3.patch \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other/0001-cpu-patches.patch \
      other/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other/0003-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other/0004-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other/0001-UKSM-for-5.14.patch \
      other/0001-bbr2-5.14-introduce-BBRv2.patch \
      other/0001-ntfs3-patches.patch \
      other/0001-zstd-patches.patch \
      other/le9ec-5.14.patch \
      other/0001-aufs-20210906.patch \
      other/0001-clearlinux-patches.patch \
      other/0007-v5.14-winesync.patch \
      other/acso.patch \
      other/OpenRGB.patch \
      other/VHBA.patch \
      other/0006-x86-ACPI-State-Optimize-C3-entry-on-AMD-CPUs.patch \
      other/0001-v4l2loopback-5.14-merge-v0.12.5.patch \
      other/0001-zen-Allow-MSR-writes-by-default.patch \
      other/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other/0001-sched-autogroup-Add-kernel-parameter-and-config-opti.patch \
      other/0001-bcachefs-5.14-introduce-bcachefs-patchset.patch \
      other/0001-spadfs-5.13-merge-v1.0.14.patch \
      other/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other/0001-futex2-resync-from-gitlab.collabora.com.patch \
      noir_base/noir_base.patch \
      noir_base/custom_config.patch \
      > noir.patch
;;

cacule)
cat   linux/patch-$VERSIONPOINT \
      ck1/0004-Create-highres-timeout-variants-of-schedule_timeout-.patch \
      ck1/0005-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch \
      ck1/0006-Convert-msleep-to-use-hrtimers-when-active.patch \
      ck1/0008-Replace-all-calls-to-schedule_timeout_interruptible-.patch \
      ck1/0009-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch \
      ck1/0010-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch \
      ck1/0014-Swap-sucks.patch \
      other/0001-cpu-patches.patch \
      other/0001-LL-kconfig-add-750Hz-timer-interrupt-kernel-config-o.patch \
      other/0003-sched-core-nr_migrate-256-increases-number-of-tasks-.patch \
      other/0004-mm-set-8-megabytes-for-address_space-level-file-read.patch \
      other/0001-UKSM-for-5.14.patch \
      other/0001-bbr2-5.14-introduce-BBRv2.patch \
      other/0001-ntfs3-patches.patch \
      other/0001-zstd-patches.patch \
      other/le9ec-5.14.patch \
      other/0001-aufs-20210906.patch \
      other/0001-clearlinux-patches.patch \
      other/0007-v5.14-winesync.patch \
      other/acso.patch \
      other/OpenRGB.patch \
      other/VHBA.patch \
      other/0006-x86-ACPI-State-Optimize-C3-entry-on-AMD-CPUs.patch \
      other/0001-v4l2loopback-5.14-merge-v0.12.5.patch \
      other/0001-zen-Allow-MSR-writes-by-default.patch \
      other/0002-PCI-Add-Intel-remapped-NVMe-device-support.patch \
      other/0001-sched-autogroup-Add-kernel-parameter-and-config-opti.patch \
      other/0001-bcachefs-5.14-introduce-bcachefs-patchset.patch \
      other/0001-spadfs-5.13-merge-v1.0.14.patch \
      other/0003-block-set-rq_affinity-2-for-full-multithreading-I-O.patch \
      other/0001-futex2-resync-from-gitlab.collabora.com.patch \
      PREEMPT_RT/0001-mm-slub-don-t-call-flush_all-from-slab_debug_trace_o.patch \
      PREEMPT_RT/0002-mm-slub-allocate-private-object-map-for-debugfs-list.patch \
      PREEMPT_RT/0003-mm-slub-allocate-private-object-map-for-validate_sla.patch \
      PREEMPT_RT/0004-mm-slub-don-t-disable-irq-for-debug_check_no_locks_f.patch \
      PREEMPT_RT/0005-mm-slub-remove-redundant-unfreeze_partials-from-put_.patch \
      PREEMPT_RT/0006-mm-slub-extract-get_partial-from-new_slab_objects.patch \
      PREEMPT_RT/0007-mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch \
      PREEMPT_RT/0008-mm-slub-return-slab-page-from-get_partial-and-set-c-.patch \
      PREEMPT_RT/0009-mm-slub-restructure-new-page-checks-in-___slab_alloc.patch \
      PREEMPT_RT/0010-mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch \
      PREEMPT_RT/0011-mm-slub-move-disabling-enabling-irqs-to-___slab_allo.patch \
      PREEMPT_RT/0012-mm-slub-do-initial-checks-in-___slab_alloc-with-irqs.patch \
      PREEMPT_RT/0013-mm-slub-move-disabling-irqs-closer-to-get_partial-in.patch \
      PREEMPT_RT/0014-mm-slub-restore-irqs-around-calling-new_slab.patch \
      PREEMPT_RT/0015-mm-slub-validate-slab-from-partial-list-or-page-allo.patch \
      PREEMPT_RT/0016-mm-slub-check-new-pages-with-restored-irqs.patch \
      PREEMPT_RT/0017-mm-slub-stop-disabling-irqs-around-get_partial.patch \
      PREEMPT_RT/0018-mm-slub-move-reset-of-c-page-and-freelist-out-of-dea.patch \
      PREEMPT_RT/0019-mm-slub-make-locking-in-deactivate_slab-irq-safe.patch \
      PREEMPT_RT/0020-mm-slub-call-deactivate_slab-without-disabling-irqs.patch \
      PREEMPT_RT/0021-mm-slub-move-irq-control-into-unfreeze_partials.patch \
      PREEMPT_RT/0022-mm-slub-discard-slabs-in-unfreeze_partials-without-i.patch \
      PREEMPT_RT/0023-mm-slub-detach-whole-partial-list-at-once-in-unfreez.patch \
      PREEMPT_RT/0024-mm-slub-separate-detaching-of-partial-list-in-unfree.patch \
      PREEMPT_RT/0025-mm-slub-only-disable-irq-with-spin_lock-in-__unfreez.patch \
      PREEMPT_RT/0026-mm-slub-don-t-disable-irqs-in-slub_cpu_dead.patch \
      PREEMPT_RT/0027-mm-slab-split-out-the-cpu-offline-variant-of-flush_s.patch \
      PREEMPT_RT/0028-mm-slub-move-flush_cpu_slab-invocations-__free_slab-.patch \
      PREEMPT_RT/0029-mm-slub-make-object_map_lock-a-raw_spinlock_t.patch \
      PREEMPT_RT/0030-mm-slub-make-slab_lock-disable-irqs-with-PREEMPT_RT.patch \
      PREEMPT_RT/0031-mm-slub-protect-put_cpu_partial-with-disabled-irqs-i.patch \
      PREEMPT_RT/0032-mm-slub-use-migrate_disable-on-PREEMPT_RT.patch \
      PREEMPT_RT/0033-mm-slub-convert-kmem_cpu_slab-protection-to-local_lo.patch \
      PREEMPT_RT/0001-locking-local_lock-Add-missing-owner-initialization.patch \
      PREEMPT_RT/0002-locking-rtmutex-Set-proper-wait-context-for-lockdep.patch \
      PREEMPT_RT/0003-sched-wakeup-Split-out-the-wakeup-__state-check.patch \
      PREEMPT_RT/0004-sched-wakeup-Introduce-the-TASK_RTLOCK_WAIT-state-bi.patch \
      PREEMPT_RT/0005-sched-wakeup-Reorganize-the-current-__state-helpers.patch \
      PREEMPT_RT/0006-sched-wakeup-Prepare-for-RT-sleeping-spin-rwlocks.patch \
      PREEMPT_RT/0007-sched-core-Rework-the-__schedule-preempt-argument.patch \
      PREEMPT_RT/0008-sched-core-Provide-a-scheduling-point-for-RT-locks.patch \
      PREEMPT_RT/0009-sched-wake_q-Provide-WAKE_Q_HEAD_INITIALIZER.patch \
      PREEMPT_RT/0010-media-atomisp-Use-lockdep-instead-of-mutex_is_locked.patch \
      PREEMPT_RT/0011-locking-rtmutex-Remove-rt_mutex_is_locked.patch \
      PREEMPT_RT/0012-locking-rtmutex-Convert-macros-to-inlines.patch \
      PREEMPT_RT/0013-locking-rtmutex-Switch-to-from-cmpxchg_-to-try_cmpxc.patch \
      PREEMPT_RT/0014-locking-rtmutex-Split-API-from-implementation.patch \
      PREEMPT_RT/0015-locking-rtmutex-Split-out-the-inner-parts-of-struct-.patch \
      PREEMPT_RT/0016-locking-rtmutex-Provide-rt_mutex_slowlock_locked.patch \
      PREEMPT_RT/0017-locking-rtmutex-Provide-rt_mutex_base_is_locked.patch \
      PREEMPT_RT/0018-locking-rt-Add-base-code-for-RT-rw_semaphore-and-rwl.patch \
      PREEMPT_RT/0019-locking-rwsem-Add-rtmutex-based-R-W-semaphore-implem.patch \
      PREEMPT_RT/0020-locking-rtmutex-Add-wake_state-to-rt_mutex_waiter.patch \
      PREEMPT_RT/0021-locking-rtmutex-Provide-rt_wake_q_head-and-helpers.patch \
      PREEMPT_RT/0022-locking-rtmutex-Use-rt_mutex_wake_q_head.patch \
      PREEMPT_RT/0023-locking-rtmutex-Prepare-RT-rt_mutex_wake_q-for-RT-lo.patch \
      PREEMPT_RT/0024-locking-rtmutex-Guard-regular-sleeping-locks-specifi.patch \
      PREEMPT_RT/0025-locking-spinlock-Split-the-lock-types-header-and-mov.patch \
      PREEMPT_RT/0026-locking-rtmutex-Prevent-future-include-recursion-hel.patch \
      PREEMPT_RT/0027-locking-lockdep-Reduce-header-dependencies-in-linux-.patch \
      PREEMPT_RT/0028-rbtree-Split-out-the-rbtree-type-definitions-into-li.patch \
      PREEMPT_RT/0029-locking-rtmutex-Reduce-linux-rtmutex.h-header-depend.patch \
      PREEMPT_RT/0030-locking-spinlock-Provide-RT-specific-spinlock_t.patch \
      PREEMPT_RT/0031-locking-spinlock-Provide-RT-variant-header-linux-spi.patch \
      PREEMPT_RT/0032-locking-rtmutex-Provide-the-spin-rwlock-core-lock-fu.patch \
      PREEMPT_RT/0033-locking-spinlock-Provide-RT-variant.patch \
      PREEMPT_RT/0034-locking-rwlock-Provide-RT-variant.patch \
      PREEMPT_RT/0036-locking-mutex-Consolidate-core-headers-remove-kernel.patch \
      PREEMPT_RT/0037-locking-mutex-Move-the-struct-mutex_waiter-definitio.patch \
      PREEMPT_RT/0038-locking-ww_mutex-Move-the-ww_mutex-definitions-from-.patch \
      PREEMPT_RT/0039-locking-mutex-Make-mutex-wait_lock-raw.patch \
      PREEMPT_RT/0040-locking-ww_mutex-Simplify-lockdep-annotations.patch \
      PREEMPT_RT/0041-locking-ww_mutex-Gather-mutex_waiter-initialization.patch \
      PREEMPT_RT/0042-locking-ww_mutex-Split-up-ww_mutex_unlock.patch \
      PREEMPT_RT/0043-locking-ww_mutex-Split-out-the-W-W-implementation-lo.patch \
      PREEMPT_RT/0044-locking-ww_mutex-Remove-the-__sched-annotation-from-.patch \
      PREEMPT_RT/0045-locking-ww_mutex-Abstract-out-the-waiter-iteration.patch \
      PREEMPT_RT/0046-locking-ww_mutex-Abstract-out-waiter-enqueueing.patch \
      PREEMPT_RT/0047-locking-ww_mutex-Abstract-out-mutex-accessors.patch \
      PREEMPT_RT/0048-locking-ww_mutex-Abstract-out-mutex-types.patch \
      PREEMPT_RT/0049-locking-ww_mutex-Abstract-out-internal-lock-accesses.patch \
      PREEMPT_RT/0050-locking-ww_mutex-Implement-rt_mutex-accessors.patch \
      PREEMPT_RT/0051-locking-ww_mutex-Add-RT-priority-to-W-W-order.patch \
      PREEMPT_RT/0052-locking-ww_mutex-Add-rt_mutex-based-lock-type-and-ac.patch \
      PREEMPT_RT/0053-locking-rtmutex-Extend-the-rtmutex-core-to-support-w.patch \
      PREEMPT_RT/0054-locking-ww_mutex-Implement-rtmutex-based-ww_mutex-AP.patch \
      PREEMPT_RT/0055-locking-rtmutex-Add-mutex-variant-for-RT.patch \
      PREEMPT_RT/0056-lib-test_lockup-Adapt-to-changed-variables.patch \
      PREEMPT_RT/0067-locking-rtmutex-Prevent-lockdep-false-positive-with-.patch \
      PREEMPT_RT/0068-preempt-Adjust-PREEMPT_LOCK_OFFSET-for-RT.patch \
      PREEMPT_RT/0069-locking-rtmutex-Implement-equal-priority-lock-steali.patch \
      PREEMPT_RT/0070-locking-rtmutex-Add-adaptive-spinwait-mechanism.patch \
      PREEMPT_RT/0071-locking-spinlock-rt-Prepare-for-RT-local_lock.patch \
      PREEMPT_RT/0072-locking-local_lock-Add-PREEMPT_RT-support.patch \
      PREEMPT_RT/locking-ww_mutex-Initialize-waiter.ww_ctx-properly.patch \
      PREEMPT_RT/locking-rtmutex-Dont-dereference-waiter-lockless.patch \
      PREEMPT_RT/locking-rtmutex-Dequeue-waiter-on-ww_mutex-deadlock.patch \
      PREEMPT_RT/locking-rtmutex-Return-success-on-deadlock-for-ww_mu.patch \
      PREEMPT_RT/locking-rtmutex-Prevent-spurious-EDEADLK-return-caus.patch \
      PREEMPT_RT/x86_entry__Use_should_resched_in_idtentry_exit_cond_resched.patch \
      PREEMPT_RT/x86__Support_for_lazy_preemption.patch \
      PREEMPT_RT/arm__Add_support_for_lazy_preemption.patch \
      PREEMPT_RT/powerpc__Add_support_for_lazy_preemption.patch \
      PREEMPT_RT/arch_arm64__Add_lazy_preempt_support.patch \
      PREEMPT_RT/0001_cpu_pm_make_notifier_chain_use_a_raw_spinlock_t.patch \
      PREEMPT_RT/0002_notifier_remove_atomic_notifier_call_chain_robust.patch \
      PREEMPT_RT/sysfs__Add__sys_kernel_realtime_entry.patch \
      PREEMPT_RT/printk_console__Check_consistent_sequence_number_when_handling_race_in_console_unlock.patch \
      PREEMPT_RT/lib_nmi_backtrace__explicitly_serialize_banner_and_regs.patch \
      PREEMPT_RT/printk__track_limit_recursion.patch \
      PREEMPT_RT/printk__remove_safe_buffers.patch \
      PREEMPT_RT/printk__remove_NMI_tracking.patch \
      PREEMPT_RT/printk__convert_syslog_lock_to_mutex.patch \
      PREEMPT_RT/printk__syslog__close_window_between_wait_and_read.patch \
      PREEMPT_RT/printk__rename_printk_cpulock_API_and_always_disable_interrupts.patch \
      PREEMPT_RT/console__add_write_atomic_interface.patch \
      PREEMPT_RT/kdb__only_use_atomic_consoles_for_output_mirroring.patch \
      PREEMPT_RT/serial__8250__implement_write_atomic.patch \
      PREEMPT_RT/printk__relocate_printk_delay.patch \
      PREEMPT_RT/printk__call_boot_delay_msec_in_printk_delay.patch \
      PREEMPT_RT/printk__use_seqcount_latch_for_console_seq.patch \
      PREEMPT_RT/printk__introduce_kernel_sync_mode.patch \
      PREEMPT_RT/printk__move_console_printing_to_kthreads.patch \
      PREEMPT_RT/printk__remove_deferred_printing.patch \
      PREEMPT_RT/printk__add_console_handover.patch \
      PREEMPT_RT/printk__add_pr_flush.patch \
      PREEMPT_RT/printk__Enhance_the_condition_check_of_msleep_in_pr_flush.patch \
      PREEMPT_RT/crypto__limit_more_FPU-enabled_sections.patch \
      PREEMPT_RT/crypto__cryptd_-_add_a_lock_instead_preempt_disable_local_bh_disable.patch \
      PREEMPT_RT/crypto-testmgr-Only-disable-migration-in-crypto_disa.patch \
      noir_base/noir_base.patch \
      noir_base/custom_config.patch \
      other/cacule-5.14-full.patch \
      other/prjc_v5.14-r3.patch \
      > noir.patch
;;

esac
