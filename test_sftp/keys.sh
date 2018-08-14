#!/bin/bash

if [ ! -d ssh ]
then
    mkdir -p ssh
    chmod 700 ssh
fi

if [ ! -d data ]
then
    mkdir -p data
fi

rm -rf ssh/id_rsa*
ssh-keygen  -N "" -q -f ssh/id_rsa
chmod 700 ssh/id_rsa

rm -rf ssh/ssh_host*

ssh-keygen -t ed25519 -o -a 100 -N "" -q -f ssh/ssh_host_ed25519_key < /dev/null
echo "ssh_host_ed25519_key was created!"

ssh-keygen -t rsa -b 4096 -o -a 100 -N "" -q -f ssh/ssh_host_rsa_key < /dev/null
echo "ssh_host_rsa_key was created!"

chmod 700 ssh/ssh_host*