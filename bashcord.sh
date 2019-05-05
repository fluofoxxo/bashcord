#!/usr/bin/env bash
# bashcord - discord API wrapper in bash

declare BASHCORD_BOT_URL BASHCORD_BOT_VERSION BASCHORD_BOT_TOKEN \
	BASHCORD_API_URL BASHCORD_API_VERSION BASHCORD_API_SOCKET

connect() {
	
}

rest() {
	if [[ "$3" ]]; then
		: # TODO
		return
	fi
	curl $2 -X $1 -H "Authorization: $BASHCORD_BOT_TOKEN" \
		-A "DiscordBot ($BASHCORD_BOT_URL, $BASCHORD_BOT_VERSION)"
}

