#!/bin/bash

source "util.sh"
source "api.sh"
source "socket.sh"
source "events.sh"
source "client.sh"

api:init "https://discordapp.com/api" "Bot $(cat ../token)" \
    "DiscordBot (https://google.com, 1.0)"

api:get /users/@me ME
for i in "${!ME[@]}"; do
    echo "'$i'='${ME[$i]}'"
done
