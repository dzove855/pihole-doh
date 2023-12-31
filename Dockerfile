FROM pihole/pihole

VOLUME /data
COPY install.sh /opt 
RUN bash /opt/install.sh
COPY lighttpd.conf.doh /etc/lighttpd/conf-enabled/zzz-doh.conf
COPY doh-server.conf /etc/dns-over-https/doh-server.conf
COPY s6-doh-server /etc/s6-overlay/s6-rc.d/doh 
COPY index.html /var/www/html/

ENV CORS_HOSTS=localhost,saashup.com 
ENV WEBPASSWORD=admin
