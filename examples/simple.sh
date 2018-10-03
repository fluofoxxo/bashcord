#!/bin/sh
# bot.sh - example bashcord bot

# API_VERSION="7"
COLORED_LOGGING="true"
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

. ../bashcord.sh

debug "Got $(api GET "/users/@me")"
debug "Got $(api GET "/users/200006477677723648")"
