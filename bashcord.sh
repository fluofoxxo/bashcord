#!/usr/bin/env bash 
#region :: Heading
       #####                #####
      ###       #########       ###
    #################################       ///////////////////////////////////
  #####################################      _           _   _____           _
  #####################################     | |_ ___ ___| |_|     |___ ___ _| |
  #########     #########     #########     | . | .'|_ -|   |  ---| . |  _| . |
  #######         #####         #######     |___|__,|___|_|_|_____|___|_| |___|
#########         #####         #########   tom [at] trvv.me
###########     #########     ###########   https://doc.trvv.me/bashcord
#########################################
#########################################   please respect the LICENSE and stay
#########   #################   #########   kind when working  on  the project.
    ######                     ######       ///////////////////////////////////
      #########           #########
#endregion

#region :: Configuration
declare -A bashcord=( 
	[token]="$DISCORD_TOKEN"
	[logging]=false
	[logfile]="bashcord.$$.log"
	[api_base]="https://discordapp.com/api"
	[api_verion]="6"
	[agent_url]="https://github.com/trvv/bashcord"
	[agent_version]="1.33.7"
	[cdn_base]="https://cdn.discordapp.com"
	[gateway_version]="6"
	[requirements]="jq curl websocat"
	[debug]=false
)

get_configuration() {
	for key in "${!bashcord[@]}"; do
    	printf "$key=${bashcord[$key]}\n"
	done
}
#endregion

#region :: Logging
log() {
	local level=${1^^}; shift
	case "$level" in
	DEBUG) printf "[\033[35;1mDEBUG\033[m] ";;
	PANIC) printf "[\033[36;1mPANIC\033[m] ";;
	EVENT) printf "[\033[34;1mEVENT\033[m] ";;
	INFO) printf "[\033[32;1mINFO\033[m ] ";;
	WARN) printf "[\033[33;1mWARN\033[m ] ";;
	ERROR) printf "[\033[31;1mERROR\033[m] ";;
	*) printf "[\033[1m%-5s\033[m] ";;
	esac
	local fmt=${1}; shift
	printf "$fmt\n" "$@" >&2
	if ${bashcord[logging]}; then
		printf "%-5s | %s | " "$level" "$(date +%f)" "$@" >>${bashcord[logfile]}
	fi
}

debug() {
	if ${bashcord[debug]}; then
		log debug "$@"
	fi
}
#endregion

#region :: Rest API helper
get_agent() {
	echo "DiscordBot (${bashcord[agent_url]}, ${bashcord[agent_version]})"
}

strcode() {
	case $1 in
	100) echo "Continue";;
	101) echo "Switching Protocols";;
	200) echo "OK";;
	201) echo "Created";;
	202) echo "Accepted";;
	203) echo "Non-Authoritative Information";;
	204) echo "No Content";;
	205) echo "Reset Content";;
	206) echo "Partial Content";;
	300) echo "Multiple Choices";;
	301) echo "Moved Permanently";;
	302) echo "Found";;
	303) echo "See Other";;
	304) echo "Not Modified";;
	305) echo "Use Proxy";;
	306) echo "(Unused)";;
	307) echo "Temporary Redirect";;
	400) echo "Bad Request";;
	401) echo "Unauthorized";;
	402) echo "Payment Required";;
	403) echo "Forbidden";;
	404) echo "Not Found";;
	405) echo "Method Not Allowed";;
	406) echo "Not Acceptable";;
	407) echo "Proxy Authentication Required";;
	408) echo "Request Timeout";;
	409) echo "Conflict";;
	410) echo "Gone";;
	411) echo "Length Required";;
	412) echo "Precondition Failed";;
	413) echo "Request Entity Too Large";;
	414) echo "Request-URI Too Long";;
	415) echo "Unsupported Media Type";;
	416) echo "Requested Range Not Satisfiable";;
	417) echo "Expectation Failed";;
	500) echo "Internal Server Error";;
	501) echo "Not Implemented";;
	502) echo "Bad Gateway";;
	503) echo "Service Unavailable";;
	504) echo "Gateway Timeout";;
	*) echo "(Unknown)";;
	esac
}

strerr() { strcode $ERR; }

declare -xi ERR=999
api() {
	local url=${bashcord[api_base]}$2
	exec 3>&1
    declare -xi ERR="$(curl -w '%{http_code}' -o >(cat >&3) -X "$1" -s \
    	-H "Authorization: ${bashcord[token]}" -A "$(get_agent)" "$url" \
    	$([[ "$3" ]] && echo "-d \"$3\" -H 'application/json'"))"
	debug "'$1' request to '$2' responded with '$(strerr)' ($ERR)'"
	if [ $ERR -ne 200 ]; then
		return 1
	else
		return 0
	fi
}
#endregion

