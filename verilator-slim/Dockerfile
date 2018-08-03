#Verilator and nodeJS v8 container

FROM debian:8.11-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>

# Get all dependancies, install nodejs. Get, build and install verilator and clean behind itself in 1 step/layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget xz-utils curl sudo gnupg2 git build-essential autoconf autoconf flex bison ca-certificates && \
    sudo curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    wget --no-check-certificate https://www.veripool.org/ftp/verilator-3.924.tgz && \
    tar xfv verilator-3.924.tgz  && \
    rm xfv verilator-3.924.tgz  && \
    cd verilator-3.924  && \
    ./configure  && \
    THREADS=`grep -c ^processor /proc/cpuinfo`  && \
    make -j $THREADS  && \
    make install && \
    rm -rv verilator-3.924/    
    verilator --version && \
    export SUDO_FORCE_REMOVE=yes && \
    apt-get remove --purge -y git wget xz-utils curl sudo git
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


VOLUME /docker_shares/common

