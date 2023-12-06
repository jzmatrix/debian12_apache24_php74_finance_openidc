FROM jzmatrix/debian12_base_image:latest
################################################################################
#  php7.4-cgi
# php-dev 
################################################################################
RUN apt update && \
    apt -y upgrade && \
    apt -y install passwd lsb-release apt-transport-https ca-certificates wget curl && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
    apt update && \
    apt -y install apache2 \   
                    pkg-config \
                    libmongoc-1.0-0 \
                    php-xml \
                    php7.0-xml \
                    php7.4-xml \
                    php7.4-bcmath \
                    php7.4-bz2 \
                    php7.4-common \
                    php7.4-curl \
                    php7.4-fpm \
                    php7.4-gd \
                    php7.4-geoip \
                    php7.4-gmp \
                    php7.4-imagick \
                    php7.4-intl \
                    php7.4-json \
                    php7.4-mbstring \
                    php7.4-mcrypt \
                    php7.4-memcache \
                    php7.4-memcached \
                    php7.4-mongodb \
                    php7.4-mysql \
                    php7.4-opcache \
                    php7.4-pspell \
                    php7.4-readline \
                    php7.4-snmp \
                    php7.4-tidy \
                    php7.4-xmlrpc \
                    php7.4-xsl \
                    php7.4-zip \
                    php-pear && \
    /usr/bin/pear channel-update pear.php.net && \
    /usr/bin/pear install Math_Finance

RUN /bin/rm -f /etc/localtime && \
    /bin/cp /usr/share/zoneinfo/America/New_York /etc/localtime && \
    rm -rf /var/www/html/*
################################################################################
ADD https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.11.2/libapache2-mod-auth-openidc_2.4.11.2-1.buster+1_amd64.deb /tmp/libapache2-mod-auth-openidc_2.4.11.2-1.buster+1_amd64.deb
RUN dpkg -i /tmp/libapache2-mod-auth-openidc_2.4.11.2-1.buster+1_amd64.deb ; echo 0 && \
    apt-get -f -y install && \
    a2enmod auth_openidc
################################################################################
ADD config/php7/php.ini /etc/php/7.4/fpm/php.ini
ADD config/apache2/apache2.conf /etc/apache2/apache2.conf
ADD config/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD config/apache2/info.conf /etc/apache2/mods-available/info.conf
ADD config/apache2/status.conf /etc/apache2/mods-available/status.conf
ADD config/run-httpd.sh /run-httpd.sh
ADD config/startServices.sh /opt/startServices.sh
################################################################################
RUN chmod 644 /etc/php/7.4/fpm/php.ini && \
    chmod 644 /etc/apache2/apache2.conf && \
    chmod 644 /etc/apache2/sites-available/000-default.conf && \
    chmod 644 /etc/apache2/mods-available/info.conf && \
    chmod 644 /etc/apache2/mods-available/status.conf && \
    ln -f -s /etc/apache2/conf-available/php7.4-fpm.conf /etc/apache2/conf-enabled/ && \
    a2enmod info && \
    a2enmod rewrite && \
    a2enmod remoteip && \
    a2enmod status && \
    a2enmod proxy_fcgi && \
    a2enmod setenvif && \
    a2enconf php7.4-fpm  && \
    chmod -v +x /run-httpd.sh && \
    chmod 755 /opt/startServices.sh
################################################################################
CMD [ "/opt/startServices.sh" ]
