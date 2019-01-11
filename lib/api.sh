api:init() {
    API_BASE="${1}"
    API_TOKEN="${2}"
    API_AUTH="Authorization: ${API_TOKEN}"
    API_BOT_URL="${3}"
    API_BOT_VER="${4}"
    API_AGENT="DiscordBot (${API_BOT_URL}, ${API_BOT_VER})"
    export API_BASE API_TOKEN API_AUTH API_BOT_URL API_BOT_VER API_AGENT
}

api:request() {
    url="${API_BASE}${2}"
    log debug "${1} ${2}"
    exec 3>&1
    err="$(curl -w '%{http_code}' -o >(cat >&3) -X "${1}" -s \
        -H "${API_AUTH}" -A "${API_AGENT}" "${API_BASE}${2}" $([ -n "${3}" ] \
        && echo "-d \"${3}\" -H \"application/json\""))"
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
    esac
    log debug "${err} (${t})"
    return ${err}
}

api:get    () { map "$(api:request GET    "${1}")"        ${2-REPLY}; }
api:delete () { map "$(api:request DELETE "${1}")"        ${2-REPLY}; }
api:post   () { map "$(api:request POST   "${1}" "${2}")" ${3-REPLY}; }
api:put    () { map "$(api:request PUT    "${1}" "${2}")" ${3-REPLY}; }
api:patch  () { map "$(api:request POST   "${1}" "${2}")" ${3-REPLY}; }

for f in endpoints/*; do source "$f"; done
