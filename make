#!/bin/bash
NAME=bashcord
PREFIX=/usr/bin/

TASK="$1"
shift

case "$TASK" in
''|$NAME)
    rm -f $NAME
    for src in lib/*; do
        cat $src >>$NAME
    done
    ;;

tiny)
    $0 $NAME
    echo "warning: reported line numbers might be incorrect in tiny version"
    awk 'NF' $NAME >$NAME.tiny
    mv $NAME.tiny $NAME
    ;;

tests)
    $0 $NAME
    rm -f tests.log
    i=0
    j=0
    for tst in tests/*; do
        printf "\033[34;1m->\033[m %s... " "$tst"
        (( i++ ))
        bash -e $tst 2>>tests.log
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
    
overview)
    $0 $NAME
    source $NAME
    for module in "${!MODULES[@]}"; do
        case "$module" in
        *':name')
            name="${MODULES[$module]}"
            printf "\033[34;1m%-10s\033[m \033[2;3m%s\033[m\n" \
                "$name" "${MODULES[$name:desc]}"
            for global in "${!GLOBALS[@]}"; do
                case "$global" in
                $name':'*':name')
                    printf "    - %s\n" "${GLOBALS[$global]}"
                ;;
                esac
            done
            for method in "${!METHODS[@]}"; do
                case "$method" in
                $name':'*':name')
                    printf "    - \033[1m%s\033[m()\n" \
                        "${METHODS[$method]}"
                    ;;
                esac
            done
            ;;
        esac
    done
    ;;

clean)
    rm -f $NAME
    ;;
    
install)
    $0 $NAME
    install -Dm755 $NAME $PREFIX$NAME
    ;;
esac
