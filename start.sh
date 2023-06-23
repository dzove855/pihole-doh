#!/bin/bash

ipa=$(ifconfig eth0 | awk  '/inet /{print $2}')

podman pull --tls-verify=false docker.io/pihole/pihole:latest
podman pull --tls-verify=false docker.io/satishweb/doh-server

podman run -d --name doh-server -p 8053:8053 \
    -e UPSTREAM_DNS_SERVER="udp:$ipa:54" \
    -e DOH_HTTP_PREFIX="/dns-query" \
    -e DOH_SERVER_LISTEN=":8053" \
    -e DOH_SERVER_TIMEOUT="10" \
    -e DOH_SERVER_TRIES="3" \
    -e DOH_SERVER_VERBOSE="false" \
    docker.io/satishweb/doh-server

podman run --tls-verify=false --name pihole -p 80:80 -p 54:53/udp -p 54:53/tcp docker.io/pihole/pihole:latest &

sleep 30s
podman exec -it pihole pihole -a -p admin && wait -n

