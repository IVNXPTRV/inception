FROM debian:bookworm 

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && \
    rm -rf /var/lib/apt/lists/* 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/configure.sh /bin/
RUN chmod +x /bin/configure.sh

ENTRYPOINT ["/bin/configure.sh"]
CMD ["mysqld"]
