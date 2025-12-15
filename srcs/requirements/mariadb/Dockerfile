FROM debian:bookworm 

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends\
    mariadb-server \
    mariadb-client \
    && \
    rm -rf /var/lib/apt/lists/* 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/configure.sh /bin/

ENTRYPOINT ["/bin/configure.sh"]
CMD ["mysqld"]
