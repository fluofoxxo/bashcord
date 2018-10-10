#!/bin/bash
# bashcord - shell script Discord API wrapper
# despite the name, it *should* be all POSIX SH except for the usage of read

###########
# Utility #
###########
log() {
	if [ "${ENABLE_DEBUG}" = "true" ] || [ "${1}" = "DEBUG" ]; then return; fi
	case "${1}" in
		ERROR*)
			color="31";;
		FATAL*)
		    color="31;1";;
		WARN*)
			color=33;;
		INFO*)
			color=32;;
		EVENT*)
			color="36;1";;
		DEBUG*)
			color=34;;
		*)
			color=35;;
	esac
	if [ "${COLORED_LOGGING}" = "true" ]; then
		printf "\033[1m%s\033[m \033[%sm%s\033[m %s\n" \
"$(date "+%y-%m-%d %H:%M:%S")" "${color}" "${1}" "${2}">&2
	else
		printf "$(date "+%y-%m-%d %H:%M:%S") ${1} - ${2}\n" >&2
	fi
}
error()  { log ERROR "$@"; }
warn()   { log "WARN" "$@"; }
inform() { log "INFO" "$@"; }
debug()  { log DEBUG "$@"; }
event()  { log EVENT "$@"; }
fatal()  {
    code="$1"
    shift
    log FATAL "$@"
    exit ${code}
}

require() {
	if ! [ -x "$(which "${1}")" ]; then
		error "'${1}' is required but not installed"
		exit 1
	fi
}

# NOTE: predefined some variables so bash doesn't get grumpy
BOT_AUTH=""
BOT_AGENT=""
API=""
api() {
	# TODO: Implement caching
	[ -z "${1}" ]         && error "No method for request"      && exit 1
	[ -z "${2}" ]         && error "No endpoint for request"    && exit 2
	[ -z "${BOT_AUTH}" ]  && error "Authorization not defined"  && exit 3
	[ -z "${BOT_AGENT}" ] && error "Bot User-Agent not defined" && exit 4
	debug "${1} to ${2} $([ -n "${3}" ] && echo "with ${3}")"
	curl -X "${1}" -s -H "${BOT_AUTH}" -A "${BOT_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}")
	[ $? -eq 0 ] || error "${1} Request to '${2}' failed" 
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
	event "Starting Bashcord..."
}

pre_init() {
	sleep 1
}

# Default init.
#
_init() {
    name="$(api GET /users/@me | jq .username -r)"
    if [ -z "${name}" ]; then
        fatal 1 "Cannot reach server"
    fi
    inform "Connecting as... ${name}"
}

init() {
	sleep 1
}

# Setup some things and connect to the Discord API.
#
connect() {
	if echo "$(type pre_init)" | grep -q "function"; then pre_init; else _pre_init; fi
	[ -z "${API_TOKEN}" ] && error "API token not set" && exit
	API_TOKEN="$(cat token)"
	BOT_AUTH="Authorization: ${API_TOKEN}" 
	debug "${BOT_AUTH}"
	if [ -z "${API_VERSION}" ]; then
		API="https://discordapp.com/api"
	else
		inform "Using API v${API_VERSION}"
		API="https://discordapp.com/api/v${API_VERSION}"
	fi
	BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	debug "User-Agent: ${BOT_AGENT}"
	if type init | grep -q "function"; then init; else _init; fi
	SOCKET_URL="$(api GET /gateway | jq .url -r)"
	timeout=1
	if [ -e "${FIFO_PATH}" ]; then inform "Stealing old FIFO"; else inform "New FIFO" && mkfifo -m 600 "${FIFO_PATH}"; fi
	export BASHCORD_RESPONSE
	while {
		read -r BASHCORD_RESPONSE &
		sleep $timeout
		pkill $!	
	} || true; do
		response="${BASHCORD_RESPONSE}"
		if [ -z "$response" ]; then
			error "No response"
		fi
		echo "$response"
	done <"${FIFO_PATH}" | echo "websocat \"${SOCKET_URL}\"" >"${FIFO_PATH}"
}
