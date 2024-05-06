#!/bin/bash
chmod 644 $1
sshpass -p "etSARZqwhKpCc5xvXMLa4EGz" scp $1 images@10.10.10.223:/var/www/patrick115.eu/upload/.storage
echo "https://upload.patrick115.eu/screenshot/${1##*/}"
