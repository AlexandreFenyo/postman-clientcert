FROM haproxy:latest

EXPOSE 8000

COPY haproxy-minimal.cfg /usr/local/etc/haproxy/haproxy-minimal.cfg
COPY certs/client.pem /etc/haproxy/certs/client.pem
COPY certs/server-cert.pem /etc/haproxy/certs/server-cert.pem
COPY certs/server-key.pem /etc/haproxy/certs/server-cert.pem.key
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER root

RUN apt-get update && \
    apt-get install -y gettext socat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER haproxy

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/tmp/haproxy.cfg"]
