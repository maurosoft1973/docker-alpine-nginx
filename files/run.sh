#!/bin/sh

WWW_USER=${WWW_USER:-"www"}
WWW_USER_UID=${WWW_USER_UID:-"5001"}

echo "User: $WWW_USER"
echo "User UID: $WWW_USER_UID"

adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER}

sed "s/user {user}/user ${WWW_USER}/g" /etc/nginx/nginx.conf > /tmp/nginx.conf

cp /tmp/nginx.conf /etc/nginx/nginx.conf

/bin/sh