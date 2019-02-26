#!/bin/bash
NAME=bashcord
PREFIX=/usr/bin/

TASK="$1"
shift

case "$TASK" in
tests)
    rm -f tests.log
    i=0
    j=0
    for tst in tests/*; do
        printf "\033[34;1m->\033[m %s... " "$tst"
        (( i++ ))
        echo "--- TEST $tst ---" >>tests.1.log
        echo "--- TEST $tst ---" >>tests.2.log
        BASHCORD_DEBUG=true bash -e $tst 2>>tests.2.log 1>>tests.1.log
        if [ $? -eq 0 ]; then
            printf "\033[32;1mok\033[m\n"
            (( j++ ))
        else
            printf "\033[31;1mfailed\033[m\n"
        fi
    done
    printf "\n$j/$i"
    if [ $j -eq $i ]; then
        printf "\033[32;1m :)\033[m\n"
    elif [ $j -gt $(( $i / 2 )) ]; then
        printf "\033[33;1m :|\033[m\n"
    else
        printf "\033[31;1m :(\033[m\n"
    fi
    ;;
    
install)
    install -Dm755 $NAME $PREFIX$NAME
    ;;
esac
