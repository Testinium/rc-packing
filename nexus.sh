#!/bin/bash

DIR=./packages

if [ ! -d "$DIR" ]
then
    mkdir $DIR
fi

for url in $(cat nexus.list); do
    echo $url

    f=$DIR"/"$(echo $url | rev | cut -d/ -f1 | rev)    
    echo "filename:" $f

    if [ ! -f "$f" ]
    then
        wget -O $f $url
    else
        echo "$f exists"
    fi
done