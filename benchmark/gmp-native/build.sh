#!/usr/bin/env bash

gcc -O2 -I/home/attila/now-is-the-time/gmp-lawl-native -L/home/attila/now-is-the-time/gmp-lawl-native/.libs  main.c -lgmp -o main.out
