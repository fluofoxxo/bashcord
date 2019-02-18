# API docs

## Configuration Variables
**NOTE**
Configuration is automagically done via `api:init` which will generate all
the important settings through some basic information.

* `API_BASE` is the base URL for the REST API
* `API_TOKEN` is the authentication token for HTTP requests to the API
* `API_AUTH` is the generated HTTP header from the `API_TOKEN`
* `API_BOT_URL` is the user-defined URL to generate `API_AGENT`
    - Defaults to `https://github.com/0xfi/bashcord`
* `API_BOT_VER` is the user-defined version of the bot
    - Defaults to `1.0`
* `API_AGENT` is the User-Agent provided to the API

## API core functions

### `api:init`
```
$1 -> API_BASE
$2 -> API_TOKEN+
$3 -> API_BOT_URL*
$4 -> API_BOT_VER*

* Optional
```

### `api:request`
Send a request to the Discord API, `api:init` should be called first unless
you want to manually set all of the important variables... which is stupid

#### `api:get`

#### `api:delete`

#### `api:post`

#### `api:put`

#### `api:patch`
