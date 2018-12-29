rest() {
	log debug "${1} ${2} $([ -n "${3}" ] && echo "(${3})")"
	curl -X "${1}" -H "${BOT_AUTH}" -A "${BOT_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}") -s
	[ $? -eq 0 ] || log error "${1} Request to '${2}' $([ -n "${3}" ] && echo "with '${3}' ")failed" 
}

receive() {
	read -r payload <"${FIFO_PATH}.in"
	OP="$(echo "${payload}" | jq .op)"
	DATA="$(echo "${payload}" | jq .d)"
	if [ $op -eq 0 ]; then
		SEQ="$(echo "${payload}" | jq .s)"
		EVENT="$(echo "${payload}" | jq .t)"
	fi
	return op
}

configure() {
	if [ -z "${FIFO_PATH}" ]; then
		FIFO_PATH="/tmp/bashcord.fifo"
		log warning "FIFO_PATH not set, defaulting to ${FIFO_PATH}"
	fi
	if [ -z "${BOT_URL}" ]; then
		BOT_URL="https://github.com/0xfi/bashcord"
		log warning "BOT_URL not set, defaulting to ${BOT_URL}"
	fi
	if [ -z "${BOT_VERSION}" ]; then
		BOT_VERSION="1.0"
		log warning "BOT_VERSION not set, defaulting to ${BOT_VERSION}"
	fi
	[ -z "${BOT_TOKEN}" ] && die 12 "BOT_TOKEN not set"
	BOT_AUTH="Authorization: Bot ${API_TOKEN}"
	if [ -z "${API_VERSION}"]; then
		API="https://discordapp.com/api" 
	else
		log info "Using API v${API_VERSION}"
		API="https://discordapp.com/api/v/${API_VERSION}"
	fi
	BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	log debug "User-Agent: ${BOT_AGENT}"
}

connect() {
	SOCKET_URL="$(rest GET /gateway | jq .url -r)"
	log debug "Socket: ${SOCKET_URL}"
	[ -e "${FIFO_PATH}.in" ] ||
		mkfifo -m 600 "${FIFO_PATH}.in"
	[ -e "${FIFO_PATH}.out" ] ||
		mkfifo -m 600 "${FIFO_PATH}.out"
	websocat "${SOCKET_URL}" <"${FIFO_PATH}.in" >"${FIFO_PATH}.out" &
}
