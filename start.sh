#!/bin/bash

export IPA=$(ifconfig eth0 | awk  '/inet /{print $2}')
envsubst < /opt/nginx.conf.tpl > /opt/nginx.conf
cat /opt/nginx.conf

podman pull --tls-verify=false docker.io/pihole/pihole:latest
podman pull --tls-verify=false docker.io/satishweb/doh-server
podman pull --tls-verify=false docker.io/nginx

podman run -d --name doh-server -p 8053:8053 \
    -e UPSTREAM_DNS_SERVER="udp:$IPA:54" \
    -e DOH_HTTP_PREFIX="/dns-query" \
    -e DOH_SERVER_LISTEN=":8053" \
    -e DOH_SERVER_TIMEOUT="10" \
    -e DOH_SERVER_TRIES="3" \
    -e DOH_SERVER_VERBOSE="false" \
    docker.io/satishweb/doh-server

podman run -d --name pihole -p 81:80 -p 54:53/udp -p 54:53/tcp docker.io/pihole/pihole:latest
podman run --name nginx -p 80:80 -v /opt/nginx.conf:/etc/nginx/conf.d/default.conf docker.io/nginx &

sleep 30s
podman exec -it pihole pihole -a -p admin && wait -n

