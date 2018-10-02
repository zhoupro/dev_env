#!/bin/bash
# dev env tools

# load.sh start laravel
# load.sh stop  laravel
# load.sh exec  php
function config() {
    #nginx conf
    nginx_conf="./data/soft_etc/common/nginx/default.conf"
    [ -f "./data/soft_etc/$1/nginx/default.conf" ] &&\
        nginx_conf="./data/soft_etc/$1/nginx/default.conf"

    #webroot
    webroot="./soft/common"
    [ -d "./soft/$1" ] &&\
        webroot="./soft/$1"

    #mysql data
    mysql_data="./data/soft_data/common/mysql"
    [ -d "./data/soft_data/$1/mysql" ] &&\
        mysql_data="./data/soft_data/$1/mysql"

    [ ! -d "$webroot" ] &&  mkdir -p  "$webroot"
    [ ! -d "$mysql_data" ] && mkdir -p  "$mysql_data"
    [ -f ./docker-compose.yml ] && rm docker-compose.yml
    cp ./docker-compose.tpl.yml docker-compose.yml
    # replace etc
    sed -i "s#{WEBROOT}#$webroot#g" ./docker-compose.yml
    sed -i "s#{NGINX_CONF}#$nginx_conf#g" ./docker-compose.yml
    sed -i "s#{MYSQL_DATA}#$mysql_data#g" ./docker-compose.yml

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
    "exec")
        echo "exec"
        ;;
esac
