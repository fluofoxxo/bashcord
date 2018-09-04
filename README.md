**NOTE: The following is *very* out of date**

Discord API written in Bash for the modern world

## Why?
I hate myself

## Stuff you can do
Configuration variables:
```
BOT_TOKEN    Authorization token
BOT_URL      Bot home page URL
BOT_VERSION  Bot version number
API_VERSION  Version of the API to use
```

Commands:
```
api:request  Make request to the API
api:delete   Delete something
api:get      Get something
api:patch    Patch something
api:post     Post something
api:put      Put something
api:user     Get info on a user
api:me       Get info on me

log          Log things (debug, info, warning, error, event, *)
```

## Dependencies
```
jq
bash
curl
<I need to find a websocket client>
```
