#!/bin/sh

WWW_USER=${WWW_USER:-"www"}
WWW_USER_UID=${WWW_USER_UID:-"5001"}
LOCALTIME=${WWW_USER_UID:-"Europe/Brussels"}

echo "Create User $WWW_USER with uid $WWW_USER_UID"
adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER}

echo "Use user $WWW_USER for nginx process"
sed "s/user {user}/user ${WWW_USER}/g" /etc/nginx/nginx.conf > /tmp/nginx.conf
cp /tmp/nginx.conf /etc/nginx/nginx.conf

echo "Change default localtime with ${LOCALTIME}"
cp /usr/share/zoneinfo/${LOCALTIME} /etc/localtime

/bin/sh