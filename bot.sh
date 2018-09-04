#!/bin/sh
# bot.sh - example bashcord bot

# API_VERSION="7"
BOT_URL="https://discordapp.com/developers"
API_TOKEN="$(cat token)"
BOT_VERSION="2.1"

. ./bashcord.bash

api GET "/users/@me"
echo ""