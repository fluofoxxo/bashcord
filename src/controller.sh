receiver() {
    while :; do
    while read -r payload; do
        OP="$(echo "$payload" | jq .op)"
        DATA="$(echo "$payload" | jq .d)"
        if [ $OP -eq 0 ]; then
            SEQ="$(echo "$payload" | jq .s)"
            EVENT="$(echo "$payload" | jq .t)"
        fi
        case $OP in
            0) dispatch;;
            1) heartbeat;;
            7) reconnect;;
            9) die 69 "Session is invalid";;
            10) hello;;
            *) log error "Unknown opcode received: $OP";;
        esac
    done < <(cat "$FIFO_PATH.in")
    done
}

ticker { :; }
