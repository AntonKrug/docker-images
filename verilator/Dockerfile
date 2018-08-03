#Verilator and nodeJS v8 container

FROM debian:8.11-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>

# Get all dependancies 
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget xz-utils curl sudo gnupg2 git build-essential autoconf autoconf flex bison ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 


# Install nodejs
RUN apt-get update && \
    sudo curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    node -v


# Get, build and install verilator
RUN wget --no-check-certificate https://www.veripool.org/ftp/verilator-3.924.tgz && \
    tar xfv verilator-3.924.tgz && \
    rm -v verilator-3.924.tgz && \
    cd verilator-3.924 && \
    ./configure && \
    THREADS=`grep -c ^processor /proc/cpuinfo` && \
    make -j $THREADS && \
    make install && \
    verilator --version


VOLUME /docker_shares/common

