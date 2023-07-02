#!/bin/bash

apt-get update
apt-get install -y make gcc git wget && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

cd /opt/ && wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz && tar -C /usr/local -xzf /opt/go1.20.5.linux-amd64.tar.gz && rm /opt/go1.20.5.linux-amd64.tar.gz
cd /opt/ && git clone https://github.com/m13253/dns-over-https.git 
cd /opt/dns-over-https && PATH=$PATH:/usr/local/go/bin make && PATH=$PATH:/usr/local/go/bin make install

apt-get purge -y make gcc git wget 
apt-get autoremove -y

touch /etc/s6-overlay/s6-rc.d/user/contents.d/doh
mkdir /data && mv /etc/pihole /data && ln -sf /data /etc/pihole

