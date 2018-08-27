#!/usr/bin/env bash

# define import things
export BOT_TOKEN="NDc1MTAyMjMyNDU1NTQ0ODM0.DmTqYA.d01YDkqedB5_zwK1UkC5GWS4U_A"
export BOT_URL="https://github.com/bmofa/bashcord"

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
