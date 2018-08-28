#!/bin/bash

PATH="$(dirname $0)/bin:${PATH}"

log() {
	local level="${1^^}"
	local format="$2"
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
		printf "\033[1m$(date -Iseconds)\033[m [\033[${color};1m$level\033[m] $format\n" $@ >&2	
}

if [ -z "$BOT_URL" ]; then
	log warning "no bot URL specified... using fallback"
	BOT_URL="https://github.com/bmofa/bashcord"
fi

if [ -z "$BOT_VERSION" ]; then
	BOT_VERSION="1.0"
fi

BOT_AGENT="DiscordBot ($BOT_URL, $BOT_VERSION)"
# Do *not* force this ^

if [ -z "$BOT_TOKEN" ]; then
	log error "Discord token not set"
	exit 1
fi

BOT_AUTH="Authorization: Bot ${BOT_TOKEN}"

if [ -z "$API_VERSION" ]; then
	API="https://discordapp.com/api"
else
	# NOTE: forcing the API version may have unintended consequences
	export API="https://discordapp.com/api/v${API_VERSION}"
fi

api:request() {
	endpoint="${API}$1"
	shift
	log info "requesting $endpoint"
	curl -s -H "$BOT_AUTH" -A "$BOT_AGENT" "$endpoint" $@	
}

api:delete() {
	if [ -z "$1" ]; then
		log error "(api:delete) no endpoint"
		return
	fi
	api:request "$1" -X DELETE
}

api:get() {
	if [ -z "$1" ]; then
		log error "(api:get) no endpoint"
		return
	fi
	api:request "$1"
}

api:patch() {
	if [ -z "$1" ]; then
		log error "(api:patch) no endpoint"
		return
	else
		if [ -z "$2" ]; then
			log warning "(api:patch) no data"
		fi
	fi
	api:request "$1" -X PATCH -d "$2"
}

api:post() {
	if [ -z "$1" ]; then
		log error "(api:post) no endpoint"
		return
	else
		if [ -z "$2" ]; then
			log warning "(api:post) no data"
		fi
	fi
	api:request "$1" -X POST -d "$2"
}

api:put() {
	if [ -z "$1" ]; then
		log error "(api:put) no endpoint"
		return
	else
		if [ -z "$2" ]; then
			log warning "(api:put) no data"
		fi
	fi
	api:request "$1" -X PUT -d "$2"
}

api:user() {
	api:get "/users/$1"
}

api:me() {
	api:user "@me"
}


# Set up the websocket connection
BOT_GATEWAY=$(api:get /gateway/bot | jq .url)

