#!/bin/bash

if [ "$#" -ne 6 ]; then
    echo "Usage: ./transfer.sh <ID_RSA> <PORT> <USERNAME> <HOSTNAME> <REMOTE_PATH> <COMMANDS_FILE>"
    exit
fi

DEST=$3@$4:$5
ssh-keygen -f  /home/$USER/.ssh/known_hosts -R $4
sftp -i $1 -oStrictHostKeyChecking=no -P $2 -b $6 $DEST