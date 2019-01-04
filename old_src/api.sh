api() {
	log debug "${1} ${2} $([ -n "${3}" ] && echo "(${3})")"
	curl -X "${1}" -H "${CLIENT_AUTH}" -A "${CLIENT_AGENT}" \
		"${CLIENT_BASE}${2}" ${@}
	[ $? -eq 0 ] || log error "${1} request failed" 
}

api:get() {
	reply=$(api GET "${1}")
	if [ -n "${2}" ]; then
		echo "$(echo "${reply}" | jq ${2})"
	else
		echo "${reply}"
	fi
}

api:user() {
	api:get "/users/${1}" $@
}

api:me() {
	api:user @me
}
