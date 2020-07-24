declare -Ax function_usage function_description
declare token user_agent
declare api_base=https://discord.com/api/v6
declare ws_connected=false

log() { printf "\033[35m<<\033[m %b\n" "$*" >&2; }
fn() { function_usage[$1]=$2; function_description[$1]=$3; }

fn usage "%b [command]" "\
Print specific command usage if provided, otherwise print a list of\n\
commands."
usage() {
    if [ "$1" ]; then
        if [ ! -v "function_usage[$1]" ]; then
            printf "Command \033[33m$1\033[m not found\n" >&2
            return
        fi
        printf "Usage: ${function_usage[$1]}\n\n" "\033[32m$1\033[m"
        printf "${function_description[$1]}\n"
    else
        printf "Run '\033[32musage\033[m <command>' for more information about a command.\n\n"
        for function in "${!function_usage[@]}"; do
            printf "\033[36m--\033[m ${function_usage[$function]}\n" "\033[32m$function\033[m"
        done
    fi
}

fn timer "%b <start|end>" "\
Record a span of time with nanosecond accuracy. Depends on the global variable \033[33mstart\033[m\n\
Started with '\033[32mtimer\033[m start' and ended (which also prints the recorded time) with\n\
'\033[32timer\033[m end'."
declare -i start
timer() {
    [ "$1" == "start" ] && { start=$(date +%s%N); return; }
    [ "$1" == "end" ] && printf "%6.4f" $(echo $(($(date +%s%N)-$start))/1000000000 | bc -l) \
    || { log "Bad use of timer"; return 1; }
}

fn rest "[echo <payload...> |] %b <token> <user-agent> <method> <url> [selectors...]" "\
Send a request to the REST API with specified authorization token, \n\
User-Agent header, HTTP method, and endpoint."
rest() {
    # Create pipe for the response to go through
    local response=/tmp/bashcord_rest.$$.txt
    mkfifo "$response"

    # Pack options into curl arguments
    log "Sending \033[1m${3^^}\033[m request to \033[34m$4\033[m"
    local opts=("-w" "%{response_code}" "-X" "${3^^}" "-H" "Authorization: $1" \
        "-o" "$response" "-H" "Accept: application/json" "-A" "$2" "$4" "-s" )
    shift 4

    # Check if something non-interactive is sitting in stdin and if so, pass it as json data
    [ -t 0 ] && local data= || local data=$(cat)
    [ "$data" ] && opts+=("-H" "Content-Type: application/json" "-d" "$data") || \
        opts+=("-H" "Content-Length: 0")

    # Send the request, record the response code and filter the response through our JSON parser
    timer start
    response_code=$(curl "${opts[@]}") &
    cat $response | jq "${@:-.}"
    end=$(date +%s)
    log "Received response in \033[33m$(timer end)s\033[m"

    # Cleanup and return a non-zero exit code if a non-2XX response code was received
    pkill $!
    rm $response    
    [[ $response_code = 2* ]] || return 1
}

fn client "%b <token> [-h|--homepage url] [-v|--version ver] [-b|--api-base url]" "\
Configure the client (required to be run before the \033[32mapi\033[m command)."
client() {
    local homepage=https://github.com/trvv/bashcord
    local ver=1.33.7
    local -a args
    while [ "$1" ]; do
        case "$1" in
            -b|--api-base) api_base=$2; shift;;
            -h|--homepage) homepage=$2; shift;;
            -v|--version) ver=$2; shift;;
            *) args+=("$1");;
        esac; shift
    done
    user_agent="DiscordBot ($homepage, $ver)"
    token=${args[0]}
}

fn api "[echo <payload...> |] %b <method> <endpoint/opcode> [selectors...]" "\
High level API access pulling from configuration\
established by \033[32mclient\033[m."
api() {
    if [ ! "$token" ]; then
        log "\033[31mToken not set!\033[m"
        return
    fi

    if [ $# -lt 2 ]; then
        log "Need a method and target!"
        return
    fi

    local method=$1
    local endpoint=$2
    shift 2

    if [ "$method" == "send" ]; then
        $ws_connected || log "\033[31mNot connected to gateway!\033[m"
        return
    fi

    rest "$token" "$user_agent" "$method" "$api_base$endpoint"
}

cat <<EOF
$(printf "\033[34;1m") 
 ▄▄▄▄    ▄▄▄        ██████  ██░ ██  ▄████▄   ▒█████   ██▀███  ▓█████▄ 
▓█████▄ ▒████▄    ▒██    ▒ ▓██░ ██▒▒██▀ ▀█  ▒██▒  ██▒▓██ ▒ ██▒▒██▀ ██▌
▒██▒ ▄██▒██  ▀█▄  ░ ▓██▄   ▒██▀▀██░▒▓█    ▄ ▒██░  ██▒▓██ ░▄█ ▒░██   █▌
▒██░█▀  ░██▄▄▄▄██   ▒   ██▒░▓█ ░██ ▒▓▓▄ ▄██▒▒██   ██░▒██▀▀█▄  ░▓█▄   ▌
░▓█  ▀█▓ ▓█   ▓██▒▒██████▒▒░▓█▒░██▓▒ ▓███▀ ░░ ████▓▒░░██▓ ▒██▒░▒████▓ 
░▒▓███▀▒ ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░ ▒▒▓  ▒ 
▒░▒   ░   ▒   ▒▒ ░░ ░▒  ░ ░ ▒ ░▒░ ░  ░  ▒     ░ ▒ ▒░   ░▒ ░ ▒░ ░ ▒  ▒ 
 ░    ░   ░   ▒   ░  ░  ░   ░  ░░ ░░        ░ ░ ░ ▒    ░░   ░  ░ ░  ░ 
 ░            ░  ░      ░   ░  ░  ░░ ░          ░ ░     ░        ░    
      ░                            ░                           ░     $(printf "\033[m")
EOF

missing=()
for dep in jq curl websocat; do
    command -v $dep 2>&1 >/dev/null || missing+=($dep)
done

if [ "${missing[0]}" ]; then
    log "\033[31mMissing command(s): ${missing[@]}. Script will break or not work at all.\033[m"
fi

if [ "$1" ]; then
    client "$@"
else
    log "\033[31mNo arguments provided, client will need to be configured!\033[m"
fi

log "Registered \033[1m${#function_usage[@]}\033[m functions (see with \033[32musage\033[m)."

if ! ping -c 1 discord.com >/dev/null 2>&1; then
    log "\033[31mDiscord appears to be down!\033[m"
fi

while read -p "$(printf "\033[34m")>>$(printf "\033[m") "; do
    eval "$REPLY"
done
