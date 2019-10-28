# All dependancies working yosys -> nextpnbr/arachne -> icestorm -> ice40 flow
# In spirit of Symbiflow

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV HOME=/root/
ENV DEBIAN_FRONTEND noninteractive
# https://stackoverflow.com/questions/53935949
# https://stackoverflow.com/questions/48162574
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV PATH="${PATH}:/usr/local/bin"


# build-essential
RUN apt-get update && \
    apt-get install -y build-essential wget git vim p7zip-full unzip && \
    apt-get install -y cmake clang clang-format clang-tidy clang-tools-7 && \
    apt-get install -y libhidapi-libusb0 libusb-1.0-0-dev libusb-1.0-0 libudev-dev libudev1 && \
    apt-get install -y ftdi-eeprom libftdi-dev libffi-dev libreadline-dev tcl-dev && \   
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    


# nextpnr (and icestorm) dependencies
# https://stackoverflow.com/questions/34819221/
RUN apt-get update && \
    apt-get install -y python3 python3-dev python3-pip && \
    apt-get install -y libboost-all-dev libeigen3-dev && \
    apt-get install -y bison flex gawk pkg-config && \
    apt-get install -y iverilog verilator && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install --no-cache-dir wheel

# additional packages 
RUN apt-get update && \
    apt-get install -y sudo screen tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Allow wider privileges on new files so they will be easier to delete from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


# Building icestorm
RUN git clone https://github.com/cliffordwolf/icestorm.git && \
    cd icestorm && \
    make -j2 && \
    sudo make install && \
    make clean && \
    mkdir -p /etc/udev/rules.d/ && \
    echo "ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6010\", MODE=\"0660\", GROUP=\"plugdev\", TAG+=\"uaccess\"" > /etc/udev/rules.d/53-lattice-ftdi.rules


# Building yosys
RUN git clone https://github.com/cliffordwolf/yosys.git && \
    cd yosys && \
    make config-clang && \
    make -j2 && \
    sudo make install && \
    make clean


# Building nextpnr without gui
RUN git clone https://github.com/YosysHQ/nextpnr.git && \
    cd nextpnr && \
    cmake -DARCH=ice40 -DBUILD_GUI=OFF . && \
    make -j2 && \
    sudo make install && \
    make clean


# Getting the icotools (icezero example, SoC example)
RUN git clone https://github.com/cliffordwolf/icotools.git


# Building arachne, the older place&route arachne-pnr
RUN git clone https://github.com/cseed/arachne-pnr.git arachne-pnr && \
    cd arachne-pnr && \
    make -j$(nproc) && \
    sudo make install && \
    make clean


VOLUME /docker_shares/common
