#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "Usage: ./docker_save.sh <DOCKER_REG_DOMAIN> <DOCKER_ID_USER>"
    exit
fi

docker logout
# export DOCKER_ID_USER="dckrer"
# export DOCKER_REG_DOMAIN=https://index.docker.io/v1/
# docker login $DOCKER_REG_DOMAIN -u $DOCKER_ID_USER
docker login $1 -u $2

DIR=./packages
if [ ! -d "$DIR" ]
then
    mkdir $DIR
fi

for tag in $(cat docker.list); do
    f=$DIR"/"$tag".img"
    if [ ! -f "$f" ]
    then
        echo "$f creating..."
        docker pull $tag
        docker save -o $f $tag
        echo "-------------------------------------------"
    else
        echo "$f has been already downloaded..."
    fi
done

docker logout