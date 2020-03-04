#!/usr/bin/env bash

clang \
 -O2 \
 --target=wasm32-unknown-wasi \
 --sysroot=/home/attila/wasi-libc/sysroot \
-I/home/attila/now-is-the-time/gmp-lawl-wasi/gmp-lawl \
/home/attila/now-is-the-time/gmp-lawl-wasi/gmp-lawl/*.o \
/home/attila/now-is-the-time/gmp-lawl-wasi/gmp-lawl/mpn/*.o \
/home/attila/now-is-the-time/gmp-lawl-wasi/gmp-lawl/mpz/*.o \
main.c \
-o main.wasm
