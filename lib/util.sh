log() {
    echo "[$1] ${2}" >&2
}

map() {
    declare -g -A ${2-MAP}
    while IFS="=" read -r key value; do
        eval "${2-MAP}[${key}]"="${value}"
    done < <(echo "${1}" | jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]")
}
