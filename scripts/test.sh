#!/usr/bin/env bash
# test.sh - test bashcord.sh

source config.sh

[ -f bashcord.sh ] || scripts/build.sh

for test in $(find tests -name '*.sh'); do
    printf "[ ] $test"
    if $test 1>&2 2>>test.log; then
        printf "\r[\033[32mv\033[m]\n"
    else
        printf "\r[\033[31mx\033[m]"
    fi
done
