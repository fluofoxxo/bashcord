shopt -s expand_aliases

alias module:="_doc:module \"$LINENO\""
alias method:="_doc:method \"$LINENO\""
alias global:="_doc:global \"$LINENO\""
alias alias:="_doc:alias \"$LINENO\""

declare -a MODULES
declare -a METHODS
declare -a GLOBALS
declare -a ALIASES

_doc:module() {
    MODULE=$2
    MODULES["$MODULE:line"]=$1
    MODULES["$MODULE:name"]=$2
    shift 2
    MODULES["$MODULE:desc"]=$@
}

_doc:method() {
    local METHOD="$MODULE:$2"
    METHODS["$METHOD:line"]=$(( $1 - ${MODULES[$MODULE.line]} ))
    METHODS["$METHOD:name"]=$2
    shift 2
    METHODS["$METHOD:desc"]=$@
}

_doc:global() {
    local GLOBAL="$MOUDLE:$2"
    GLOBALS["$GLOBAL:line"]=$(( $1 - ${MODULES[$MODULE.line]} ))
    GLOBALS["$GLOBAL:name"]=$2
    shift 2
    GLOBALS["$GLOBAL:desc"]=$@
}

_doc:alias() {
    local ALIAS=$2
    alias $2="$3"
    ALIASES["$2:line"]=$(( $1 - ${MODULES[$MODULE.line]} ))
    ALIASES["$2:name"]=$2
    shift 2
    ALIASES["$2:body"]=$@
}
