# Nginx Docker image running on Alpine Linux

[![Docker Automated build](https://img.shields.io/docker/automated/maurosoft1973/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-nginx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/maurosoft1973/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-nginx/)
[![Docker Stars](https://img.shields.io/docker/stars/maurosoft1973/alpine-nginx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/alpine-nginx/)

[![Alpine Version](https://img.shields.io/badge/Alpine%20version-v%ALPINE_VERSION%-green.svg?style=for-the-badge)](https://alpinelinux.org/)
[![MariaDB Version](https://img.shields.io/docker/v/maurosoft1973/alpine-nginx?sort=semver&style=for-the-badge)](https://nginx.org/)


This Docker image [(maurosoft1973/alpine-nginx)](https://hub.docker.com/r/maurosoft1973/alpine-nginx/) is based on the minimal [Alpine Linux](https://alpinelinux.org/) with [Nginx v%NGINX_VERSION%](https://nginx.org/) web server.

##### Alpine Version %ALPINE_VERSION% (Released %ALPINE_VERSION_DATE%)
##### Nginx Version %NGINX_VERSION% (Released %NGINX_VERSION_DATE%)

----

## What is Alpine Linux?
Alpine Linux is a Linux distribution built around musl libc and BusyBox. The image is only 5 MB in size and has access to a package repository that is much more complete than other BusyBox based images. This makes Alpine Linux a great image base for utilities and even production applications. Read more about Alpine Linux here and you can see how their mantra fits in right at home with Docker images.

## What is Nginx?
NGINX is open source software for web serving, reverse proxying, caching, load balancing, media streaming, and more. It started out as a web server designed for maximum performance and stability. In addition to its HTTP server capabilities, NGINX can also function as a proxy server for email (IMAP, POP3, and SMTP) and a reverse proxy and load balancer for HTTP, TCP, and UDP servers.

The goal behind NGINX was to create the fastest web server around, and maintaining that excellence is still a central goal of the project. NGINX consistently beats Apache and other servers in benchmarks measuring web server performance. Since the original release of NGINX, however, websites have expanded from simple HTML pages to dynamic, multifaceted content. NGINX has grown along with it and now supports all the components of the modern Web, including WebSocket, HTTP/2, gRPC, and streaming of multiple video formats (HDS, HLS, RTMP, and others).

The versions of images are:
* base : only nginx web server
* geo : nginx web server + maxmind geo module with database

## Architectures

* ```:amd64```, ```:x86_64``` - 64 bit Intel/AMD (x86_64/amd64)

## Tags

* ```:latest``` latest branch based (Automatic Architecture Selection)
* ```:amd64```, ```:x86_64```  amd64 based on latest tag but amd64 architecture
* ```:geo``` geo latest branch based (Automatic Architecture Selection)
* ```:geo-amd64```, ```:geo-x86_64```  geo amd64 based on latest tag but amd64 architecture

## Layers & Sizes

![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/alpine-nginx?style=for-the-badge)

## Volume structure

* `/var/www`:
* `/etc/nginx/sites-enabled`: server block configuration file

## Environment Variables:

### Main Nginx parameters:
* `LC_ALL`: default locale (en_GB.UTF-8)
* `TIMEZONE`: default timezone (Europe/Brussels)
* `PORT`: listen port
* `WWW_DATA`:
* `WWW_USER`:
* `WWW_USER_ID`:
* `WWW_GROUP`:
* `WWW_GROUP_ID`:

***
###### Last Update %LAST_UPDATE%
