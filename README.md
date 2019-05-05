# bashcord

***right now this is abandoned, sorry... I'm having some serious difficulty
putting together any motivation to work on something as hideous as the
Discord API and I genuinely dislike the direction this project was going in,
so yeah. Sorry to any people that wanted me to finish it, if anyone actually
decides to help and contribute I might put some effort in but for now it's
done.***

## Functions

### `configure()`

Configure internal Discord things

### `connect()`

Connect to the Discord API and begin handling events.

|Exit|Reason                                 |
|----|---------------------------------------|
|0   |Succesful connection.                  |
|1   |Failed connection.                     |
|2   |Succesful connection eventually failed.|

