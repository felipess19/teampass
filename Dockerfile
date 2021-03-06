FROM php:7.4-apache
LABEL author="felipess19@protonmail.com"


RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev libpng-dev libldap2-dev

RUN docker-php-ext-install gd bcmath mysqli ldap

COPY 000-teampass.conf /etc/apache2/sites-available/000-teampass.conf
COPY start-apache.sh /usr/local/bin/start-apache.sh
RUN chmod +x /usr/local/bin/start-apache.sh

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php-teampass.ini $PHP_INI_DIR/conf.d/

RUN echo && \
    mkdir -p /usr/local/teampass/src/ && \
    chown -R www-data: /usr/local/teampass/src/ && \
    echo

COPY . /usr/local/teampass/src/

RUN echo && \
    mkdir -p /usr/local/teampass/conf/ && \
    cp -ar /usr/local/teampass/src/* /var/www/html/ && \
    cd /var/www/html/ && \
    rm -rf start-apache.sh 000-teampass.conf php-teampass.ini && \
    chown -R www-data: /var/www && \
    chown -R www-data: /usr/local/teampass/conf/ && \
    echo


CMD ["/usr/local/bin/start-apache.sh"]
