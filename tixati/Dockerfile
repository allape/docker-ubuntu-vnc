FROM allape/ubuntu-vnc

ARG TIXATI_BINNAME="tixati_3.31-1_amd64.deb"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

WORKDIR /root/Downloads

RUN test -n "$http_proxy" && echo "Acquire::http::Proxy \"$http_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf
RUN test -n "$https_proxy" && echo "Acquire::https::Proxy \"$https_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf

RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/apt/apt.conf.d/10proxy.conf

RUN curl -L -o $TIXATI_BINNAME "https://download.tixati.com/$TIXATI_BINNAME" && \
    curl -L -o $TIXATI_BINNAME.asc "https://download.tixati.com/$TIXATI_BINNAME.asc" && \
    curl -L -o tixati.key https://tixati.com/tixati.key

RUN gpg --import tixati.key && \
    gpg --with-fingerprint "$TIXATI_BINNAME.asc"

RUN apt-get install "./$TIXATI_BINNAME"

ENTRYPOINT /entrypoint.sh

# docker build -t allape/tixati .
