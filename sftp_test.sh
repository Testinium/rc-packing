#!/bin/bash

cd test_sftp && make down && make up
sleep 10

../sftp.sh ./ssh/id_rsa 22 foo localhost /share ./test_commands.txt

make down

sha512sum -b ./makefile | cut -d' ' -f1 > checksum.txt
sha512sum -b ./data/makefile | cut -d' ' -f1 >> checksum.txt
n=`cat checksum.txt | uniq | wc -l`

if [ $n -ne 1 ]
then
    echo "Files are not exactly same!"
else
    echo "<OK>"
fi
