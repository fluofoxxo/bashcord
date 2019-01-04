api:user() {
    api:get /users/${1} ${2-USER}
}

api:me() {
    api:get /users/@me ${1-ME}
}
