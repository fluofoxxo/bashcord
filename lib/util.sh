log() { printf "%s %s\n" "[${1}]" "${2}" >&2; }

map() {
    declare -g -A "${2-MAP}"
    while IFS="=" read -r key value; do
        eval "${2-MAP}[${key}]=${value}" 2>/dev/null
    done < <(echo "${1}" | jq -r "to_entries|map(\"\(.key)=\(.value)\")|.[]")
}

pmap() {
    var=$(declare -p "$1"); eval "declare -A _arr=${var#*=}"
    for k in "${!_arr[@]}"; do printf "%-15s %s\n" "$k:" "${_arr[$k]}"; done
}
