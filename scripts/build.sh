#!/usr/bin/env bash
# make.sh - build helper

source config.sh

rm bashcord.sh

for src in $(find lib -name '*.sh'); do
    echo "-> $src"
    printf "# -- %-20s -- #\n" "$src" >>$NAME.sh
    [ -f $src ] && cat $src >>$NAME.sh
done
