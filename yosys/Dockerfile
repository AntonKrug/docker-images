# All dependancies working yosys -> nextpnbr -> icestorm -> ice40 flow

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV HOME=/root/
ENV DEBIAN_FRONTEND noninteractive
# https://stackoverflow.com/questions/53935949
# https://stackoverflow.com/questions/48162574
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DISPLAY=:1


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
    apt-get install -y qt5-default libboost-all-dev libeigen3-dev && \
    apt-get install -y bison flex gawk graphviz xdot pkg-config && \
    apt-get install -y iverilog verilator && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install --no-cache-dir wheel


# additional packages 
RUN apt-get update && \
    apt-get install -y sudo debconf aptitude net-tools systemd && \
    apt-get install -y sudo mc htop screen tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# X11 / vnc stuff - storing weak vnc password
RUN apt-get update && \
    apt-get install -y xdg-utils x11-apps x11vnc xvfb fluxbox xterm gtkwave && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir ~/.vnc && \
    x11vnc -storepasswd password ~/.vnc/passwd 


# Allow wider privileges on new files so they will be easier to delete from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


# Building icestorm
RUN git clone https://github.com/cliffordwolf/icestorm.git && \
    cd icestorm && \
    make -j2 && \
    sudo make install && \
    cd .. && \
    rm -rf icestorm && \
    mkdir -p /etc/udev/rules.d/ && \
    echo "ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6010\", MODE=\"0660\", GROUP=\"plugdev\", TAG+=\"uaccess\"" > /etc/udev/rules.d/53-lattice-ftdi.rules


# Building yosys
RUN git clone https://github.com/cliffordwolf/yosys.git && \
    cd yosys && \
    make config-clang && \
    make -j2 && \
    sudo make install && \
    cd .. && \
    rm -rf yosys


# Building nextpnr
RUN git clone https://github.com/YosysHQ/nextpnr.git && \
    cd nextpnr && \
    cmake -DARCH=ice40 . && \
    make -j2 && \
    sudo make install && \
    cd .. && \
    rm -rf nextpnr


ADD start_vnc_server.sh /bin/start_vnc_server.sh
RUN chmod a+x /bin/start_vnc_server.sh
# docker run --rm -it --net=host antonkrug/yosys bash -c start_vnc_server.sh && xterm

VOLUME /docker_shares/common
