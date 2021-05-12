#Verilator with lcov support and nodeJS v8 container

FROM debian:8-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Get all dependancies, install nodejs. Get, build and install verilator and clean behind itself in 1 step/layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget xz-utils curl sudo lcov gnupg2 git autoconf build-essential autoconf autoconf flex bison ca-certificates dos2unix && \
    sudo curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - && \
    sudo curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    git clone https://github.com/truhlikfredy/verilator-fork.git && \
    cd verilator-fork  && \
    autoconf && \
    ./configure  && \
    THREADS=`grep -c ^processor /proc/cpuinfo`  && \
    make -j $THREADS  && \
    make install && \
    cd .. && \
    rm -rv verilator-fork/ && \
    verilator --version && \
    export SUDO_FORCE_REMOVE=yes && \
    apt-get remove --purge -y git wget xz-utils curl sudo git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    


VOLUME /docker_shares/common

