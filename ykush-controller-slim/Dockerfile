# Slim version to access ykush USB controller

FROM debian:9.4-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>


# Get all dependancies, compile, install and wipe after finished
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential git wget unzip sudo libusb-1.0-0-dev libusb-1.0-0 libudev-dev libudev1 && \
    apt-get clean && \
    wget --no-check-certificate https://www.yepkit.com/uploads/documents/68548_ykushcmd_master_20171130.zip && \
    unzip *.zip && \
    rm *.zip &&\
    cd ykush-master && \
    ./build.sh ; \
    ./install.sh ; \
    mkdir -p /doc && \
    cp ./doc/*.txt /doc/ && \
    rm -rvf ./ykush-master/ &&\
    export SUDO_FORCE_REMOVE=yes && \
    apt-get remove --purge -y build-essential git wget unzip sudo libusb-1.0-0-dev libudev-dev && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    ykushcmd -h


VOLUME /docker_shares/common

