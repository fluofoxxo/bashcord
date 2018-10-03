#!/bin/sh
# bot.sh - example bashcord bot

# API_VERSION="7"
COLOR_LOGGING="true"
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

. ../bashcord.sh

# simple API tests to make sure the connection is valid
debug "Using token \"$API_TOKEN\""
inform "$(api GET "/users/@me")"
inform "$(api GET "/users/200006477677723648")"
connect
