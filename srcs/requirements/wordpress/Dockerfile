FROM debian:bookworm 

RUN apt-get update && \
    apt-get install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress/* . && \
    rm -rf wordpress && \
    chown -R www-data:www-data /var/www/html && \
    \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp \

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./tools/configure.sh /bin/

ENTRYPOINT ["/bin/configure.sh"]
CMD ["php-fpm", "-F"]
