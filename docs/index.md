# Table of Contents

- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
  - [Dependancies](#dependancies)
  - [Setting Up](#setting-up)
- [Documentation](#documentation)
  - [Overview](#overview)
  - [Logging](#logging)
    - [Logging Streams](#logging-streams)
    - [ANSI Escape Codes](#ansi-escape-codes)
    - [`LOG_LEVELS`](#loglevels)
    - [`LOG_LEVEL`](#loglevel)
    - [`LOG_TAGS`](#logtags)
    - [`LOG_TAG_VARIANT`](#logtagvariant)
    - [`log()`](#log)
    - [`die()`](#die)
  - [JSON](#json)
  - [API](#api)
    - [REST](#rest)
      - [`API_TOKEN`](#apitoken)
      - [`API_BASE`](#apibase)
      - [`API_BOT_URL`](#apiboturl)
      - [`rest.init()`](#restinit)
    - [WebSocket](#websocket)
  - [Client](#client)
  - [Tests](#tests)

# Introduction

Bashcord was a mistake.

## Dependancies

Right now the only dependancy is [`websocat`](https://github.com/vi/websocat), but hopefully I'll be able to get rid of it at some point by directly manipulating the TCP file in `/dev` for linux machines or some similar sort of low-level system manipulation.

## Setting Up

This needs to be re-done.

# Documentation

## Overview

The source code of Bashcord is seperated into 3 parts. The first is the `util/` folder which is dedicated to utilities, duh. The second is the `api/` folder which is the "low"-level interaction with the Discord API itself. The third piece is the `client.sh` file which wraps around everything and is the part of the library that one should be interacting with most.

## Logging

### Logging Streams

Two streams are provided to regulate the logging system. `8` is colored messages and by default redirects to `stderr` (or `2`). `9` is verbose, uncolored messages that are designed for log files and is by default redirected to `/dev/null`.

### ANSI Escape Codes

These variables hold ANSI Escape code values for color in outputted text. As of now they are declared globally but if that causes problems later on I'll wrap them in an array or force them to be local variables. (Mostly used with [`LOG_TAGS`](#log-tags))

|Variable |Code|
|---------|----|
|`RESET`  |0   |
|`BOLD`   |1   |
|`BLACK`  |30  |
|`RED`    |31  |
|`GREEN`  |32  |
|`YELLOW` |33  |
|`BLUE`   |34  |
|`MAGENTA`|35  |
|`CYAN`   |36  |
|`WHITE`  |37  |

### `LOG_LEVELS`

The `LOG_LEVELS` are levels that are used for the severity of messages that are going to be logged. They range from the most severe, `fatal`, to the least severe, `debug`. This array should *not* be modified after run time. The variable [`LOG_LEVEL`](#log-level) controls the maximum severity to be logged. 

```Bash
LOG_LEVELS=(
    [none]=0
    [fatal]=100
    [error]=150
    [warning]=200
    [success]=300
    [info]=350
    [debug]=400
    [all]=999
)
```

### `LOG_LEVEL`

Controls the maximum entry of [`LOG_LEVELS`](#log-levels) to be logged.

### `LOG_TAGS`

These are the tags that are used to indicate a messages severity. As of now there are two variants of the tags that can be used, `emoji` which used symbols and emoji to demonstrate the severity, and `default` which has verbose colored messages that are (almost) identical to the level name. These variants are controlled by [`LOG_TAG_VARIANT`](#log-tag-variant). **NOTE: These do not affect the alternate logging stream's output**.

### `LOG_TAG_VARIANT`

Regulates the variant of log tags to use. If it is unset or set to an unknown value the default variant used is, rather intuitively, `default`.

### `log()`

This is the main feature of the logging utility.

```Bash
Usage:
  log <level> <format> [arguments]
```

`log` outputs into two streams, `8` and `9` which are explained [here](#logging-streams). It's usage is identical with `printf`'s (the CLI invocation at least), except for the fact that the format string is the second argument and the first is instead the severity level (in string form) that the message should be logged at. If an unknown level string is provided the `unknown` tag will be used to indicate the message and won't be logged unless the [`LOG_LEVEL`](#log-level) is set to `all`.

### `die()`

Works like log except the level is always `fatal` and the first argument is
an exit code, not a level.

## JSON

This maps JSON strings into bash associative arrays. It's heavily based off of [JSON.sh](https://github.com/dominictarr/JSON.sh). This section is still a WIP.

## API

The Discord API is kind of ridiculous. It's seperated into two pieces, a RESTful API that is how the user sends actions to the API. And a WebSocket that receives events and updates from the API. (There are exceptions to both of these rules, like I said, it's kind of ridiculous). Because of this the Bashcord API section is divided into `rest.sh` and `socket.sh` which handle the REST API and the WebSocket API respectively. `endpoints.sh` is used to handle the specific REST endpoints and `event.sh` is used to handle the specific WebSocket events. (Though these aren't implemented yet, at least well).

### REST

#### `API_TOKEN`

This is the access token that is used to authenticate with the Discord API. *Never* save this to a file that is saved in your repo. You can `.gitignore` the file you place the key in, but I would recommend just setting it as an environment variable when you run your bot and never actually saving it to your system for the most safety.

#### `API_BASE`

This is the URL that is used as the base of the REST API calls. (Set in [`rest.init()`](#restinit)). Defaults to `https://discordapp.com/api`.

#### `API_BOT_URL`

TODO

#### `rest.init()`

TODO

### WebSocket

TOOD

## Client

TODO

## Tests

TODO
