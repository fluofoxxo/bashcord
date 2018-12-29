e_fatal=0; e_error=1; e_warn=2; e_event=3; e_info=4; e_debug=5; e_all=6
LOG_LEVEL=${e_all}
log() {
	if [ $(eval echo "\$e_${1}") -gt ${LOG_LEVEL} ]; then return; fi
	case "${1}" in
		fatal)c="31;1";;
		error)c="31"  ;;
		warn) c="33"  ;;
		event)c="36;1";;
		info) c="32"  ;;
		debug)c="34"  ;;
	esac
	printf "%s \033[%sm%-6s\033[m %s\n" "$(date +%T)" "${c}" "${1}" "${2}" >&2
}

die() {
	log fatal "${2}"
	exit "${1}"
}

require() {
	for p in "${@}"; do
		if ! [ -x "$(which "${p}")" ]; then
			programs="${programs} ${p}"
		fi
	done
	if [ -n "${programs}" ]; then 
		log error "Requirement(s) not installed:${programs}"
	else
		log info "All requirements met"
	fi
}
