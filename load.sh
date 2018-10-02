#!/bin/bash
# dev env tools

# load.sh start laravel
# load.sh stop  laravel
# load.sh exec  php
function config() {
    mkdir -p ./data/soft_etc/$1
    mkdir -p ./soft/$1
    mkdir -p ./data/soft_data/$1

    [ -f ./docker-compose.yml ] && rm docker-compose.yml
    #nginx conf
    nginx_conf="./data/soft_etc/common/nginx/default.conf"
    [ -f "./data/soft_etc/$1/nginx/default.conf" ] &&\
        nginx_conf="./data/soft_etc/$1/nginx/default.conf"

    #webroot
    webroot="./soft/$1"

    #mysql data
    mysql_data="./data/soft_data/$1/mysql"

    cp ./docker-compose.tpl.yml docker-compose.yml
    # replace etc
    sed -i "" "s#{WEBROOT}#$webroot#g" ./docker-compose.yml
    sed -i "" "s#{NGINX_CONF}#$nginx_conf#g" ./docker-compose.yml
    sed -i "" "s#{MYSQL_DATA}#$mysql_data#g" ./docker-compose.yml

}

echo "enjoy the joy day"
case "$1" in
    "config" )
        config "$2"
        ;;
    "up")
        docker-compose up -d
        ;;
    "down")
        docker-compose down
        ;;
    "ex")
        docker exec -it `docker-compose ps | grep "$2" | awk '{print $1}'` /bin/zsh
        ;;
    "echo")
        cat docker-compose.yml | grep wwwroot | head -n 1 | awk -F ':' {'print $1'}
        ;;
esac
