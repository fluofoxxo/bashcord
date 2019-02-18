@MODULE "Various REST API wrappers for common endpoints"

guilds:audit-logs:get() { api GET /guilds/${1}/audit-logs; }

channels:get() { api GET /channels/${1}; }
channels:patch() { api PATCH /channels/${1} "$@"; }
channels:delete() { api DELETE /channels/${1}; }

messages:list() { api GET /channels/${1}/messages; }
messages:post() { api POST /channels/${1}/messages "$@"; }
messages:get() { api GET /channels/${1}/messages/${2}; }
messages:patch() { api PATCH /channels/${1}/messages/${2} "$@"; }
messages:delete() { api DELETE /channels/${1}/messages/${2}; }
messages:bulk-delete() { api POST /channels/${1}/messages/bulk-delete "$@"; }

reactions:put() { api PUT /channels/${1}/messages/${2}/reactions/${3}/@me "$@"; }
reactions:delete() { api DELETE /channels/${1}/messages/${2}/reactions/${3}/@me; }
reactions:deleteuser() { api DELETE /channels/${1}/messages/${2}/reactions/${3}/${4}; }
reactions:get() { api GET /channels/${1}/messages/${2}/reactions/${3}; }
reactions:purge() { api DELETE /channels/${1}/messages/${2}/reactions; }

permissions:edit() { api PUT /channels/${1}/permissions/${2} "$@"; }

invites:get() { api GET /channels/${1}/invites; }
invites:post() { api POST /channels/${1}/invites "$@"; }

typing:post() { api POST /channels/${1}/typing "$@"; }

pins:get() { api GET /channels/${1}/pins; }
pins:put() { api PUT /channels/${1}/pins/${2} "$@"; }
pins:delete() { api DELETE /channels/${1}/pins/${2}; }

recipients:put() { api PUT /channels/${1}/recipients/${2} "$@"; }
recipients:delete() { api DELETE /channels/${1}/recipients/${1}; }

emojis:list() { api GET /guilds/${1}/emojis; }
emojis:get() { api GET /guilds/${1}/emojis/${2}; }
emojis:post() { api POST /guilds/${1}/emojis/${2} "$@"; }
emojis:patch() { api PATCH /guilds/${1}/emojis/${2} "$@"; }
emojis:delete() { api DELETE /guilds/${1}/emojis/${2}; }
