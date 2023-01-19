# Docker-dns-over-https 📦
A docker super tiny image using distroless or scratch as it base to run [a DOH server](https://github.com/m13253/dns-over-https)
>_This image is execpted to run behing a web server like NGINX or Traefik._

# Featury bits & pieces 🪡
A DOH server in a super tiny image (>8.5MB!)

This image come _ATM_ without any openssl support or arm64, but will in a near futur _maybe_.

It principaly a base image for me and a learning one to build tiny secure docker image.

# Docker Compose configuration:
>This image doesn't come with a base config, but you can find it [here](https://github.com/m13253/dns-over-https/blob/master/doh-server/doh-server.conf)
```
version: "3"

services:
  doh-server:
    container_name: doh
    image: snowy68/dns-over-https:latest
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - ./doh/doh-server.conf:/server/doh-server.conf
```
>To use the scratch image just replace the tag to "scratch"
# TODO
- [ ] Support for arm64
- [ ] Image with openssl for those who want
