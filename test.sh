#!/usr/bin/env bash
trap 'cd ..; rm -rf tmp' EXIT
mkdir -p tmp
cp test/$1.sh tmp
cp -r lib tmp/bashcord
cd tmp
./$1.sh
