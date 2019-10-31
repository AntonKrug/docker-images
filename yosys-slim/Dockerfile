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


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


# getting base depedencies except the clang as that one is large
RUN apt-get update && \
    apt-get install -y build-essential wget git vim p7zip-full unzip cmake  && \
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
    python3 -m pip install --no-cache-dir wheel && \
    pip install pytrellis

# additional packages 
RUN apt-get update && \
    apt-get install -y sudo screen tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Allow wider privileges on new files so they will be easier to delete from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc

# adding clang, getting all the tools, building them and then removing clang to keep the container
RUN apt-get update && \
    apt-get install -y clang clang-format clang-tidy clang-tools-7 && \
    echo "Building icestorm" && \
    git clone https://github.com/cliffordwolf/icestorm.git && \
    cd icestorm && \
    make -j2 && \
    make install && \
    mkdir -p /etc/udev/rules.d/ && \
    echo "ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6010\", MODE=\"0660\", GROUP=\"plugdev\", TAG+=\"uaccess\"" > /etc/udev/rules.d/53-lattice-ftdi.rules && \
    cd .. && \
    rm -rf icestorm && \
    echo "Building yosys" && \
    git clone https://github.com/cliffordwolf/yosys.git && \
    cd yosys && \
    make config-clang && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf yosys && \
    echo "Building nextpnr without gui" && \
    git clone https://github.com/YosysHQ/nextpnr.git && \
    cd nextpnr && \
    cmake -DARCH=all -DBUILD_GUI=OFF . && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf nextpnr && \
    echo "Building arachne, the older place&route package" && \
    git clone https://github.com/cseed/arachne-pnr.git arachne-pnr && \
    cd arachne-pnr && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf arachne-pnr && \
    apt-get remove -y --purge clang clang-format clang-tidy clang-tools-7 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


VOLUME /docker_shares/common
