Custom linux kernel "Noir Linux kernel"
Web site URL : http://vsrx.work
Created by takamitsu hamada
March 11,2023

このカスタムカーネルは、Ubuntu向けです。
リアルタイム性能・レスポンス性能の向上を図ります。

Gitのリリースページで公開しているバイナリをダウンロードしてインストールする場合は以下のコマンドを使います。
[リリースページ]
https://github.com/takabrk/noir_linux_kernel/releases

$ sudo dpkg -i *.deb

システムのパフォーマンスとPulseAudioの音質を向上させたい場合は、以下のコマンドを使います。
$ ./performanceup.sh

カスタムカーネルには、様々なパッチを適用しています。
noir.patchというファイルは、それらのパッチを統合した物であり、これをバニラカーネル( https://www.kernel.org )のソースコードに当てる事で、カスタムカーネル用のソースコードを作る事も可能です。

◇Noir Linux Kernelパッチの組み立て
$ ./build.sh -e patch

◇バニラカーネルのソースコードのダウンロードとパッチ当て（カスタムカーネルのビルド作業は、ここから始める）
- ソースコード取得・パッチ当て
$ ./build.sh -e source

◇前述を行った後にカスタムカーネルのビルドとインストール
$ ./build.sh -e build


- Built on the GCC 12.1.0
- CPU scheduler -> CFS
- Default I/O scheduler -> BFQ
- Processor family -> Generic X86_64
- Kernel Compression mode -> zstd
- Preemption Model -> Full Preemptible Kernel(Real Time)
- CPU Timer frequency -> 500Hz
- RCU boost delay -> 339
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- vm_swappiness = 30
- VM_READAHEAD_PAGES=8MB
- dcache-cache_pressure=50
- futex support
- PCIe ACS support
- OpenRGB support
- Zen Interactive Tune support
- Core scheduling for SMT ON
- Clear Linux support
- BBR2 support
- AMD p-state support
- winesync support

[patches]
https://www.kernel.org/
https://github.com/zen-kernel/zen-kernel/tree/6.2/master
https://github.com/sirlucjan/kernel-patches 
https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/
https://github.com/Frogging-Family/linux-tkg

◇I/Oスケジューラー確認方法
現在使っているI/Oスケジューラーの確認方法は、端末で以下のコマンドを実行する事で出来ます。

$ cat /sys/block/sd*/queue/scheduler

I/Oスケジューラーを変更するには、以下のコマンドを実行します。

# echo 変更したいスケジューラー > /sys/block/sda/queue/scheduler

設定を永続化するには、起動時に「elevator=変更したいスケジューラー」を付けます。
