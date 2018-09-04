#!/bin/sh

log() {
	case "$1" in
		ERROR|error)
			local color=31
			;;
		WARNING|warning)
			local color=33
			;;
		INFO|info)
			local color=32
			;;
		EVENT|event)
			local color=36
			;;
		DEBUG|debug)
			local color=34
			;;
		*)
			local color=35
			;;
	esac
	echo "\033[1m$(date "+%y-%m-%d %H:%M:%S")\033[m [\033[${color};1m$1\033[m] $2"
}
alias error="log ERROR"
alias warn="log WARNING"
alias inform="log INFO"
alias debug="log DEBUG"
alias event="log EVENT"

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
		error "No method provided for API request"
		exit 1
	fi
	if [ -z "$endpoint" ]; then
		error "No endpoint provided for API request"
		exit 2
	fi
	if [ -z "$payload" ]; then
		debug "${method} to ${endpoint}"
		curl -X "$method" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${endpoint}"
	else
		debug "${method} to ${endpoint} with ${payload}"
		curl -X "$method" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${endpoint}" -d "$payload"
	fi
}

bashcord() {
	# TODO: Connect to websocket and enter event loop
	inform "Started"
}
