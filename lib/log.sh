alias @MODULE="log.module $LINENO $0"
alias @METHOD="log.method $LINENO"
alias @GLOBAL="log.global $LINENO"
alias @ALIAS="log.alias $LINENO"

@MODULE "Logging utilities, etc."

declare -A -g MODULES # Store module descriptions '<module>'
declare -A -g METHODS # Store method descriptions '<module>:<method>'
declare -A -g GLOBALS # Store global variable descriptions '<module>:<global>'
declare -A -g ALIASES # Store alias descriptions '<alias>'

@METHOD module "Store information about a module." DO_NOT_CALL
log.module() {
    MODULE="$(basename $2 .sh)"
    MODULES["$MODULES"]=$MODULE
    MODULES["$MODULE.line"]=$1
    MODULES["$MODULE.desc"]=$3
    shift 3
    MODULES["$MODULE.flags"]=$@
}

@METHOD module "Store information about a method." DO_NOT_CALL
log.method() {
    METHODS["$MODULE.$2"]=$2
    METHODS["$MODULE.$2.line"]=$(( $1 + 1 ))
    METHODS["$MODULE.$2.desc"]=$3
    shift 3
    METHODS["$MODULE.$2.flags"]=$@
}

@METHOD global "Store information about a global." DO_NOT_CALL
log.global() {
    GLOBALS["$MODULE.$2"]=$2
    GLOBALS["$MODULE.$2.line"]=$(( $1 + 1 ))
    GLOBALS["$MODULE.$2.desc"]=$3
    shift 3
    GLOBALS["$MODULE.$2.flags"]=$@
}

@METHOD alias "Store information about an alias." DO_NOT_CALL
log.alias() {
    eval "alias $2=\"$3\""
    ALIASES["$2"]=$2
    ALIASES["$2.line"]=$(( $1 + 1 ))
    ALIASES["$2.value"]=$3
    shift 3
    ALIASES["$2.flags"]=$@
}

@GLOBAL LOG_LEVELS "Various logging varieties to use" READ_ONLY
LOG_LEVELS=(
    [NONE]=0
    [FAILURE]=100
    [WARNING]=200
    [SUCCESS]=300
    [DEBUG]=400
    [ALL]=999
)

@GLOBAL LOG_LEVEL "Set maximum logging level"
LOG_LEVEL=DEBUG

@ALIAS log log._log
@METHOD _log "Generic logging (for printf)"
log._log() {
    exec 3>
    
    printf "%s " "$(date -Ins)" >&2 >&3
}

@METHOD failure "Log a failure"
log.failure() {
    log FAILURE "$@"
}

@METHOD warning "Log a warning"
log.warning() {
    log WARNING "$@"
}

@METHOD success "Log a success"
log.success() {
    log SUCCESS "$@"
}

@METHOD debug "Log a debug message"
log.debug() {
    log DEBUG "$@"
}
