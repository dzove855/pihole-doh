FROM pihole/pihole
RUN apt-get update
RUN apt-get install -y make gcc git wget && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN cd /opt/ && wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz && tar -C /usr/local -xzf /opt/go1.20.5.linux-amd64.tar.gz && rm /opt/go1.20.5.linux-amd64.tar.gz
RUN cd /opt/ && git clone https://github.com/m13253/dns-over-https.git 
RUN cd /opt/dns-over-https && PATH=$PATH:/usr/local/go/bin make && PATH=$PATH:/usr/local/go/bin make install


RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/doh
COPY lighttpd.conf.doh /etc/lighttpd/conf-enabled/zzz-doh.conf
COPY doh-server.conf /etc/dns-over-https/doh-server.conf
COPY s6-doh-server /etc/s6-overlay/s6-rc.d/doh 

ENV CORS_HOSTS=localhost,saashup.com 
ENV WEBPASSWORD=admin
