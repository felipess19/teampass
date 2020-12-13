FROM php:7.4-apache
LABEL author="felipess19@protonmail.com"


RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev libpng-dev

RUN docker-php-ext-install gd bcmath mysqli && docker-php-ext-enable gd bcmath mysqli

COPY 000-teampass.conf /etc/apache2/sites-available/000-teampass.conf
COPY start-apache.sh /usr/local/bin
RUN chmod +x /usr/local/bin/start-apache.sh

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php_teampass.ini $PHP_INI_DIR/conf.d/

RUN echo && \
    mkdir -p /usr/local/teampass/src/ && \
    chown -R www-data: /usr/local/teampass/src/ && \
    echo

COPY . /usr/local/teampass/src/

RUN echo && \
    mkdir -p /usr/local/teampass/conf/ && \
    chown -R www-data: /var/www && \
    chown -R www-data: /usr/local/teampass/conf/ && \
    echo


CMD ["/usr/local/bin/start-apache.sh"]
