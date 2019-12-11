#!/usr/bin/env bash 

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

# SECTION :: Core Configuration
declare -A bashcord=( 
	[token]="$DISCORD_TOKEN"
	[logfile]="bashcord.$$.log"
	[api_base]="https://discordapp.com/api"
	[api_verion]="6"
	[agent_url]="https://github.com/trvv/bashcord"
	[agent_version]="1.33.7"
	[cdn_base]="https://cdn.discordapp.com"
	[gateway_version]="6"
	[requirements]="jq curl websocat"
)

# SECTION :: Logging
log() {
	local level=${1^^}; shift
	case "$level" in
	INFO) printf "\033[34;1mINFO\033[m  | ";;
	WARNING) printf "\033[33;1mWARN\033[m  | ";;
	ERROR) printf "\033[31;1mERROR\033[m | ";;
	*) printf "\033[1m%-5s\033[m | ";;
	esac
	printf "%-5s | " "$level" >>"${bashcord[logfile]}"
	printf "%s | " "$(date +%f)" | tee -a "${bashcord[logfile]}"
	printf "$@" | tee -a "${bashcord[logfile]}"
}

# SECTION :: Requirements
missing=()
for requirement in ${bashcord[requirements]}; do
	if ! command -v $requirement 2>/dev/null >&2; then
		missing+=($requirement)
	fi
done
unset missing

# SECTION :: Message Formatting
mention_user() { echo "<@$1>"; }
mention_nick() { echo "<@!$1>"; }
mention_channel() { echo "<#$1>"; }
mention_role() { echo "<@&$1>"; }
mention_emoji() { echo "<:$1:$2>"; }
mention_aemoji() { echo "<a:$1:$2>"; }

# SECTION :: CDN Requests
cdn() { echo "${bashcord[cdn_base]}/$1"; }
emoji_url() { emoji_url_gif "$1"; }
emoji_url_png() { cdn "emojis/$1.png"; }
emoji_url_gif() { cdn "emojis/$1.gif"; }
guild_icon_url() { guild_icon_url_gif "$1" "$2"; }
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
user_avatar_url() { user_avatar_url_gif "$1" "$2"; }
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

# SECTION :: Image Formatting
format_image_data() { echo "data:image/$1;base64,$2"; }
