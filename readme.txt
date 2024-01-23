Custom linux kernel "Noir Linux kernel"
Web site URL : http://vsrx.work
Created by takamitsu hamada
January 23,2024

このカスタムカーネルは、Ubuntu向けです。
リアルタイム性能・レスポンス性能の向上を図ります。

カーネルをビルドをする場合は、以下の物が必要です。いずれもAPT経由で入手出来ます。
- build-essential
- GCC
- debhelper

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

◇バニラカーネルのソースコード取得と解凍
$ ./build.sh -e vanilla

◇パッチ当て
$ ./build.sh -e source

◇前述を行った後にカスタムカーネルのビルド
$ ./build.sh -e build

◇ビルドしたカスタムカーネルのインストール
$ ./build.sh -e install_kernel

- Built on the GCC 12.1.0
- CPU scheduler -> EEVDF
- Default I/O scheduler -> BFQ
- Processor family -> Generic X86_64
- Kernel Compression mode -> zstd
- RCU boost delay -> 339
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> schedutil
- CPU idle governor -> TEO
- futex support
- Core scheduling for SMT ON
- AMD p-state support
- Preemption Model -> Full Preemptible Kernel(Real Time)
- CPU Timer frequency -> 500Hz
- OpenRGB support
- Zen Interactive Tune support
- futex support
- WineSync support
- Clear Linux support

[patches]
https://www.kernel.org/
https://github.com/zen-kernel/zen-kernel/tree/6.5/master
https://github.com/sirlucjan/kernel-patches 
https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/
https://github.com/Frogging-Family/linux-tkg

◇I/Oスケジューラー確認方法
現在使っているI/Oスケジューラーの確認方法は、端末で以下のコマンドを実行する事で出来ます。

$ cat /sys/block/sd*/queue/scheduler

I/Oスケジューラーを変更するには、以下のコマンドを実行します。

# echo 変更したいスケジューラー > /sys/block/sda/queue/scheduler

設定を永続化するには、起動時に「elevator=変更したいスケジューラー」を付けます。
