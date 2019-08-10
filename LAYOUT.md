### layout

overview of how `bashcord(1)` and the programs that use it should be
structured and implemented. this is purely theoretical and is subject to
heavy modification. do *not* use this as an official standard, only as a
subject of review and development.

**program that uses bashcord:**
```bash
#!/usr/bin/env bash
source $(which bashcord)

bc-config BOT_TOKEN   "..."
bc-config BOT_NAME    "greg"
bc-config BOT_VERSION "1.0"
bc-config API_VERSION "7"

# $1 channel
# $2 guild
# $3 sender
# $4 body
# $5 embed(?)

function bc-onMessage() {
	bc-message $2/$1 "who dare challenge me"
}

function bc-onConnect() {
	bc-status online playing "with myself"
	bc-message @owner "I'm online, btw"
}

bc-start
```