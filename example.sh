#!/bin/bash
# bot.sh - example bashcord bot

source bashcord.sh
LOG_LEVEL=$e_all
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

init() {
	_init # recommended, runs the default _init first
	log debug "Got $(api GET "/users/@me")"
	log debug "Got $(api GET "/users/200006477677723648")"
}

connect
