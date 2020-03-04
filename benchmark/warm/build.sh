#!/usr/bin/env bash

 "/usr/lib/llvm-9/bin/clang" -cc1 -O2 -triple wasm32-unknown-wasi -emit-obj -mrelax-all -disable-free -disable-llvm-verifier -discard-value-names -main-file-name main.c -mrelocation-model static -mthread-model posix -masm-verbose -mconstructor-aliases -fuse-init-array -target-cpu generic -fvisibility hidden -dwarf-column-info -debugger-tuning=gdb -momit-leaf-frame-pointer -v -resource-dir /usr/lib/llvm-9/lib/clang/9.0.0 -isysroot /home/attila/wasi-libc/sysroot -internal-isystem /usr/lib/llvm-9/lib/clang/9.0.0/include -internal-isystem /home/attila/wasi-libc/sysroot/include/wasm32-wasi -internal-isystem /home/attila/wasi-libc/sysroot/include -fdebug-compilation-dir /home/attila/now-is-the-time/warm-experiment -ferror-limit 19 -fmessage-length 0 -fobjc-runtime=gnustep -fno-common -fdiagnostics-show-option -fcolor-diagnostics -I../../warm/include -o ./main.o -x c ./main.c

"/usr/bin/wasm-ld" --allow-undefined -L/home/attila/wasi-libc/sysroot/lib/wasm32-wasi /home/attila/wasi-libc/sysroot/lib/wasm32-wasi/crt1.o ./main.o -lc /usr/lib/llvm-9/lib/clang/9.0.0/lib/wasi/libclang_rt.builtins-wasm32.a -o f.wasm --initial-memory=6553600


