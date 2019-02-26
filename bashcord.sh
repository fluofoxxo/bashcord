#!/bin/false

##############
##  Config  ##
##############

BASHCORD_BASE="https://discordapp.com/api"
BASHCORD_AGENT="DiscordBot  \
(${BASHCORD_AGENT_URL:=https://github.com/trvv/bashcord}, \
 ${BASHCORD_AGENT_VERSION:=1.0}})"
BASHCORD="${BASCORD_PATH:=/tmp/bashcord}"
BASHCORD_DEBUG="${BASHCORD_DEBUG:=false}"

############
##  Util  ##
############

debug() { ${BASHCORD_DEBUG} && echo "${1}" >&2; }
die() { echo "${1}" >&2; exit ${2:-1}; }
vw() { echo "${2}" >"${BASHCORD}/store/${1}"; }
vr() { echo "${BASHCORD}/store/${1}"; }

###########
##  API  ##
###########

api.init() {
    debug ":: Initializing"
    if [ -z "${API_TOKEN}" ]; then
        die "BASHCORD_TOKEN not set"
    fi
 
    rm -rf "${BASHCORD}"
    mkdir -p "${BASHCORD}/store"
 
    vw gateway "$(r GET /gateway | jq .url -r)"
    mkfifo -m 600 "${BASHCORD}/ws.input"
    mkfifo -m 600 "${BASHCORD}/ws.output"
}

api.connect() {
    debug ":: Connecting"
    api.init
    websocat "$(vr gateway)" <"${BASHCORD}/ws.input" >"${BASHCORD}/ws.output" &
    api.receiver &
}

api.receiver() {
    while :; do
        while read -r payload; do
            local op="$(echo "${payload}" | jq .op)"
            local data="$(echo "${payload}" | jq .d)"
            case "$op" in
                 0) api.dispatch;;
                 1) api.heartbeat;;
                 7) api.connect;;
                 9) die "Invalid session";;
                10) api.hello;;
                11) api.ack;;
                *) die "Invalid opcode ($op)";;
            esac
        done <"${BASHCORD}/ws.input"
    done
}

api.request() {
    local url="${BASHCORD_BASE}${2}"
    exec 3>&1
    local err="$(curl -w '%{http_code}' -o >(cat >&3) -X "${1}" -s \
    -H "Authorization: ${BASHCORD_TOKEN}" -A "${BASHCORD_AGENT}" "$url" \
    $([ -n "${3}" ] && echo "-d \"${3}\" -H \"application/json\""))"
    case "${err}" in
        200) t="OK";;
        201) t="CREATED";;
        204) t="NO CONTENT";;
        304) t="NOT MODIFIED";;
        400) t="BAD REQUEST";;
        401) t="UNAUTHORIZED";;
        403) t="FORBIDDEN";;
        404) t="NOT FOUND";;
        405) t="METHOD NOT ALOWED";;
        429) t="TOO MANY REQUESTS";;
        502) t="GATEWAY UNAVAILABLE";;
        5*)  t="SERVER ERROR";;
        *)   t="UNKNOWN STATUS CODE";;
    esac
    debug "${1} ${2} -> ${err} (${t})"
    vw rest.status.code "${err}"
    vw rest.status.message "${t}"
    case "${err}" in
        2*) return 0;;
        *) return 1;;
    esac
}
r() { api_request "${@}"; }

##############
##  Client  ##
##############

start.client() {
    api.connect
    if [ ${?} -ne 0 ]; then
        die "Something went wrong"
    else
        echo "Bashcord started!"
    fi
}
