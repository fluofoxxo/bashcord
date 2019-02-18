rest.init() {
    if [ -z "${API_TOKEN}" ]; then
        log fatal "API_TOKEN not set"
        exit 1
    fi
    API_BASE="${1:-https://discordapp.com/api}"
    API_AGENT= \
"DiscordBot (${API_BOT_URL:-github.com/trvv/bashcord}, ${API_BOT_VER:-1.0})"
    export API_BASE API_TOKEN API_BOT_URL API_BOT_VER API_AGENT
}

rest() {
    url="${API_BASE}${2}"
    log debug "${1} ${2}"
    exec 3>&1
    err="$(curl -w '%{http_code}' -o >(cat >&3) -X "${1}" -s \
    -H "Authorization: ${API_TOKEN}" -A "${API_AGENT}" "${API_BASE}${2}" \
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
    log debug "${err} (${t})"
    return ${err}
}
