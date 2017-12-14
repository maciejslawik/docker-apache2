FROM debian:wheezy
MAINTAINER Maciej Slawik <maciekslawik@gmail.com>

# Apache install
RUN sed -i -e 's/ main/ main non-free/' /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apache2 libapache2-mod-fastcgi && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/*

# Vhost conf
RUN  a2enmod actions fastcgi rewrite headers && \
     a2dissite default && \
     mkdir /var/lib/php-fcgi

# Permission configuration
RUN chmod 644 /var/log/apache2
RUN chown -R www-data:www-data /var/cache/apache2 /var/lib/apache2

EXPOSE 80

COPY run.sh /run.sh

CMD ["/run.sh"]
