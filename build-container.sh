#!/bin/bash
# Description: Script for alpine nginx container
# Maintainer: Mauro Cardillo
#
echo "Get Remote Environment Variable"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/.env" -O ./.env
source ./.env

echo "Get Remote Settings"
wget -q "https://gitlab.com/maurosoft1973-docker/alpine-variable/-/raw/master/settings.sh" -O ./settings.sh
chmod +x ./settings.sh
source ./settings.sh

# Default values of arguments
IMAGE=maurosoft1973/alpine-nginx
IMAGE_TAG=latest
CONTAINER=alpine-nginx
LC_ALL=it_IT.UTF-8
TIMEZONE=Europe/Rome
IP=0.0.0.0
PORT=8018
NGINX_SITES_ENABLED=$(pwd)/test/etc/nginx
WWW_DATA=$(pwd)/test/www
WWW_USER=root
WWW_USER_UID=0
WWW_GROUP=www-data
WWW_GROUP_UID=33
DEBUG=0

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -it=*|--image-tag=*)
        IMAGE_TAG="${arg#*=}"
        shift # Remove
        ;;
        -cn=*|--container=*)
        CONTAINER="${arg#*=}"
        shift # Remove
        ;;
        -cl=*|--lc_all=*)
        LC_ALL="${arg#*=}"
        shift # Remove
        ;;
        -ct=*|--timezone=*)
        TIMEZONE="${arg#*=}"
        shift # Remove
        ;;
        -ci=*|--ip=*)
        IP="${arg#*=}"
        shift # Remove
        ;;
        -cp=*|--port=*)
        PORT="${arg#*=}"
        shift # Remove
        ;;
        -wu=*|--www_user=*)
        WWW_USER="${arg#*=}"
        shift # Remove
        ;;
        -wui=*|--www_user_id=*)
        WWW_USER_UID="${arg#*=}"
        shift # Remove
        ;;
        -wg=*|--www_group=*)
        WWW_GROUP="${arg#*=}"
        shift # Remove
        ;;
        -wgi=*|--www_group_id=*)
        WWW_GROUP_UID="${arg#*=}"
        shift # Remove
        ;;
        -d=*|--debug=*)
        DEBUG="${arg#*=}"
        shift # Remove
        ;;
        -h|--help)
        echo -e "usage "
        echo -e "$0 "
        echo -e "  -it=|--image-tag -> ${IMAGE}:${IMAGE_TAG} (image with tag)"
        echo -e "  -cn=|--container -> ${CONTAINER} (container name)"
        echo -e "  -cl=|--lc_all -> ${LC_ALL} (container locale)"
        echo -e "  -ct=|--timezone -> ${TIMEZONE} (container timezone)"
        echo -e "  -ci=|--ip -> ${IP} (container ip)"
        echo -e "  -cp=|--port -> ${PORT} (container port listen)"
        echo -e "  -wd=|--www_data -> ${WWW_DATA} (www data)"
        echo -e "  -wu=|--www_user -> ${WWW_USER} (www user)"
        echo -e "  -wui=|--www_user_id -> ${WWW_USER_UID} (www user uid)"
        echo -e "  -wg=|--www_group -> ${WWW_GROUP} (www user group)"
        echo -e "  -wgi=|--www_group_id -> ${WWW_GROUP_UID} (www user group uid)"
        echo -e "  -d=|--debug=${DEBUG} -> debug mode"
        exit 0
        ;;
    esac
done

echo "# Image                   : ${IMAGE}:${IMAGE_TAG}"
echo "# Container Name          : ${CONTAINER}"
echo "# Container Locale        : ${LC_ALL}"
echo "# Container Timezone      : ${TIMEZONE}"
echo "# Container IP            : $IP"
echo "# Container Port Listen   : $PORT"
echo "# WWW Data                : $WWW_DATA"
echo "# WWW User                : $WWW_USER"
echo "# WWW User UID            : $WWW_USER_UID"
echo "# WWW Group               : $WWW_GROUP"
echo "# WWW Group UID           : $WWW_GROUP_UID"

echo -e "Check if container ${CONTAINER} exist"
CHECK=$(docker container ps -a -f "name=${CONTAINER}" | wc -l)
if [ ${CHECK} == 2 ]; then
      echo -e "Stop Container -> ${CONTAINER}"
      docker stop ${CONTAINER} > /dev/null

      echo -e "Remove Container -> ${CONTAINER}"
      docker container rm ${CONTAINER} > /dev/null
else
      echo -e "The container ${CONTAINER} not exist"
fi

docker pull ${IMAGE}
echo -e "Create and run container"
docker run -dit --name ${CONTAINER} -p ${IP}:${PORT}:80 -v ${WWW_DATA}:/var/www -v ${NGINX_SITES_ENABLED}:/etc/nginx/sites-enabled -e DEBUG=${DEBUG} -e LC_ALL=${LC_ALL} -e TIMEZONE=${TIMEZONE} -e WWW_USER=${WWW_USER} -e WWW_USER_UID=${WWW_USER_UID} -e WWW_GROUP=${WWW_GROUP} -e WWW_GROUP_UID=${WWW_GROUP_UID} -e IP=${IP} -e PORT=${PORT} ${IMAGE}:${IMAGE_TAG}

echo -e "Sleep 5 second"
sleep 5

IP=$(docker exec -it ${CONTAINER} /sbin/ip route | grep "src" | awk '{print $7}')
echo -e "IP Address is: ${IP}";

echo -e ""
echo -e "Environment variable";
docker exec -it ${CONTAINER} env

echo -e ""
echo -e "Test Locale (date)";
docker exec -it ${CONTAINER} date

echo -e ""
echo -e "Test Http"
curl -I http://$IP

echo -e ""
echo -e "Container Logs"
docker logs ${CONTAINER}

rm -rf ./.env
rm -rf ./settings.sh
