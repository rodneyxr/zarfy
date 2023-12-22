# Experimenting with TLS in Apache HTTPD

```sh
sudo podman run --rm -it \
    -v ./httpd.conf:/usr/local/apache2/conf/httpd.conf \
    -v ./tls.crt:/usr/local/apache2/conf/server.crt \
    -v ./tls.key:/usr/local/apache2/conf/server.key \
    -p 443:443 \
    -p 80:80 \
    docker.io/httpd:alpine3.19
```