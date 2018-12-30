receiver() {
    SEQ=null
    EVENT=null
    while :; do
        payload="$(< "${FIFO_PATH}.in")"
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
            11) RECEIVED_ACK=true;;
            *) log error "Unknown opcode received: $OP";;
        esac
    done
}

pulse() {
    RECEIVED_ACK=true
    while sleep ${HEARTBEAT_INTERVAL}e-3; do
        if $RECEIVED_ACK; then
            heartbeat
            RECEIVED_ACK=false
        else
            die 9999 "Failed to received HEARTBEAT_ACK"
        fi
    done
}
