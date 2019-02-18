#!/bin/bash
source 'build/bashcord'

me="$(api:me)"

echo "Logging in as $(@ "${me}" .username)!"
