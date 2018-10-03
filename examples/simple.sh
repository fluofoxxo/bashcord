#!/bin/sh
# bot.sh - example bashcord bot

. ../bashcord.sh
COLORED_LOGGING="true"
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

post_init() {
	_post_init # recommended
	debug "Got $(api GET "/users/@me")"
	debug "Got $(api GET "/users/200006477677723648")"
}

connect
