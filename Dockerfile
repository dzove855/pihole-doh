FROM debian
RUN apt-get update
RUN apt-get -y install podman net-tools gettext-base

COPY start.sh /opt 
COPY nginx.conf.tpl /opt/
CMD ["/opt/start.sh"]
