clean() {
	cd ..
	rm -rf "${CLIENT_PATH}"
}

client:configure() {
	if [ -z "${CLIENT_URL}" ]; then
		BOT_URL="https://github.com/0xfi/bashcord"
		log debug "CLIENT_URL not set, defaulting to '${CLIENT_URL}'"
	fi
	if [ -z "${CLIENT_VERSION}" ]; then
		BOT_VERSION="1.0"
		log debug "CLIENT_VERSION not set, defaulting to '${CLIENT_VERSION}'"
	fi
	BOT_AGENT="DiscordBot (${CLIENT_URL}, ${CLIENT_VERSION})"
	log debug "User-Agent: ${CLIENT_AGENT}"
	if [ -z "${CLIENT_PATH}" ]; then
		CLIENT_PATH="/tmp/bashcord"
		log debug "CLIENT_PATH not set, defaulting to '${CLIENT_PATH}'"
	fi
	[ -z "${CLIENT_TOKEN}" ] && die 12 "CLIENT_TOKEN not set"
	CLIENT_AUTH="Authorization: Bot ${CLIENT_TOKEN}"
	log debug "${CLIENT_AUTH}"
	CLIENT_BASE="https://discordapp.com/api"
	log debug "REST URL: ${CLIENT_BASE}"
	CLIENT_SOCKET="$(reset GET /gateway | jq .url)"
	log debug "Socket URL: ${CLIENT_SOCKET}"
}

client:init() {
	trap 'clean' EXIT
	mkdir -p "${CLIENT_PATH}"
	cd "${CLIENT_PATH}"
	me="$(api:me)"
	if [ -n "${me}" ]; then
		log info "Connected as ${me}"
	[ -e "in" ]  || mkfifo -m 600 "in"
	[ -e "out" ] || mkfifo -m 600 "out"
	websocat "${CLIENT_SOCKET}" < "in" > "out" &
}

client:connect() {
    SEQ=null
    EVENT=null
    while :; do
        payload="$(< "in")"
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
            11) state set HEARTBEAT_ACK true;;
            *) log error "Unknown opcode received: $OP";;
        esac
    done
}

client:pulse() {
    state set HEARBEAT_ACK true
    while sleep ${HEARTBEAT_INTERVAL}e-3; do
        if $(state get HEARTBEAT_ACK); then
            heartbeat
            state set HEARBEAT_ACK false
        else
            die 9999 "Failed to received HEARTBEAT_ACK"
        fi
    done
}
