#!/bin/sh

DEBUG=${DEBUG:-"0"}
WWW_USER=${WWW_USER:-"www"}
WWW_USER_UID=${WWW_USER_UID:-"5001"}
WWW_GROUP=${WWW_GROUP:-"www-data"}
WWW_GROUP_UID=${WWW_GROUP_UID:-"33"}

source /scripts/init-alpine.sh

#Create Group (if not exist)
CHECK=$(cat /etc/group | grep $WWW_GROUP | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create group $WWW_GROUP with uid $WWW_GROUP_UID"
    addgroup -g ${WWW_GROUP_UID} ${WWW_GROUP}
else
    echo -e "Skipping,group $WWW_GROUP exist"
fi

#Create User (if not exist)
CHECK=$(cat /etc/passwd | grep $WWW_USER | wc -l)
if [ ${CHECK} == 0 ]; then
    echo "Create User $WWW_USER with uid $WWW_USER_UID"
    adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER}
else
    echo -e "Skipping,user $WWW_USER exist"
fi

echo "Change user for nginx process at $WWW_USER"
sed "s/user {user}/user ${WWW_USER}/g" /etc/nginx/nginx.conf > /tmp/nginx.conf
cp /tmp/nginx.conf /etc/nginx/nginx.conf

echo "Listen on $IP:$PORT"

if [ "${DEBUG}" -eq "0" ]; then
    /usr/sbin/nginx -c /etc/nginx/nginx.conf
else
   /bin/sh
fi
