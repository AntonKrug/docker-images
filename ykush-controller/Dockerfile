# Access ykush USB controller from distributions which have trouble to compile the tool

FROM ubuntu:16.04
MAINTAINER Anton Krug <anton.krug@microsemi.com>


# Get all dependancies
RUN apt-get update && \
    apt-get install -y build-essential git wget unzip sudo libusb-1.0-0-dev libusb-1.0-0 libudev-dev libudev1 && \
    apt-get clean 


# Download and extract sources
RUN wget https://www.yepkit.com/uploads/documents/68548_ykushcmd_master_20171130.zip && \
    unzip *.zip && \
    rm *.zip


# Compile the project
RUN cd ykush-master && \
    ./build.sh ; \
    ./install.sh ; \
    mkdir -p /doc && \
    cp *.txt /doc/


VOLUME /docker_shares/common

