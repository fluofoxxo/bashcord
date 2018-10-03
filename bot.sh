#!/bin/sh
# bot.sh - example bashcord bot

# API_VERSION="7"
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

. ./bashcord.sh

api GET "/users/@me"
echo ""
api GET "/users/200006477677723648"
echo ""