#!/usr/bin/env bash

cd $HOME/anti

install() {
		sudo apt-get update
		sudo apt-get upgrade
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl 
sudo luarocks install oauth 
sudo luarocks install redis-lua 
sudo luarocks install lua-cjson 
sudo luarocks install ansicolors 
sudo luarocks install serpent 
}


function logo_play() {
    declare -A txtlogo
    seconds="0.010"
    txtlogo[1]=" ____   _        _____"
    txtlogo[2]="|  _ ) | |      |_   _|___ ____   __  __"
    txtlogo[3]="|  _ \ | |__      | |/ .__|  _ \_|  \/  |"
    txtlogo[4]="|____/ |____|     |_|\____/\_____|_/\/\_|"
    printf "\e[32m\t"
    for i in ${!txtlogo[@]}; do
        for x in `seq 0 ${#txtlogo[$i]}`; do
            printf "${txtlogo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
    printf "\n"
	echo -e "\e[0m"
}

function BlueBerryTeam() {
	echo -e "\e[0m"
	green "     »                       We Don't Compete :)                             "
	white "     »                       We create Competition :)                             "
	red   "     »                       @BlueBerryTeam                                     "
	echo -e "\e[0m"
}

red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}
update() {
	git pull
}

if [ "$1" = "install" ]; then
	print_logo
	BlueBerryTeam
	logo_play
	install
elif [ "$1" = "update" ]; then
	logo_play
	BlueBerryTeam
	update
	exit 1
else
	BlueBerryTeam
	logo_play
	red "BlueBerry Api Bot running..."
	#sudo service redis-server restart
	lua ./bot/BlueBerry.lua
fi
