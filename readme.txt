Custom linux kernel "Noir Linux kernel" Build Script
Web site URL : https://note.com/vsrx
Created by takamitsu_h
December 15,2025

このカスタムカーネルは、Ubuntu向けです。
リアルタイム性能・レスポンス性能の向上を図ります。

カーネルをビルドをする場合は、以下の物が必要です。いずれもAPT経由で入手出来ます。
- build-essential
- GCC
- debhelper
- libdw-dev

Gitのリリースページで公開しているバイナリをダウンロードしてインストールする場合は以下のコマンドを使います。
[リリースページ]
https://github.com/takabrk/noir_linux_kernel/releases

$ sudo dpkg -i *.deb


カスタムカーネルには、様々なパッチを適用しています。
noir_zen.patch、noir_bore.patchは、それらのパッチを統合した物であり、これをバニラカーネル( https://www.kernel.org )のソースコードに当てる事で、カスタムカーネル用のソースコードを作る事も可能です。
ZEN版、あるいはBORE版をビルド出来ます。

1.Noir Linux Kernelパッチの組み立て
$ ./build.sh -e patch -f zen (ZEN版)
$ ./build.sh -e patch -f xenomai (BORE版)

2.バニラカーネルのソースコード取得と解凍
$ ./build.sh -e vanilla -f zen (ZEN版)
$ ./build.sh -e vanilla -f xenomai (BORE版)

3.パッチ当て
$ ./build.sh -e source -f zen (ZEN版)
$ ./build.sh -e source -f xenomai (BORE版)

4.前述を行った後にカスタムカーネルのビルド
$ ./build.sh -e build -f zen (ZEN版)
$ ./build.sh -e build -f xenomai (BORE版)

5.カーネルのインストール
$ ./build.sh -e install_kernel -f zen (ZEN版)
$ ./build.sh -e install_kernel -f bore (BORE版)

[ZEN版スペック]
- Built on the GCC 13.3.0
- CPU scheduler -> EEVDF
- Default I/O scheduler -> MQ-deadline
- Processor family -> Generic X86_64
- Preemption Model -> Fully Preemptible Kernel (Real Time) 
- CPU Timer frequency -> 700Hz
- Kernel Compression mode -> zstd
- RCU boost delay -> 339
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- Core scheduling for SMT ON
- futex support
- BBR3 support
- Clear Linux support
- Zen Interactive support

[BORE版スペック]
- Built on the GCC 13.3.0
- CPU scheduler -> BORE
- Default I/O scheduler -> MQ-deadline
- Processor family -> Generic X86_64
- Preemption Model -> Fully Preemptible Kernel (Real Time) 
- CPU Timer frequency -> 700Hz
- Kernel Compression mode -> zstd
- RCU boost delay -> 339
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- Core scheduling for SMT ON
- futex support
- BBR3 support
- Clear Linux support
- VHBA support
- ACS override support

[patches]
https://www.kernel.org/
https://github.com/zen-kernel/zen-kernel
https://github.com/sirlucjan/kernel-patches 
https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/
https://github.com/Frogging-Family/linux-tkg
https://github.com/firelzrd/bore-scheduler
https://gitlab.com/xanmod/linux-patches

◇I/Oスケジューラー確認方法
現在使っているI/Oスケジューラーの確認方法は、端末で以下のコマンドを実行する事で出来ます。

$ cat /sys/block/sd*/queue/scheduler

I/Oスケジューラーを変更するには、以下のコマンドを実行します。

# echo 変更したいスケジューラー > /sys/block/sda/queue/scheduler

設定を永続化するには、起動時に「elevator=変更したいスケジューラー」を付けます。

システムのパフォーマンスとPulseAudioの音質を向上させたい場合は、以下のコマンドを使います。
$ ./performanceup.sh
