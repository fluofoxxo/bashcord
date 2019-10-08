<div align="center">
    <img align="center" width="400px" src="docs/bashcord.png">
</div>

# contents

0. [contents](#contents)
1. [introduction](#introduction)
2. [history](#history)
3. [quickstart](#quickstart)
    1. [for scripts](#for-scripts)
    2. [for cli](#for-cli)
4. [more](#more)
5. [greetz to](#greetz-to)

# introduction

bashCord is a script written in *pure* Bash to interface with the Discord
API. Its purpose is for both use in other scripts and as a command line
interface to interact with the API (possibly as a client, but I believe that
as a client it would be terrible to use, though it could theoretically be
used to implement one).

# history

SKIP THIS SECTION IF YOU DON'T LIKE RAMBLING:

bashCord was first conceived like 2ish years ago when I was bored. For about
the first month(s) I did nothing, then sporadically for about a year I added
then deleted code with little abandon (this led to an in-joke about my
inability to finish this project which I shall cite as a major reason in my
declining mental health `\s`). Then, after another major restructuring I
started a nearly 6-month hiatus from the project which ends in this attempt.
This should be the last one, I made a logo to encourage myself and I even
sat down in a coffee shop to write this instead of my bed.

# installing

To install bashCord: clone the repository
(`https://github.com/trvv/bashcord`), run `make install` in its root. The
command `bashcord` should then be available.

# quickstart

As stated in the [introduction](#introduction), bashCord is designed as both
an API testing tool and as a "library" for writing other scripts that
interact with Discord. Therefore, there are two primary ways of using
bashCord: [for scripts](#for-scripts) and [for cli](#for-cli).

## for scripts

When writing scripts, bashCord can be sourced in two ways. One, using the
[regular install method](#installing), and one by wgetting/curling the
script into a repository with your own script. If bashCord is already
installed, it's as simple as adding

```Bash
source $(which bashcord)
```

to the top of your script. Though it's still stupid-easy to use through
wgetting/curling it into a dir, it's not recommended because it's ugly
(opinion). If you *do* want to do it, something like this would be necessary
(this might not actually work, haven't tested it, roll your own).

```Bash
if [ ! -f ./bashcord ]; then
    curl -L https://github.com/trvv/bashcord/archive/master.zip \
        >bashcord.zip
    unzip master.zip
    make -C bashcord-master
    cp bashcord-master/bashcord .
    rm -rf bashcord-master
fi
```

## for cli

To setup for the CLI, all you need is to follow the [install
guide](#installing) and run `bashcord`.

# more

This README is fairly bare, it's better that way in my opinion. If you want
more information about using bashcord, checkout [the
website](https://bashcord.trvv.me). I'm fairly active on the r/unixporn
Discord server if you want to find me and ask about the project or you
could always [email me](mailtio:tom@trvv.me).

# greetz to

- [diamondburned](https://diamondb.xyz)
- [dylan](https://github.com/dylanaraps)
- [oxy](https://oxy.moe)
- probably others...
