Custom linux kernel "Noir Linux kernel"
Web site URL : http://vsrx.work
Created by takamitsu hamada
June 15,2022

このカスタムカーネルは、Ubuntu/Debian向けです。
Ubuntu公式のカーネルと比較して、レスポンス性能やデスクトップ用途・ゲーミング用途におけるパフォーマンスを大きく引き上げる事が出来ます。

Gitのリリースページで公開しているバイナリをダウンロードしてインストールする場合は以下のコマンドを使います。
[リリースページ]
https://github.com/takabrk/noir_linux_kernel/releases

$ sudo dpkg -i *.deb

システムのパフォーマンスとPulseAudioの音質を向上させたい場合は、以下のコマンドを使います。
$ ./performanceup.sh

カスタムカーネルには、様々なパッチを適用しています。
noir.patchというファイルは、それらのパッチを統合した物であり、これをバニラカーネル( https://www.kernel.org )のソースコードに当てる事で、カスタムカーネル用のソースコードを作る事も可能です。

◇Noir Linux Kernelパッチの組み立て（基本的には既にnoir.patchは作成済みであるので、使う必要なし）
◯Linux 5.18系の場合
$ cd patches
$ ./build_noir_patch.sh -e 518

◇バニラカーネルのソースコードのダウンロードとパッチ当て（カスタムカーネルのビルド作業は、ここから始める）
- ソースコード取得・パッチ当て
$ ./build.sh -e base

◇前述を行った後にカスタムカーネルのビルドとインストール
$ ./build.sh -e core


- Built on the GCC 11.1.0
- CPU scheduler -> CFS
- Default I/O scheduler -> Kyber
- Processor family -> Generic X86_64
- Kernel Compression mode -> zstd
- Preemption Model -> Preemptible Kernel(low latency desktop)
- CPU Timer frequency -> 750Hz
- RCU boost delay -> 339
- Compiler optimization level -> Optimize for more performance(-O3)
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- nr_migrate = 256
- rq_affinity = 2
- vm_swappiness = 33
- clear linux on
- futex support
- PCIe ACS support
- OpenRGB support
- Zen Interactive Tune support
- CK's hightimer support

[patches]
- linux update patch( https://www.kernel.org/ )
- sirlucjan's patches( https://github.com/sirlucjan/kernel-patches )
- CK's hrtimer patchset( http://ck.kolivas.org/patches/5.0/5.12/5.12-ck1/patches/ )
- Zen( https://github.com/zen-kernel/zen-kernel/tree/5.15/master )

◇I/Oスケジューラー確認方法
現在使っているI/Oスケジューラーの確認方法は、端末で以下のコマンドを実行する事で出来ます。

$ cat /sys/block/sd*/queue/scheduler

I/Oスケジューラーを変更するには、以下のコマンドを実行します。

# echo 変更したいスケジューラー > /sys/block/sda/queue/scheduler

設定を永続化するには、起動時に「elevator=変更したいスケジューラー」を付けます。
