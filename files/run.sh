#!/bin/sh

WWW_USER=${WWW_USER:-"www"}
WWW_USER_UID=${WWW_USER_UID:-"5001"}
LOCALTIME=${LOCALTIME:-"Europe/Brussels"}

#Create User (if not exist)
CHECK=$(cat /etc/passwd | grep $WWW_USER | wc -l)
if [ $CHECK == "0" ]; then
    echo "Create User $WWW_USER with uid $WWW_USER_UID"
    adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER}
else
    echo -e "Skipping,user $WWW_USER exist"
fi

echo "Change user for nginx process at $WWW_USER"
sed "s/user {user}/user ${WWW_USER}/g" /etc/nginx/nginx.conf > /tmp/nginx.conf
cp /tmp/nginx.conf /etc/nginx/nginx.conf

#echo "Download Geo DB"
#if [ ! -f "/etc/nginx/geoip2/GeoLite2-ASN.mmdb" ]; then
#    wget https://gitlab.com/maurosoft1973-docker/alpine-nginx/-/raw/master/conf/etc/nginx/geoip2/GeoLite2-ASN.mmdb -O /etc/nginx/geoip2/GeoLite2-ASN.mmdb
#fi

#if [ ! -f "/etc/nginx/geoip2/GeoLite2-City.mmdb" ]; then
#    wget https://gitlab.com/maurosoft1973-docker/alpine-nginx/-/raw/master/conf/etc/nginx/geoip2/GeoLite2-City.mmdb -O /etc/nginx/geoip2/GeoLite2-City.mmdb
#fi

#if [ ! -f "/etc/nginx/geoip2/GeoLite2-Country.mmdb" ]; then
#    wget https://gitlab.com/maurosoft1973-docker/alpine-nginx/-/raw/master/conf/etc/nginx/geoip2/GeoLite2-Country.mmdb -O /etc/nginx/geoip2/GeoLite2-Country.mmdb
#fi

echo "Change default localtime with ${LOCALTIME}"
cp /usr/share/zoneinfo/${LOCALTIME} /etc/localtime

#nginx -g
#/bin/sh
/usr/sbin/nginx -c /etc/nginx/nginx.conf