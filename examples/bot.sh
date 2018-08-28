#!/usr/bin/env bash

# make sure that you create a token file that contains the token string for the bot

# define import things
export BOT_TOKEN="$(cat $(dirname $0)/token)"

# source it (after defining token... etc...)
source $HOME/w/bashcord/bashcord.bash

# TODO: do stuff...
log whatever "whatever message"
log debug "debug message"
log info "info message"
log warning "warning message"
log error "error message"
log event "event message"
echo ""
api:me | jq
api:user "200006477677723648" | jq
