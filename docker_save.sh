#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "Usage: ./docker_save.sh <DOCKER_REG_DOMAIN> <DOCKER_ID_USER>"
    exit
fi

docker logout
docker login $1 -u $2

DIR=./packages
if [ ! -d "$DIR" ]
then
    mkdir $DIR
fi

for tag in $(cat docker.list); do
    f=$DIR"/"$tag".img"
    f=`echo $f | sed "s/$2\//$2_/g"`

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