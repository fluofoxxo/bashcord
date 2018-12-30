rest() {
	log debug "${1} ${2} $([ -n "${3}" ] && echo "(${3})")"
	curl -X "${1}" -H "${API_AUTH}" -A "${API_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}") -s
	[ $? -eq 0 ] || log error "${1} request failed" 
}

configure() {
	if [ -z "${BOT_URL}" ]; then
		BOT_URL="https://github.com/0xfi/bashcord"
		log warning "BOT_URL not set, defaulting to ${BOT_URL}"
	fi
	if [ -z "${BOT_VERSION}" ]; then
		BOT_VERSION="1.0"
		log warning "BOT_VERSION not set, defaulting to ${BOT_VERSION}"
	fi
	[ -z "${API_TOKEN}" ] && die 12 "BOT_TOKEN not set"
	API_AUTH="Authorization: Bot ${API_TOKEN}"
	if [ -z "${API_VERSION}"]; then
		API="https://discordapp.com/api" 
	else
		log info "Using API v${API_VERSION}"
		API="https://discordapp.com/api/v/${API_VERSION}"
	fi
	API_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	log debug "User-Agent: ${API_AGENT}"
	API_SOCKET="$(reset GET /gateway | jq .url)"
	log debug "Socket: ${API_SOCKET}"
}

clean() {
	cd ..
	rm -rf tmp
}

connect() {
	trap 'clean' EXIT
	mkdir -p tmp; cd tmp
	[ -e "in" ]  || mkfifo -m 600 "in"
	[ -e "out" ] || mkfifo -m 600 "out"
	websocat "${SOCKET_URL}" <"${FIFO_PATH}.in" >"${FIFO_PATH}.out" &
}
