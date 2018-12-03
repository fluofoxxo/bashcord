#!/bin/bash
# bot.sh - example bashcord bot

. ../bashcord.sh
LOG_LEVEL=$e_all
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

init() {
	_init # recommended
	debug "Got $(api GET "/users/@me")"
	debug "Got $(api GET "/users/200006477677723648")"
}

log INFO "Testing!"
connect
