# Syncthing server
#
# http://syncthing.net
# https://github.com/calmh/syncthing

FROM debian:jessie
MAINTAINER Andy Giles <andyg5000@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget && \
    apt-get clean

ENV VERSION v0.10.29
ENV RELEASE syncthing-linux-amd64-v0.10.29
# Using wget because an ADD step with a URL isn't cached by docker build.
RUN wget -O /$RELEASE.tar.gz \
    https://github.com/syncthing/syncthing/releases/download/$VERSION/$RELEASE.tar.gz
RUN tar zxf /$RELEASE.tar.gz -C /usr/local && \
    ln -s /usr/local/$RELEASE/syncthing /usr/local/bin && \
    rm /$RELEASE.tar.gz
# TODO: validate GPG signature

ADD init /usr/local/bin/

RUN useradd -m syncthing

EXPOSE 8080 22000 21025/udp
VOLUME ["/storage/misc/syncthing/.config/syncthing", "/home/syncthing/Sync"]

CMD ["/usr/local/bin/init"]
