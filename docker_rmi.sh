#!/bin/bash

DIR=./packages
for tag in $(cat docker.list); do
    docker rmi $tag
done