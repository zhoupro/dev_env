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
    #nginx server 
    nginx_srv_conf="./data/soft_etc/common/nginx/vhost/server.conf"
    [ -f "./data/soft_etc/$1/nginx/vhost/server.conf" ] &&\
        nginx_srv_conf="./data/soft_etc/$1/nginx/vhost/server.conf"
    #nginx main 
    nginx_main_conf="./data/soft_etc/common/nginx/nginx.conf"
    [ -f "./data/soft_etc/$1/nginx/nginx.conf" ] &&\
        nginx_main_conf="./data/soft_etc/$1/nginx/nginx.conf"

    #webroot
    webroot="./soft/$1"

    #mysql data
    mysql_data="./data/soft_data/$1/mysql"

    cp ./docker-compose.tpl.yml docker-compose.yml
    # replace etc
    sed -i  "s#{WEBROOT}#$webroot#g" ./docker-compose.yml
    sed -i  "s#{NGINX_SRV_CONF}#$nginx_srv_conf#g" ./docker-compose.yml
    sed -i  "s#{NGINX_MAIN_CONF}#$nginx_main_conf#g" ./docker-compose.yml
    sed -i  "s#{MYSQL_DATA}#$mysql_data#g" ./docker-compose.yml

}

echo "enjoy the joy day"
shell=${3:-/bin/zsh}
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
        docker exec -it `docker-compose ps | grep "$2" | awk '{print $1}'`  $shell 
        ;;
    "echo")
        cat docker-compose.yml | grep wwwroot | head -n 1 | awk -F ':' {'print $1'}
        ;;
esac
