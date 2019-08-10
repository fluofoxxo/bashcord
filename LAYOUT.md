### layout

overview of how `bashcord(1)` and the programs that use it should be
structured and implemented. this is purely theoretical and is subject to
heavy modification. do *not* use this as an official standard, only as a
subject of review and development.

**program that uses bashcord:**
```bash
#!/usr/bin/env bash
source $(which bashcord)

bc["token"]="Bot ..."
bc["bot_name"]="greg"
bc["bot_version"]="1.0"~

# $1 channel
# $2 guild
# $3 sender
# $4 body
# $5 embed(?)
function on_message {
	message $2/$1 "who dare challenge me"
}

function on_connect {
	status online playing "with myself"
	message @owner "I'm online, btw"
}

start
```
