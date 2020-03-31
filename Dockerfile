FROM maurosoft1973/alpine:3.11.5-amd64

ENV MAXMIND_VERSION=1.4.2
ENV NGINX_VERSION=1.17.7
ENV LOCALTIME=Europe/Brussels
ENV WWW_DATA_UID=33
ENV WWW_USER=t500
ENV WWW_USER_UID=5001

#adduser -s /bin/false -H -u ${WWW_USER_UID} -D ${WWW_USER} && \
	
RUN \
	deluser xfs && \
	adduser -s /bin/false -H -u ${WWW_DATA_UID} -D www-data && \
	mkdir -p /var/run/nginx/ && \
	build_pkgs="build-base linux-headers openssl-dev pcre-dev gd-dev libxslt-dev wget zlib-dev" && \
	runtime_pkgs="ca-certificates libmaxminddb openssl gd libxslt pcre zlib tzdata git" && \
	apk --no-cache add ${build_pkgs} ${runtime_pkgs} && \
	cd /tmp && \
	git clone https://github.com/leev/ngx_http_geoip2_module /ngx_http_geoip2_module && \
	wget https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz && \
	tar xf libmaxminddb-${MAXMIND_VERSION}.tar.gz && \
	cd /tmp/libmaxminddb-${MAXMIND_VERSION} && \
	./configure && \
	make && \
	make check && \
	make install && \
	cd /tmp && \ 
	wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar xzf nginx-${NGINX_VERSION}.tar.gz && \
	cd /tmp/nginx-${NGINX_VERSION} && \
	./configure \
	--prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--modules-path=/usr/lib/nginx/modules \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--user=www-data \
	--group=www-data \
	--build=Alpine \
	--builddir=${NGINX_VERSION} \
	--with-select_module \
	--with-poll_module \
	--with-threads \
	--with-file-aio \
	--with-http_ssl_module \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-http_xslt_module=dynamic \
	--with-http_image_filter_module=dynamic \
	--with-http_sub_module \
	--with-http_dav_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_auth_request_module \
	--with-http_random_index_module \
	--with-http_secure_link_module \
	--with-http_degradation_module \
	--with-http_slice_module \
	--with-http_stub_status_module \
	--with-mail \
	--with-mail_ssl_module \
	--with-stream=dynamic \
	--with-stream_ssl_module \
	--with-stream_realip_module \
	--with-stream_ssl_preread_module \
	--with-compat \
	--with-http_v2_module \
	--add-dynamic-module=/ngx_http_geoip2_module \
	--http-client-body-temp-path=/var/cache/nginx/client_temp \
	--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
	--http-scgi-temp-path=/var/cache/nginx/scgi_temp && \
	make && \
	make install && \
	sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf && \
	addgroup -S nginx && \
	adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
	rm -rf /tmp/* && \
	apk del ${build_pkgs} && \
	rm -rf /var/cache/apk/* && \
	rm -rf /ngx_http_geoip2_module && \
	rm /etc/nginx/fastcgi.conf && \
	rm /etc/nginx/fastcgi.conf.default && \
	rm /etc/nginx/fastcgi_params && \
	rm /etc/nginx/fastcgi_params.default && \
	rm /etc/nginx/koi-utf && \
	rm /etc/nginx/koi-win && \
	rm /etc/nginx/mime.types && \
	rm /etc/nginx/mime.types.default && \
	rm /etc/nginx/scgi_params && \
	rm /etc/nginx/scgi_params.default && \
	rm /etc/nginx/uwsgi_params && \
	rm /etc/nginx/uwsgi_params.default && \
	rm /etc/nginx/win-utf && \
	rm /etc/nginx/nginx.conf && \
	rm /etc/nginx/nginx.conf.default && \
	mkdir /etc/nginx/conf.d && \
	mkdir /etc/nginx/sites-enabled && \
	ln -s /usr/lib/nginx/modules/ /etc/nginx/modules && \
	cp /usr/share/zoneinfo/${LOCALTIME} /etc/localtime

COPY conf/etc/nginx/custom /etc/nginx/custom
COPY conf/etc/nginx/geoip2 /etc/nginx/geoip2
COPY conf/etc/nginx/global /etc/nginx/global
#COPY conf/etc/nginx/sites-enabled /etc/nginx/sites-enabled
COPY conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/etc/nginx/dhparams.pem /etc/nginx/dhparams.pem

#STOPSIGNAL SIGTERM

ADD files/run.sh /scripts/run.sh

RUN chmod -R 755 /scripts

VOLUME ["/var/www","/etc/nginx/sites-enabled"]

ENTRYPOINT ["/scripts/run.sh"]

#CMD ["nginx", "-g", "daemon off;"]