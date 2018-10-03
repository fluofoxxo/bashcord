#!/bin/sh
# bashcord - shell script Discord API wrapper
# despite the name, it *should* be all POSIX SH except for the usage of read

###########
# Utility #
###########
log() {
	if [ "${ENABLE_DEBUG}" = "true" ] || [ "${1}" = "DEBUG" ]; then return; fi
	case "${1}" in
		ERROR)
			color=31;;
		WARN )
			color=33;;
		INFO )
			color=32;;
		EVENT)
			color=36;;
		DEBUG)
			color=34;;
		*)
			color=35;;
	esac
	if [ "${COLORED_LOGGING}" = "true" ]; then
		echo "\033[1m$(date "+%y-%m-%d %H:%M:%S") \033[m\
\033[${color};1m${1}\033[m - ${2}" >&2
	else
		echo "$(date "+%y-%m-%d %H:%M:%S") ${1} - ${2}" >&2
	fi
}
alias error="log ERROR"
alias warn="log \"WARN \""
alias inform="log \"INFO \""
alias debug="log DEBUG"
alias event="log EVENT"

require() {
	if ! [ -x "$(which "${1}")" ]; then
		error "'${1}' is required but not installed"
		exit 1
	fi
}

api() {
	# TODO: Implement caching
	[ -z "${1}" ]         && error "No method for request"      && exit 1
	[ -z "${2}" ]         && error "No endpoint for request"    && exit 2
	[ -z "${BOT_AUTH}" ]  && error "Authorization not defined"  && exit 3
	[ -z "${BOT_AGENT}" ] && error "Bot User-Agent not defined" && exit 4
	event "${1} to ${2} $([ -n "${3}" ] && echo "with ${3}")"
	curl -X "${1}" -s -H "${BOT_AUTH}" -A "${BOT_AGENT}" "${API}${2}" $([ -n "${3}" ] && echo "-d ${3}")
	[ $? -eq 0 ] || error "Request failed" 
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

# Default post_init.
#
_post_init() {
	inform "Connecting as... $(api GET /users/@me | jq .username -r)"
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
		inform "Using default API version"
		API="https://discordapp.com/api"
	else
		inform "Using API v${API_VERSION}"
		API="https://discordapp.com/api/v${API_VERSION}"
	fi
	BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"
	debug "User-Agent: ${BOT_AGENT}"
	SOCKET_URL="$(api GET /gateway | jq .url -r)"
	A
	if echo "$(type post_init)" | grep -q "function"; then post_init; else _post_init; fi
	
	if ! [ -f "${FIFO_PATH}" ]; then mkfifo -m 600 "${FIFO_PATH}"; fi
	while read -r response || true; do
		# TODO: Figure out how to see if the program times out
	done <"${FIFO_PATH}" | websocat "${SOCKET_URL}" >"${FIFO_PATH}"
}
