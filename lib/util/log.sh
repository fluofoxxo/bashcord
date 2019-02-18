#!/bin/bash
RESET="\\033[0m"
BOLD="\\033[1m"
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"

declare -A LOG_LEVELS
declare -A LOG_TAGS

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

LOG_LEVEL=all

case "$LOG_TAG_VARIANT" in
    emoji)
    LOG_TAGS=(
        [fatal]="$MAGENTA ☠ $RESET"
        [error]="$BOLD$RED ✘ $RESET"
        [warning]="$BOLD$YELLOW ⚠ $RESET"
        [success]="$BOLD$GREEN ✔ $RESET"
        [info]="$BOLD$CYAN 🛈 $RESET"
        [debug]="$BOLD$BLUE ⚙ $RESET"
        [default]="$BOLD ❔ $RESET"
    );;

    *|default)
    LOG_TAGS=(
        [fatal]="$MAGENTA[FATAL]$RESET"
        [error]="$BOLD$RED[ERROR]$RESET"
        [warning]="$BOLD$YELLOW[WARN] $RESET"
        [success]="$BOLD$GREEN[OK]   $RESET"
        [info]="$BOLD$CYAN[INFO] $RESET"
        [debug]="$BOLD$BLUE[DEBUG]$RESET"
        [default]="$BOLD$BLACK[?????]$RESET"
    );;
esac

exec 8>&2
exec 9>/dev/null

log() {
    local level="$1"

    if [ ${LOG_LEVELS[$level]-1000} -gt ${LOG_LEVELS[$LOG_LEVEL]} ]; then
        return
    fi

    local fmt="${2:-Something happened}"
    shift 2

    local tag="${LOG_TAGS[$level]}"
    if [ -z "$tag" ]; then
        local tag="${LOG_TAGS[default]}"
    fi

    printf "%s|%-10s|$fmt\n" "$(date +"%Y-%m-%d %H:%M:%S.%N")" "$level" "$@" | \
        tr -cd '[:print:]\r\n' >&9
    printf "%s %b $fmt\n" "$(date +"%Y-%m-%d %H:%M:%S.%N")" "$tag" "$@" >&8
}
