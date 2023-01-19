FROM golang:bullseye AS build

WORKDIR /src

RUN apt update && apt -y install jq \
# download latest version of DOH
    && set -x ;\
    DOH_VERSION_LATEST="$(curl -s https://api.github.com/repos/m13253/dns-over-https/tags|jq -r '.[0].name')" \
    && curl -L "https://github.com/m13253/dns-over-https/archive/${DOH_VERSION_LATEST}.tar.gz" -o doh.tar.gz \
    && tar xf doh.tar.gz \
    && rm doh.tar.gz \
    && cd dns-over-https* \
    # Remove debug information
    && sed -ie 's/GOBUILD = go build/GOBUILD = CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w"/g' Makefile \
    && make doh-server/doh-server \
    && mkdir /dist \
    && cp doh-server/doh-server /dist/doh-server \
    && echo ${DOH_VERSION_LATEST} > /dist/doh-server.version

# use a distroless base image with glibc
FROM gcr.io/distroless/static-debian11:nonroot

COPY --from=build --chown=nonroot /dist /server

# run as non-privileged user
USER nonroot

EXPOSE 8053

ENTRYPOINT [ "/server/doh-server", "-conf", "/server/doh-server.conf" ]