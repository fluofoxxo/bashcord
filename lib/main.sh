#!/bin/bash

source "bashcord.sh"

api:init "https://discordapp.com/api" "Bot $(cat ../token)" \
    "DiscordBot (https://google.com, 1.0)"
