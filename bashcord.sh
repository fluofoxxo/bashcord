#!/bin/bash
# bashcord - shell script Discord API wrapper
# despite the name, it *should* be all POSIX SH except for the usage of read

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
	tag="\033[${c}m${1}\033[m"
	${LOGGING_NOCOLOR} && tag="${1}"
	printf "$(date +%T) [${tag}] ${2}\n"
}
die() { log fatal "${2}"; exit "${1}"; }
ereturn() { log error "${2}"; return "${1}"; }
require() {
	if ! [ -x "$(which "${1}")" ]; then
		ereturn 1 "'${1}' is required but not installed"
	fi
}
api() {
	# TODO: Implement caching
	[ -z "${1}" ]         && ereturn 1 "No method for request"
	[ -z "${2}" ]         && ereturn 2 "No endpoint for request"
	[ -z "${BOT_AUTH}" ]  && ereturn 3 "Authorization not defined"
	[ -z "${BOT_AGENT}" ] && ereturn 4 "Bot User-Agent not defined"
	debug "${1} to ${2} $([ -n "${3}" ] && echo "with ${3}")"
	curl -X "${1}" -s -H "${BOT_AUTH}" -A "${BOT_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}")
	[ $? -eq 0 ] || log error "${1} Request to '${2}' failed" 
}

################
# Requirements #
################
require curl     # Packaged pretty universally, pre-installed on most systems
require jq       # Usually packaged.
require websocat # Sometimes packaged.

############
# Defaults #
############
BOT_URL="https://github.com/0xfi/bashcord"
BOT_VERSION="1.0"
FIFO_PATH="/tmp/bashcord.fifo"

# Default pre_init.
#
_pre_init() {
	log event "Starting Bashcord..."
}

# Default init.
#
_init() {
    name="$(api GET /users/@me | jq .username -r)"
    if [ -z "${name}" ]; then
        fatal 1 "Cannot reach server"
    fi
    log info "Connecting as... ${name}"
}

# Setup some things and connect to the Discord API.
#
connect() {
	if echo "$(type pre_init)" | grep -q "function"; then pre_init; else _pre_init; fi
	[ -z "${API_TOKEN}" ] && error "API token not set" && exit
	API_TOKEN="$(cat token)"
	BOT_AUTH="Authorization: ${API_TOKEN}" 
	log debug "${BOT_AUTH}"
	if [ -z "${API_VERSION}" ]; then
		API="https://discordapp.com/api"
	else
		log info "Using API v${API_VERSION}"
		API="https://discordapp.com/api/v${API_VERSION}"
	fi
	BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	log debug "User-Agent: ${BOT_AGENT}"
	if type init | grep -q "function"; then init; else _init; fi
	SOCKET_URL="$(api GET /gateway | jq .url -r)"
	if [ -e "${FIFO_PATH}" ]; then log info "Stealing old FIFO"; else log info "New FIFO" && mkfifo -m 600 "${FIFO_PATH}"; fi
	while read -r response -t 1 || true; do
		if [ -z "$response" ]; then
			log error "No response"
		fi
		echo "$response"
	done <"${FIFO_PATH}" | websocat "${SOCKET_URL}" >"${FIFO_PATH}"
}

log debug "I'm retard"
