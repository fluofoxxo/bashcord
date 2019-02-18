@MODULE "Utilities for parsing JSON"

if echo "test string" | egrep -ao --color=never "test" >/dev/null 2>&1; then
    JSON_GREP='egrep -ao --color=never'
else
    JSON_GREP='egrep -ao'
fi

if echo "test string" | egrep -o "test" >/dev/null 2>&1; then
    JSON_ESCAPE='(\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
    JSON_CHAR='[^[:cntrl:]"\\]'
else
    JSON_GREP=json_awk_egrep
    JSON_ESCAPE='(\\\\[^u[:cntrl:]]|\\u[0-9a-fA-F]{4})'
    JSON_CHAR='[^[:cntrl:]"\\\\]'
fi
JSON_STRING="\"$CHAR*($ESCAPE$CHAR*)*\""
JSON_NUMBER='-?(0|[1-9][0-9]*)([.][0-9]*)?([eE][+-]?[0-9]*)?'
JSON_KEYWORD='null|false|true'
JSON_SPACE='[[:space:]]+'

json.awk_egrep() {
    gawk '{
        while ($0) {
            start=match($0, pattern);
            token=substr($0, start, RLENGTH);
            print token;
            $0=substr($0, start+RLENGTH);
        }
    }' pattern="$1"
}

json.tokenize() {
    $GREP "$JSON_STRING|$JSON_NUMBER|$JSON_KEYWORD|$JSON_SPACE|." | egrep -v "^$JSON_SPACE$"
}

json.parse_array() {
    local index=0
    local ar=''

    read -r token
    case "$token" in
        \]) :;;
        *)
            while :; do
                json.parse_value "$1" "$index"
                (( index++ ))
                ar="$ar""$value"

                read -r token
                case "$token" in
                    \]) break;;
                    \,) ar="$ar,";;
                    *) die "EXPECTED , or ] GOT ${token:-EOF}";;
                esac

                read -r token
            done
            ;;
    esac
    value=$(printf '[%s]' "$ar")
}

json.parse_object() {
    local key
    local obj

    read -r token
    case "$token" in
        \}) :;;
        *)
            while :; do
                case "$token" in
                    \"*\") key=$token;;
                    *) die "EXPECTED string GOT ${token:-EOF}";;
                esac
                
                read -r token
                case "$token" in
                    \:) :;;
                    *) die "EXPECTED : GOT ${token:-EOF}";;
                esac
                
                read -r token
                json.parse_value "$1" "$key"
                obj="$obj$key:$value"
                
                read -r token
                case "$token" in
                    \}) break;;
                    \,) obj="$obj,";;
                    *) die "EXPECTED , or } GOT ${token:-EOF}";;
                esac

                read -r token
            done
            ;;
    esac
}

json.parse_value() {
    local path="${1:+$1,}$2"
    case "$token" in
        \{) json.parse_object "$path";;
        \[) json.parse_array "$path";;
        ''|[!0-9]) die "EXPECTED value GOT ${token:-EOF}"
}
