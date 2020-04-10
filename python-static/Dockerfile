# Building static python with musl with gcc/clang

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV HOME=/root/

# Fixing apt-key no tty issue:
# https://stackoverflow.com/questions/53935949/apt-key-fails-recently-inside-docker
# https://stackoverflow.com/questions/48162574/how-to-circumvent-apt-key-output-should-not-be-parsed
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# Allow wider privileges on new files so they will be easier to delete, in case 
# they will be created by wrong user on a mounted volume
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc

# Some basic tools such as gcc
RUN apt-get update && \
    apt-get install -y build-essential wget git vim p7zip-full unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    

# Dependencies to build musl and python3
RUN echo "deb-src http://ftp.ie.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/strech-sources.list && \
    apt-get update && \
    apt-get install -y apt-utils xz-utils clang musl && \
    apt-get build-dep -y musl && \
    apt-get build-dep -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  

ENV DIR_WORK /opt/python-static
ENV DIR_MUSL /opt/python-static/musl
ENV DIR_PYTHON /opt/python-static/python

RUN mkdir -p "${DIR_WORK}"

# Building musl-gcc
RUN export CC="gcc-6" && \
    cd "${DIR_WORK}" && \
    wget "http://musl.libc.org/releases/musl-1.2.0.tar.gz" && \
    tar -xzf musl-1.2.0.tar.gz && \
    rm musl-1.2.0.tar.gz && \
    cd musl-1.2.0 && \
    ./configure --prefix="${DIR_MUSL}-gcc" --disable-shared && \
    make && \
    make install

# Building musl-clang
RUN export CC="clang-3.8" && \
    cd "${DIR_WORK}" && \
    wget "http://musl.libc.org/releases/musl-1.2.0.tar.gz" && \
    tar -xzf musl-1.2.0.tar.gz && \
    rm musl-1.2.0.tar.gz && \
    cd musl-1.2.0 && \
    ./configure --prefix="${DIR_MUSL}-clang" --disable-shared && \
    make && \
    make install

VOLUME /docker_shares/common
