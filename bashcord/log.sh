#!/bin/bash
BOLD="\033[1m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
RESET="\033[m"

LOG_LEVELS=(
    [none]=0
    [failure]=100
    [warning]=200
    [success]=300
    [debug]=400
    [all]=999
)

LOG_TAGS=(
    [failure]="$BOLD$RED✘"
    [warning]="$BOLD$YELLOW⚠"
    [success]="$BOLD$GREEN✔"
    [debug]="$BOLD➡"
    [default]="➡"
)

LOG_LEVEL=all

exec 3>/dev/null

log() {
    local level="$1"
    local fmt="${2:-Something happened}"
    shift 2

    printf "%s | %-7s | $fmt\n" "$(date +%Y%m%d%H%M.%S)" "$level" "$@" | tr -cd '[:print:]\r\n' >&3
    printf "%s %b  $fmt\n" "$(date +%Y%m%d%H%M.%S)" "${LOG_TAGS[$level]:+LOG_TAGS[default]}$RESET" "$@" >&2
}
