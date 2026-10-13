#!/bin/sh
cd /lib/firmware
sudo find ./* -type f -name "*.zst" -exec unzstd -f {} \; -print
sudo find ./* -type f -name "*.zst" -exec rm -f {} \; -print