FROM maurosoft1973/alpine

ARG BUILD_DATE
ARG ALPINE_RELEASE
ARG ALPINE_RELEASE_REPOSITORY
ARG ALPINE_VERSION
ARG ALPINE_VERSION_DATE
ARG MAXMIND_VERSION
ARG NGINX_VERSION

LABEL \
    maintainer="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    architecture="amd64/x86_64" \
    nginx-version="${NGINX_VERSION}" \
    alpine-version="${ALPINE_VERSION}" \
    build="$BUILD_DATE" \
    org.opencontainers.image.title="Alpine Nginx" \
    org.opencontainers.image.description="Nginx Docker image running on Alpine Linux" \
    org.opencontainers.image.authors="Mauro Cardillo <mauro.cardillo@gmail.com>" \
    org.opencontainers.image.vendor="Mauro Cardillo" \
    org.opencontainers.image.version="v${NGINX_VERSION}" \
    org.opencontainers.image.url="https://hub.docker.com/r/maurosoft1973/alpine-nginx/" \
    org.opencontainers.image.source="https://gitlab.com/maurosoft1973-docker/alpine-nginx" \
    org.opencontainers.image.created=$BUILD_DATE

RUN \
    deluser xfs && \
    adduser -s /bin/false -H -u 33 -D www-data && \
    mkdir -p /var/run/nginx/ && \
    build_pkgs="build-base linux-headers openssl-dev pcre-dev gd-dev libxslt-dev wget zlib-dev" && \
    runtime_pkgs="ca-certificates openssl gd libxslt pcre zlib git curl" && \
    apk --no-cache add ${build_pkgs} ${runtime_pkgs} && \
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
    --user=nginx \
    --group=nginx \
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
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp && \
    make && \
    make install && \
    addgroup -S nginx && \
    adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
    rm -rf /tmp/* && \
    apk del ${build_pkgs} && \
    rm -rf /var/cache/apk/* && \
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
    mkdir -p /etc/ssl/domain && \
    ln -s /usr/lib/nginx/modules/ /etc/nginx/modules

COPY conf/base/etc/nginx/custom /etc/nginx/custom
COPY conf/base/etc/nginx/global /etc/nginx/global
COPY conf/base/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/base/etc/nginx/dhparams.pem /etc/nginx/dhparams.pem

ADD files/run-alpine-nginx.sh /scripts/run-alpine-nginx.sh

RUN chmod -R 755 /scripts

VOLUME ["/var/www","/etc/nginx/sites-enabled"]

ENTRYPOINT ["/scripts/run-alpine-nginx.sh"]
