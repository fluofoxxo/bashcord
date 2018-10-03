#!/bin/sh
# bashcord - shell script Discord API wrapper
# despite the name, it *should* be all POSIX SH

###########
# Utility #
###########
log() {
	case "$1" in
		ERROR)
			color=31
			;;
		WARN )
			color=33
			;;
		INFO )
			color=32
			;;
		EVENT)
			color=36
			;;
		DEBUG)
			color=34
			;;
		*)
			color=35
			;;
	esac
	if [ "${COLORED_LOGGING}" = "true" ]; then
		echo "\033[1m$(date "+%y-%m-%d %H:%M:%S")\033[m \033[${color};1m$1\033[m - $2" >&2
	else
		echo "$(date "+%y-%m-%d %H:%M:%S") $1 - $2" >&2
	fi
}
alias error="log ERROR"
alias warn="log \"WARN \""
alias inform="log \"INFO \""
alias debug="log DEBUG"
alias event="log EVENT"

require() {
	if ! [ -x "$(which $1)" ]; then
		error "'$1' is required but not installed"
		exit 1
	fi
}

################
# Requirements #
###############
require curl     # Packaged pretty universally, pre-installed on most systems
require jq       # Usually packaged.
require websocat # Sometimes packaged.

#################
# Configuration #
#################
if [ -z "$API_TOKEN" ]; then
	error "API_TOKEN not set"
	exit 1	
fi

# Create Authorization header for API requests
BOT_AUTH="Authorization: ${API_TOKEN}"

# Use the default api, or force a version if asked to
if [ -z "$API_VERSION" ]; then
	inform "Using current API"
	API="https://discordapp.com/api"
else
	inform "Using API $API_VERSION"
	API="https://discordapp.com/api/v${API_VERSION}"
fi

if [ -z "$BOT_URL" ]; then
	warn "No BOT_URL specified, using 'https://github.com/0xfi/bashcord'"
	BOT_URL="https://github.com/0xfi/bashcord"
fi

if [ -z "$BOT_VERSION" ]; then
	BOT_VERSION="1.0"
fi

# Generate the User-Agent header so the API know who we are
BOT_AGENT="DiscordBot (${BOT_URL}, ${BOT_VERSION})"

#####################
# HTML API Requests #
#####################
api() {
	if [ -z "$1" ]; then
		error "No method provided for API request"
		exit 1
	fi
	if [ -z "$2" ]; then
		error "No endpoint provided for API request"
		exit 2
	fi
	# If called with data to upload, add it to the curl request with `-d`
	if [ -z "$3" ]; then
		event "${1} to ${2}"
		curl -X "$1" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${2}"
	else
		event "${1} to ${2} with ${3}"
		curl -X "$1" -s -H "$BOT_AUTH" -A "$BOT_AGENT" "${API}${2}" -d "$3"
	fi
}

bashcord() {
	# TODO: Connect to websocket and enter event loop
	inform "Started"
}
