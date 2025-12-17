FROM debian:bookworm 

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/conf.d
COPY ./tools/server.crt /etc/nginx/ssl/


ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]

