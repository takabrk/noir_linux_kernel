Custom linux kernel "Noir Linux kernel"
Web site URL : http://vsrx.work
Created by takamitsu hamada
September 3,2021

このカスタムカーネルは、Ubuntu/Debian向けです。
Ubuntu公式のカーネルと比較して、レスポンス性能やデスクトップ用途・ゲーミング用途におけるパフォーマンスを大きく引き上げる事が出来ます。

以下のコマンドでインストールが可能です。
$ ./install_kernel.sh

システムのパフォーマンスとPulseAudioの音質を向上させたい場合は、以下のコマンドを使います。
$ ./performanceup.sh

カスタムカーネルには、様々なパッチを適用しています。
noir.patchというファイルは、それらのパッチを統合した物であり、これをバニラカーネル( https://www.kernel.org )のソースコードに当てる事で、カスタムカーネル用のソースコードを作る事も可能です。

◇バニラカーネルのソースコードのダウンロードとパッチ当て
$ ./build.sh -e base

◇前述を行った後にカスタムカーネルのビルド
$ ./build.sh -e core

- Built on the GCC 11.1.0
- CPU shceduler -> CacULE
- Default I/O scheduler -> Kyber
- Processer family -> Generic X86_64
- Kernel Compression mode -> zstd
- Preemption Model -> Preemptible Kernel(lowlatency desktop)
- CPU Timer frequency -> 2000Hz
- RCU boost delay -> 0
- Compiler optimization level -> Optimize for more performance(-O3)
- Timer tick handling -> Idle dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- nr_migrate = 256
- UKSM support
- BBR2 support
- futex/futex2 support
- ZSTD kernel and initram support
- Aufs support
- clear linux on
- winesync support
- PCIe ACS Override support
- OpenRGB
- VHBA

[patches]
- linux update patch( https://www.kernel.org/ )
- CacULE( https://github.com/hamadmarri/cacule-cpu-scheduler )
- sirlucjan's patches( https://github.com/sirlucjan/kernel-patches )
- CK's hrtimer patchset( http://www.users.on.net/~ckolivas/kernel/ )
- le9( https://github.com/hakavlad/le9-patch )
- Zen( https://github.com/zen-kernel/zen-kernel/tree/5.14/master )

◇CacULEのレスポンス向上コマンド
$ sudo sysctl kernel.sched_interactivity_factor=50
$ sudo sysctl kernel.sched_max_lifetime_ms=60000

永続化したい場合は、/etc/sysctl.d/90-override.confに以下を追加

kernel.sched_interactivity_factor=50
kernel.sched_max_lifetime_ms=60000

◇I/Oスケジューラー確認方法
現在使っているI/Oスケジューラーの確認方法は、端末で以下のコマンドを実行する事で出来ます。

$ cat /sys/block/sd*/queue/scheduler

I/Oスケジューラーを変更するには、以下のコマンドを実行します。

# echo 変更したいスケジューラー > /sys/block/sda/queue/scheduler

設定を永続化するには、起動時に「elevator=変更したいスケジューラー」を付けます。