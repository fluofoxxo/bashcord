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

bashCord depends on [jq](https://stedolan.github.io/jq/),
[cURL](https://curl.haxx.se/), [websocat](https://github.com/vi/websocat),
and Bash 4.2+. Hopefully over time these dependencies slowly fade away as
I'm able to rewrite them in pure Bash (less likely for cURL/websocat, more
likely for jq) but for now they allow a good enough base without feeling too
restrictive in their size/flow.