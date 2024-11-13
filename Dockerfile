FROM ubuntu:22.04

ENV VNC_PASSWORD=123_567
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

RUN test -n "$http_proxy" && echo "Acquire::http::Proxy \"$http_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf
RUN test -n "$https_proxy" && echo "Acquire::https::Proxy \"$https_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf

RUN  apt-get update && \
     apt-get install -y xfce4 xfce4-goodies tigervnc-standalone-server git && \
     rm -rf /var/lib/apt/lists/* && \
     rm -f /etc/apt/apt.conf.d/10proxy.conf

RUN git clone --depth 1 https://github.com/allape/noVNC.git /usr/share/novnc
#RUN git clone --depth 1 https://github.com/novnc/noVNC.git /usr/share/novnc

COPY vnc_config /root/.vnc/config
COPY entrypoint.sh /entrypoint.sh

RUN echo "$VNC_PASSWORD" > /root/plain_passwd.txt && \
    vncpasswd -f < /root/plain_passwd.txt > /root/.vnc/passwd && \
    rm -f /root/plain_passwd.txt && \
    chmod 600 /root/.vnc/passwd

RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh

# docker build -t allape/ubuntu-vnc .
