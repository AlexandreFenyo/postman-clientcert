
# postman-clientcert

## PoC d'injection d'authentification client TLS

Les commandes à lancer pour tester ce PoC nécessitent d'être dans le répertoire postman-clientcert/docker et d'utiliser la commande `make`.

Les sources de ce PoC sont disponibles sur GitHub : [https://github.com/AlexandreFenyo/postman-clientcert](https://github.com/AlexandreFenyo/postman-clientcert)

## Récupération de l'image Docker de ce PoC
Si vous disposez d'une architecture matérielle x64/amd64, vous pouvez directement récupérer l'image OCI qui est disponible sur DockerHub : [https://hub.docker.com/repository/docker/fenyoa/postman-clientcert](https://hub.docker.com/repository/docker/fenyoa/postman-clientcert)

Récupération de l'image :
```
fenyo docker % docker pull fenyoa/postman-clientcert:latest
W11% docker pull fenyoa/postman-clientcert:latest
latest: Pulling from fenyoa/postman-clientcert
...
Digest: sha256:a48fe6b743a45bd9d17e9708e0c0a764a3879d8466674e8ede5d5270ebebbbf6
Status: Downloaded newer image for fenyoa/postman-clientcert:latest
docker.io/fenyoa/postman-clientcert:latest
```

Dans le cas contraire, vous pouvez refabriquer l'image comme ceci :
```
W11% make build
docker build -t postman-clientcert:latest .
[+] Building 3.1s (13/13) FINISHED                                                                                                                           docker:default
 => [internal] load build definition from Dockerfile                                                                                                                   0.0s
 => => transferring dockerfile: 608B                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/haproxy:latest                                                                                                      0.7s
 => [auth] library/haproxy:pull token for registry-1.docker.io                                                                                                         0.0s
 => [internal] load .dockerignore                                                                                                                                      0.0s
 => => transferring context: 2B                                                                                                                                        0.0s
 => [1/7] FROM docker.io/library/haproxy:latest@sha256:460591a5f018cffddbb8122a5acde386aeb480e29b49613a340fc89258cadc39                                                0.0s
 => [internal] load build context                                                                                                                                      0.4s
 => => transferring context: 223B                                                                                                                                      0.0s
 => CACHED [2/7] COPY haproxy-minimal.cfg /usr/local/etc/haproxy/haproxy-minimal.cfg                                                                                   0.0s
 => CACHED [3/7] COPY certs/client.pem /etc/haproxy/certs/client.pem                                                                                                   0.0s
 => CACHED [4/7] COPY certs/server-cert.pem /etc/haproxy/certs/server-cert.pem                                                                                         0.0s
 => CACHED [5/7] COPY certs/server-key.pem /etc/haproxy/certs/server-cert.pem.key                                                                                      0.0s
 => CACHED [6/7] COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh                                                                                         0.0s
 => CACHED [7/7] RUN apt-get update &&     apt-get install -y gettext socat &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*                                    0.0s
 => exporting to image                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                0.0s
 => => writing image sha256:082faa5d9404f5fb8cc9e75c53e05b14adfea82d99d754ce0e0b3661f6ab42d3                                                                           0.0s
 => => naming to docker.io/library/postman-clientcert:latest                                                                                                           0.0s
```

## Lancer un test de ce PoC
### Lancer un serveur web local
Ce serveur local écoute sur le port TCP/443, il utilise le champ SNI pour décider vers quel serveur renvoyer la connexion et quel certificat client injecter.
```

W11% make run
docker build -t postman-clientcert:latest .
[+] Building 0.6s (12/12) FINISHED                                                                                                                           docker:default
 => [internal] load build definition from Dockerfile                                                                                                                   0.0s
 => => transferring dockerfile: 608B                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/haproxy:latest                                                                                                      0.4s
 => [internal] load .dockerignore                                                                                                                                      0.1s
 => => transferring context: 2B                                                                                                                                        0.0s
 => [1/7] FROM docker.io/library/haproxy:latest@sha256:460591a5f018cffddbb8122a5acde386aeb480e29b49613a340fc89258cadc39                                                0.0s
 => [internal] load build context                                                                                                                                      0.0s
 => => transferring context: 223B                                                                                                                                      0.0s
 => CACHED [2/7] COPY haproxy-minimal.cfg /usr/local/etc/haproxy/haproxy-minimal.cfg                                                                                   0.0s
 => CACHED [3/7] COPY certs/client.pem /etc/haproxy/certs/client.pem                                                                                                   0.0s
 => CACHED [4/7] COPY certs/server-cert.pem /etc/haproxy/certs/server-cert.pem                                                                                         0.0s
 => CACHED [5/7] COPY certs/server-key.pem /etc/haproxy/certs/server-cert.pem.key                                                                                      0.0s
 => CACHED [6/7] COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh                                                                                         0.0s
 => CACHED [7/7] RUN apt-get update &&     apt-get install -y gettext socat &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*                                    0.0s
 => exporting to image                                                                                                                                                 0.0s
 => => exporting layers                                                                                                                                                0.0s
 => => writing image sha256:082faa5d9404f5fb8cc9e75c53e05b14adfea82d99d754ce0e0b3661f6ab42d3                                                                           0.0s
 => => naming to docker.io/library/postman-clientcert:latest                                                                                                           0.0s
docker: 'docker stop' requires at least 1 argument

Usage:  docker stop [OPTIONS] CONTAINER [CONTAINER...]

See 'docker stop --help' for more information
make: [Makefile:9: stop-rm] Error 123 (ignored)
docker: 'docker rm' requires at least 1 argument

Usage:  docker rm [OPTIONS] CONTAINER [CONTAINER...]

See 'docker rm --help' for more information
make: [Makefile:10: stop-rm] Error 123 (ignored)
docker run --name postman-clientcert -t -i -p 443:443 --rm postman-clientcert
CONFIGURATION FILE:
-- ------------------------------------------------------------
# Define global settings
global
    log stdout format raw local0 info
    maxconn 4096  # Maximum number of connections
    master-worker
    stats socket /tmp/haproxy-master.sock mode 600 level admin expose-fd listeners

# Default settings for all proxies
defaults
    log     global
    mode    http        # Operate in HTTP mode
    option  httplog     # Enable HTTP logging
    timeout connect 5s  # Max time to wait for a connection attempt to a server
    timeout client  30s # Max inactivity time on the client side
    timeout server  30s # Max inactivity time on the server side

frontend https_sni_router
bind *:443 ssl crt /etc/haproxy/certs/server-cert.pem
mode http

acl sni_wwwx ssl_fc_sni -i www.x.org
acl sni_wps   ssl_fc_sni -i wps-psc.dmp.monespacesante.fr

use_backend bk_xorg if sni_wwwx
use_backend bk_wps  if sni_wps
default_backend bk_none

backend bk_xorg
mode http
server xorg www.x.org:443 ssl verify none

backend bk_wps
mode http
server wps wps-psc.dmp.monespacesante.fr:443 ssl verify none crt /etc/haproxy/certs/client.pem

backend bk_none
mode http
http-response set-status 503 reason "Service Unavailable"
-- ------------------------------------------------------------
[NOTICE]   (1) : Initializing new worker (10)
[NOTICE]   (1) : Loading success.
```

