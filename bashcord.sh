#!/bin/bash
# bashcord - shell script Discord API wrapper

###########
# Utility #
###########
e_fatal=0; e_error=1; e_warn=2; e_event=3; e_info=4; e_debug=5; e_all=6
LOG_LEVEL=${e_all}
log() {
	if [ $(eval echo "\$e_${1}") -gt ${LOG_LEVEL} ]; then return; fi
	case "${1}" in
		fatal)c="31;1";;
		error)c="31"  ;;
		warn) c="33"  ;;
		event)c="36;1";;
		info) c="32"  ;;
		debug)c="34"  ;;
	esac
	printf "%s \033[%sm%-6s\033[m %s\n" "$(date +%T)" "${c}" "${1}" "${2}" >&2
}

die() { log fatal "${2}"; exit "${1}"; }

require() {
	for p in "${@}"; do
		if ! [ -x "$(which "${p}")" ]; then
			programs="${programs} ${p}"
		fi
	done
	if [ -n "${programs}" ]; then 
		log error "Requirement(s) not installed:${programs}"
	else
		log info "All requirements met"
	fi
}

api() {
	[ -z "${1}" ]         && log error "No method for request" && return 1
	[ -z "${2}" ]         && log error "No endpoint for request" && return 1
	[ -z "${BOT_AUTH}" ]  && log error "Authorization not defined" && return 1
	[ -z "${BOT_AGENT}" ] && log error "Bot User-Agent not defined" && return 1
	log debug "${1} to ${2} $([ -n "${3}" ] && echo "with ${3}")"
	curl -X "${1}" -s -H "${BOT_AUTH}" -A "${BOT_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}")
	[ $? -eq 0 ] || log error "${1} Request to '${2}' failed" 
}

################
# Requirements #
################
require curl jq websocat

############
# Defaults #
############
BOT_URL="https://github.com/0xfi/bashcord"
BOT_VERSION="1.0"
FIFO_PATH="/tmp/bashcord.fifo"

# Default pre_init.
#
_pre_init() {
	log event "Starting Bashcord...";
}

# Default init.
#
_init() {
    name="$(api GET /users/@me | jq .username -r)"
    if [ -z "${name}" ]; then
        die 1 "Cannot reach server, please check authorization token and try again \
if the problem persists, please open an issue at https://github/com/0xfi/bashcord"
    fi
    log info "Connecting as... ${name}"
}

# Setup some things and connect to the Discord API.
#
connect() {
	[ "$(type pre_init 2>/dev/null)" == "function" ] && pre_init || _pre_init
	[ -z "${API_TOKEN}" ] && error "API token not set" && exit
	API_TOKEN="$(cat token)"
	BOT_AUTH="Authorization: ${API_TOKEN}" 
	log debug "${BOT_AUTH}"
	if [ -z "${API_VERSION}" ]; then
		API="https://discordapp.com/api"
	else
		log info "Using API v${API_VERSION}"B
		API="https://discordapp.com/api/v${API_VERSION}"
	fi
	BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	log debug "User-Agent: ${BOT_AGENT}"
	[ "$(type -t init 2>/dev/null)" == "function" ] && init || _init
	SOCKET_URL="$(api GET /gateway | jq .url -r)"
	log debug "Socket: ${SOCKET_URL}"
	if [ -e "${FIFO_PATH}" ]; then
		log info "Stealing old FIFO"
	else
		log info "New FIFO"
		mkfifo -m 600 "${FIFO_PATH}"
	fi
	while read -r -t 1 response || true; do
		[ -z "$response" ] && log error "No response..."
		log debug ">> $response"
	done <"${FIFO_PATH}" | websocat "${SOCKET_URL}" >"${FIFO_PATH}"
}
