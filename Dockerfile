FROM debian
RUN apt-get update
RUN apt-get -y install podman net-tools

COPY start.sh /opt 
CMD ["/opt/start.sh"]
