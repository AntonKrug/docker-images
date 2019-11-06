# Litex migen slim variant
FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV HOME=/root/
ENV DEBIAN_FRONTEND noninteractive
# https://stackoverflow.com/questions/53935949
# https://stackoverflow.com/questions/48162574
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV PATH="${PATH}:/opt/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14/bin/:/usr/local/bin"


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


# Get all dependancies, install nodejs. Get, build and install verilator and clean behind itself in 1 step/layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget xz-utils curl sudo gnupg2 git build-essential autoconf autoconf flex bison ca-certificates && \
    sudo curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    wget --no-check-certificate https://www.veripool.org/ftp/verilator-3.924.tgz && \
    tar xfv verilator-3.924.tgz  && \
    rm -v verilator-3.924.tgz && \
    cd verilator-3.924  && \
    ./configure  && \
    THREADS=`grep -c ^processor /proc/cpuinfo`  && \
    make -j $THREADS  && \
    make install && \
    cd .. && \
    rm -rv verilator-3.924/ && \
    verilator --version && \
    export SUDO_FORCE_REMOVE=yes && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
    apt-get install -y python3 python3-dev python3-pip && \
    apt-get install -y libboost-all-dev libeigen3-dev libevent-dev libjson-c-dev && \
    apt-get install -y bison flex gawk pkg-config && \
    apt-get install -y iverilog verilator && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install --no-cache-dir wheel && \
    python3 -m pip install --ignore-installed --no-cache-dir pip && \
    python3 -m pip install --ignore-installed --no-cache-dir requests


# https://github.com/enjoy-digital/litex
RUN cd /opt && \
    wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    chmod +x litex_setup.py && \
    ./litex_setup.py init install


RUN cd /opt && \
    wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz && \
    tar -xvf riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz && \
    rm riscv64-*.tar.gz


VOLUME /docker_shares/common
