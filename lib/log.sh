module: log "Logging utilities and management"

RESET='\033[0m'
BOLD='\033[1m'
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

declare -A LOG_LEVELS
declare -A LOG_TAGS

global: LOG_LEVELS "Levels of importance for logged messages
|name   |level|notes             |
|-------|-----|------------------|
|none   |0    |**DO NOT USE**    |
|fatal  |100  |When exiting      |
|error  |150  |                  |
|warning|200  |                  |
|success|300  |                  |
|info   |350  |Nothing dangerous |
|debug  |400  |Debug info only   |
|all    |1000 |**DO NOT USE**    |"
LOG_LEVELS=(
    [none]=0
    [fatal]=100
    [error]=150
    [warning]=200
    [success]=300
    [info]=350
    [debug]=400
    [all]=1000
)

global: LOG_LEVEL "Maximum message level to permit
Because of how the logging system is structured the higher the level the lower
The actual importance of the message is, sorry, maybe I'll fix it someday"
LOG_LEVEL=all

GLOBAL LOG_TAGS "Tags for indicating log message importance
|name   |tag    |color      |
|-------|-------|-----------|
|fatal  |[FATAL]|magenta    |
|error  |[ERROR]|bold-red   |
|warning|[WARN] |bold-yellow|
|success|[OK]   |bold-green |
|info   |[INFO] |bold-cyan  |
|debug  |[DEBUG]|bold-blue  |
|default|[?????]|grey       |"
LOG_TAGS=(
    [fatal]="$MAGENTA[FATAL]$RESET"
    [error]="$BOLD$RED[ERROR]$RESET"
    [warning]="$BOLD$YELLOW[WARN] $RESET"
    [success]="$BOLD$GREEN[OK]   $RESET"
    [info]="$BOLD$CYAN[INFO] $RESET"
    [debug]="$BOLD$BLUE[DEBUG]$RESET"
    [default]="$BOLD$BLACK[?????]$RESET"
)

exec 8>&2
exec 9>/dev/null

alias: log log:log
method: log "Logging messages
Works like `printf(1)`, except there is a prepended argument that is the
importance of the message. This level a key from LOG_LEVELS excluding `all` and
`none` which are pseudo-levels designed to be used with LOG_LEVEL to permit all
messages or none of the messages."
log:log() {
    local level="$1"
    [ ${LOG_LEVELS[$level]:-1000} -gt ${LOG_LEVELS[$LOG_LEVEL]} ] && return
    local fmt="${2:-Something happened}"
    local tag="${LOG_TAGS[$level]}"
    [ -z "$tag" ] && tag="${LOG_TAGS[default]}"
    shift 2
    printf "%s|%-10s|$fmt\n" "$(date +"%Y-%m-%d %H:%M:%S.%N")" "$level" "$@" | \
        tr -cd '[:print:]\r\n' >&9
    printf "%s %b $fmt\n" "$(date +"%Y-%m-%d %H:%M:%S.%N")" "$tag" "$@" >&8
}

alias: die log:die
method: die "Log fatal before exiting
Works exactly like `log.log()` except that no level need be provided because it
only uses the `fatal` level.
"
log:die() {
    local fmt="${1:-A fatal error occured}"
    shift
    log fatal "$fmt" "$@"
    exit 1
}