#region :: Rest API endpoint wrappers
avatar() { user_avatar_url_png "$(user $1 .id)" "$(user $1 .avatar)"; }

user() {
	local out=$(api GET /users/$1)
	shift
	if [[ "$1" ]]; then
		echo "$out" | jq -r "$@"
	else
		echo "$out" | jq
	fi
}

me() { user @me "$@"; }

#endregion

#region :: Message Formatting
# SECTION :: Message Formatting
mention_user() { echo "<@$1>"; }
mention_nick() { echo "<@!$1>"; }
mention_channel() { echo "<#$1>"; }
mention_role() { echo "<@&$1>"; }
mention_emoji() { echo "<:$1:$2>"; }
mention_aemoji() { echo "<a:$1:$2>"; }
#endregion

#region :: CDN Requests
cdn() { echo "${bashcord[cdn_base]}/$1"; }
emoji_url() { emoji_url_gif "$1"; }
emoji_url_png() { cdn "emojis/$1.png"; }
emoji_url_gif() { cdn "emojis/$1.gif"; }
guild_icon_url() { guild_icon_url_png "$1" "$2"; }
guild_icon_url_png() { cdn "icons/$1/$2.png"; }
guild_icon_url_jpg() { cdn "icons/$1/$2.jpg"; }
guild_icon_url_webp() { cdn "icons/$1/$2.webp"; }
guild_icon_url_gif() { cdn "icons/$1/$2.gif"; }
guild_splash_url() { guild_splash_url_png "$1" "$2"; }
guild_splash_url_png() { cdn "splashes/$1/$2.png"; }
guild_splash_url_jpg() { cdn "splashes/$1/$2.jpg"; }
guild_splash_url_webp() { cdn "splashes/$1/$2.webp"; }
guild_banner_url() { guild_banner_url_png "$1" "$2"; }
guild_banner_url_png() { cdn "banners/$1/$2.png"; }
guild_banner_url_jpg() { cdn "banners/$1/$2.jpg"; }
guild_banner_url_webp() { cdn "banners/$1/$2.webp"; }
default_user_avatar_url() { default_user_avatar_url_png "$1"; }
default_user_avatar_url_png() { cdn "embed/avatars/$1.png"; }
user_avatar_url() { user_avatar_url_png "$1" "$2"; }
user_avatar_url_png() { cdn "avatars/$1/$2.png"; }
user_avatar_url_jpg() { cdn "avatars/$1/$2.jpg"; }
user_avatar_url_webp() { cdn "avatars/$1/$2.webp"; }
user_avatar_url_gif() { cdn "avatars/$1/$2.gif"; }
application_icon_url() { application_icon_url_png "$1" "$2"; }
application_icon_url_png() { cdn "app-icons/$1/$2.png"; }
application_icon_url_jpg() { cdn "app-icons/$1/$2.jpg"; }
application_icon_url_webp() { cdn "app-icons/$1/$2.webp"; }
application_asset_url() { application_asset_url_png "$1" "$2"; }
application_asset_url_png() { cdn "app-assets/$1/$2.png"; }
application_asset_url_jpg() { cdn "app-assets/$1/$2.jpg"; }
application_asset_url_webp() { cdn "app-assets/$1/$2.webp"; }
achievment_icon_url() { achievment_icon_url_png "$1" "$2" "$3"; }
achievment_icon_url_png() { cdn "app-assets/$1/achievments/$2/icons/$3.png"; }
achievment_icon_url_jpg() { cdn "app-assets/$1/achievments/$2/icons/$3.png"; }
achievment_icon_url_webp() { cdn "app-assets/$1/achievments/$2/icons/$3.webp"; }
team_icon_url() { team_icon_url_png "$1" "$2"; }
team_icon_url_png() { cdn "team-icons/$1/$2.png"; }
team_icon_url_jpg() { cdn "team-icons/$1/$2.jpg"; }
team_icon_url_webp() { cdn "team-icons/$1/$2.webp"; }
format_image_base64() { echo "data:image/$1;base64,$2"; }
# endregion

#region :: Requirements
missing=""
for requirement in ${bashcord[requirements]}; do
	if ! command -v $requirement 2>/dev/null >&2; then
		missing="$missing$requirement "
	fi
done
if [[ "$missing" ]]; then
	log ERROR "Missing command(s): $missing"
fi
unset missing
#endregion
