FROM debian:bookworm 

LABEL org.opencontainers.image.authors="ipetrov"

RUN apt-get update && \
    apt-get install -y nginx --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/conf.d
COPY ./tools/server.crt /etc/nginx/ssl/

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]

