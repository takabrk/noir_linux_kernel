Custom linux kernel "Noir Linux kernel"
Web site URL : http://vsrx.work
Created by takamitsu hamada
September 1,2021

このカスタムカーネルは、Ubuntu/Debian向けです。
Ubuntu公式のカーネルと比較して、レスポンス性能やデスクトップ用途・ゲーミング用途におけるパフォーマンスを大きく引き上げる事が出来ます。

以下のコマンドでインストールが可能です。
$ ./install_kernel.sh

システムのパフォーマンスとPulseAudioの音質を向上させたい場合は、以下のコマンドを使います。
$ ./performanceup.sh

カスタムカーネルには、様々なパッチを適用しています。
noir.patchというファイルは、それらのパッチを統合した物であり、これをバニラカーネル(https://git.kernel.org/torvalds/t/linux-5.13.tar.gz)のソースコードに当てる事で、カスタムカーネル用のソースコードを作る事も可能です。
また、既にカスタムカーネルのパッチを当てているソースコードも同梱しています。

◇バニラカーネルのソースコードのダウンロードとパッチ当て
$ ./build.sh -e base

◇前述を行った後にカスタムカーネルのビルド
$ ./build.sh -e core

- CPU shceduler -> CacULE
- Default I/O scheduler -> Kyber
- Processer family -> Generic X86_64
- Kernel Compression mode -> zstd
- Preemption Model -> Preemptible Kernel(lowlatency desktop)
- CPU Timer frequency -> 2000Hz
- RCU boost delay -> 0
- Compiler optimization level -> Optimize for more performance(-O3)
- Timer tick handling -> Full dynticks system
- Default CPUFreq Governor -> performance
- HD-audio pre-allocated buffer size 4096
- BBR TCP Congestion Control
- Built on the GCC 11.1.0
- CPU idle governor -> TEO
- ZSTD kernel and initram support
- Futex/Futex2 support