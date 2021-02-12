FROM debian:buster as base

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ENV VERSION=1.0.0

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM
ARG BUILDOS
ARG BUILDARCH
ARG BUILDVARIANT

RUN arch

RUN apt-get update \
 && apt-get install -y systemd systemd-sysv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]

FROM base as builder

RUN echo deb http://deb.debian.org/debian buster-backports main >> /etc/apt/sources.list.d/sources.list \
 && apt-get update \
 && apt-get install -y build-essential \
 && apt-get install -y libasound2-dev libpulse-dev libvorbisidec-dev libvorbis-dev libopus-dev libflac-dev \
                       libsoxr-dev alsa-utils libavahi-client-dev avahi-daemon libexpat1-dev libboost1.71-all-dev/buster-backports debhelper git cmake \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && git clone https://github.com/badaix/snapcast.git \
 && cd snapcast \
 && git checkout -b v0.23.0 

RUN cd snapcast \
 && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules binary

FROM base as runtime

ENV VERSION=1.0.0

COPY --from=builder /snapclient_0.23.0-1_$TARGETARCH.deb /snapclient_0.23.0-1_$TARGETARCH.deb
COPY --from=builder /snapserver_0.23.0-1_$TARGETARCH.deb /snapserver_0.23.0-1_$TARGETARCH.deb

RUN apt-get update \
 && apt-get install -y /snapserver_0.23.0-1_$TARGETARCH.deb mplayer \
 && systemctl enable snapserver \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
