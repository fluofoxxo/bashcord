#!/bin/bash

source "util.sh"
source "api.sh"

api:init "https://discordapp.com/api" \
         "Bot NDc1MTAyMjMyNDU1NTQ0ODM0.Dx-fhA.G478WL9Y81Ho80kdHe4JgwP5eL0" \
         "https://github.com/trvv/bashcord" "1.0"

api:me
echo "Logged in as... ${ME[username]}"
pmap ME

api:get "/users/@me/guilds"
pmap REPLY
