**NOTE: This is *far* from being even remotely done, so don't expect much as of now. Also, the documentation is extremely out of date so there's that too**

## bashcord
*Discord API wrapper for Bash with minimal dependencies*
## Structure of a bashcord Bot
The general flow of a bashcord application is as follows:
- Define [configuration](#configuration) variables
- Define potential helper functions
- Source `bashcord.sh`
- Collect and [log](#logging) values you care about from the API
- Define the websocket event functions (**NOTE:** This is still not done)
- Start the bot by calling `bashcord`

## Configuration
As of now, there are four important configuration variables that are used
by bashcord. The proper placement for defining these values is setting them
before `bashcord.sh` is sourced.
```Bash
# define values here...
API_TOKEN="$(cat ./token)"
# etc.
# *now* source the bash file
. ./bashcord.sh
```
`API_TOKEN` is the Bot token provided by Discord used as the authorization
token for the Discord API. **NOTE:** The standard syntax for connecting to
the API as a bot *requires* there to be `Bot ` to be prefixed to the token
that is used. This is *not* done automatically by bashcord and is to be done
by the user.

`API_VERSION` is the specific version of the Discord API to contact. If no
value is specifically defined it will automatically use the latest stable
version that Discord provides.

`BOT_URL` is the URL that is provided with the User-Agent and is the
"homepage" of the bot.

`BOT_VERSION` is the "release" version of the bot that is being used.

## Usage
### Logging
This is currently heavily WIP, don't expect stable documentation for a long
while.
```Debug
log fatal "This is a fatal error message"
log error "This is an error"
log warning "This is a warning"
log debug "This is a debug message"
```
The second argument is a string which is used as the payload to the logging message.

### `rest`