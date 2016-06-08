FROM ubuntu:16.04
MAINTAINER Tobias Kuendig <tobias@offline.swiss>

RUN apt-get update && apt-get -y install git curl apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-sqlite php7.0-mcrypt php7.0-xml php7.0-zip unzip php7.0-mbstring php7.0-json && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/a2enmod rewrite php7.0

ADD 000-laravel.conf /etc/apache2/sites-available/
ADD 001-laravel-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laravel 001-laravel-ssl

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN /bin/mkdir /var/www/laravel
RUN /bin/chown www-data:www-data -R /var/www/laravel

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

WORKDIR /var/www/laravel

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]