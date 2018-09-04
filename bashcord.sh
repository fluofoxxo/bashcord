#!/bin/sh

log() {
	local level
	level="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
	local message="$2"
	case "$level" in
		ERROR)
			local color=31
			;;
		WARNING)
			local color=33
			;;
		INFO)
			local color=32
			;;
		DEBUG)
			local color=34
			;;
		EVENT)
			local color=36
			;;
		*)
			local color=35
			;;
		esac
		shift
		echo "\033[1m$(date -Iseconds)\033[m [\033[${color};1m$level\033[m] $message"
}

alias error="log error"
alias warn="log warning"
alias inform="log info"
alias debug="log debug"
alias event="log event"
if [ -z "$API_TOKEN" ]; then
	error "API_TOKEN not set"
	exit 1	
fi

BOT_AUTH="Authorization: ${API_TOKEN}"

if [ -z "$API_VERSION" ]; then
	inform "Using current API"
	API="https://discordapp.com/api"
else
	inform "Using API $API_VERSION"
	API="https://discordapp.com/api/v${API_VERSION}"
fi

if [ -z "$BOT_URL" ]; then
	warn "No BOT_URL specified, using 'https://github.com/bmofa/bashcord'"
	BOT_URL="https://github.com/bmofa/bashcord"
fi

if [ -z "$BOT_VERSION" ]; then
	BOT_VERSION="1.0"
fi

BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"

api() {
	# TODO: Assume GET request with $1 when only one argument is provided
	method="$1"
	endpoint="$2"
	payload="$3"
	if [ -z "$method" ]; then
		log error "No method provided for API request"
		exit 1
	fi
	if [ -z "$endpoint" ]; then
		log error "No endpoint provided for API request"
		exit 2
	fi
	if [ -z "$payload" ]; then
		inform "${method} to ${endpoint}"
		curl -X "$method" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${endpoint}"
	else
		inform "${method} to ${endpoint} with ${payload}"
		curl -X "$method" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${endpoint}" -d "$payload"
	fi
}

bashcord() {
	# TODO: Connect to websocket and enter event loop
	inform "Started"
}
