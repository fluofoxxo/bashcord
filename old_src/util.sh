log() {
	! $LOG_DEBUG && [ "$1" == "debug" ] && return
	local fatal=35
	local error=31
	local warn=33
	local debug=34
	color=$(eval echo "\$$1")
	printf "%s \033[%s;1m%-6s\033[m %s\n" "$(date +%T)" "$color" "$1" "$2" >&2
}

die() {
	log fatal "${2}"
	exit "${1}"
}

state() {
	case "$1" in
		set) [ -e "$2" ] || mkfifo -m 600 "$2" && echo "$3" >"$2";;
		get) cat "$2";;
	esac
}
