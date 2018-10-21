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
The logging function is still WIP and does not currently support writing to
a log file that can be separate from the standard output stream. Calling the
`log` function takes two parameters. The first of these parameters is the
"log level" of the script. The standard levels are `ERROR, WARNING, INFO,
DEBUG, EVENT`, however, *any* string can be passed to the log level, but it
will not have any custom properties with it.
```Debug
log error "This is an error"
log warning "This is a warning"
log info "This is information"
log event "This is an event"
log debug "This is a debug message"
log whatever "This is a random message"
```
The second argument is a
string which is used as the payload to the logging message. There are also
several aliases that make the usage of the logging functions more intuitive:
```Bash
alias error="log error"
alias warn="log warning"
alias inform="log info"
alias debug="log debug"
alias event="log event"
```

### The `api` Function
Using the `api` function is extremely simple. To make an HTTP request to an
endpoint of the Discord API. To make a request using the `api` function
there are two important parameters. First, the HTTP request method is
specified (GET, DELETE, PUT, PATCH, POST, etc.).
```Bash
api GET /users/@me
```
This function is reserved to use with HTTP requests and has no bearing on
connecting to the websocket for real-time Discord interaction.
