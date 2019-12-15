<div align="center">
    <h3><img align="center" width="400px" src="docs/bashcord.png"></h3>
    <img alt="List of requirements" src="https://img.shields.io/badge/requires-curl%2C%20jq%2C%20websocat-red">
    <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/trvv/bashcord">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues-raw/trvv/bashcord?logo=github">
    <img alt="GitHub license" src="https://img.shields.io/github/license/trvv/bashcord">
    <img alt="Discord" src="https://img.shields.io/discord/601620334046740481?logo=discord&color=7289DA">
    <h6><a href="https://github.com/discordapp">@discordapp</a> in the
        shell(script)</h6>
</div>

#### setup
bashCord depends on [jq](https://stedolan.github.io/jq/),
[cURL](https://curl.haxx.se/), [websocat](https://github.com/vi/websocat),
and Bash 4.2+. Hopefully over time these dependencies slowly fade away as
I'm able to rewrite them in pure Bash (less likely for cURL/websocat, more
likely for jq) but for now they allow a good enough base without feeling too
restrictive in their size/flow.

#### usage
What an actual bashCord implementation for a bot or a bearer will look like
is to be determined, but configuration is done through the `bashcord` array
and connection will begin through the `connect` function that will most
likely end a bot's code. Otherwise it's still up for debate/discussion.

#### todo
- [x] File heading
- [x] Basic configuration structure
- [x] CDN endpoint wrapper functions
- [x] Message mention formatting helpers
- [x] Logging
- [x] Fix log formatting for file output
- [x] Dependency checking
- [x] REST API helper (`api`)
- [x] Basic REST API endpoints to test
- [ ] Move TODO to a project
- [ ] Add a wrapper for CDN endpoints to download the targeted file
- [ ] Add a wrapper to check whether a certain type exists for CDN wrappers
- [ ] Start documenting! (See `docs/`)
- [ ] Change the way requirements are done to respect configuration
- [ ] Implement all of the REST API endpoints (autogen)
- [ ] Standardized way to pull elements out of an object
- [ ] Gateway loop
- [ ] Gateway dispatch outline
