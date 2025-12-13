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

RUN chown -R www-data:www-data /var/www/html

COPY ./tools/configure.sh /tmp/
RUN chmod +x /tmp/configure.sh

ENTRYPOINT ["/tmp/configure.sh"]
CMD ["php-fpm", "-F"]
# mv wp-config-sample.php wp-config.php && \
