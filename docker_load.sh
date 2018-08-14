#!/bin/bash

DIR=./packages
PATTERN=$DIR"/"*.img
for f in $(ls $PATTERN); do

    if [ ! -f "$f" ]
    then
        echo "$f doesn't exist!!!"
    else
        docker load -i $f
    fi
done