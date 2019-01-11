api:channel:get() { api:get "/channels/${1}" ${2-CHANNEL}; }
api:channel:patch() { api:patch "/channels/${1}" "${2}"; } # TODO add PUT
api:channel:delete() { api:delete "/channels/${1}"; }

api:channel:messages:get() { api:get "/channels/${1}/messages" ${2-MESSAGES}; }
api:channel:messages:post() { api:post "/channels/${1}/messages" "${1}"; }
