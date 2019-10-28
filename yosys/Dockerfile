# All dependancies working yosys -> nextpnbr -> icestorm -> ice40 flow

FROM FROM antonkrug/yosys-slim:latest
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV DISPLAY=:1


# additional packages 
RUN apt-get update && \
    apt-get install -y debconf aptitude net-tools systemd && \
    apt-get install -y mc htop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# X11 / vnc stuff - storing weak vnc password
RUN apt-get update && \
    apt-get install -y qt5-default graphviz xdot && \
    apt-get install -y xdg-utils x11-apps x11vnc xvfb fluxbox xterm gtkwave && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir ~/.vnc && \
    x11vnc -storepasswd password ~/.vnc/passwd 

# Getting the icotools (icezero example, SoC example)
RUN git clone https://github.com/cliffordwolf/icotools.git


# Building gui variant of nextpnr
RUN apt-get update && \
    apt-get install -y clang clang-format clang-tidy clang-tools-7 && \
    git clone https://github.com/YosysHQ/nextpnr.git && \
    cd nextpnr && \
    cmake -DARCH=ice40 . && \
    make -j2 && \
    sudo make install && \
    cd .. && \
    rm -rf nextpnr && \
    apt-get remove -y --purge clang clang-format clang-tidy clang-tools-7 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ADD start_vnc_server.sh /bin/start_vnc_server.sh
RUN chmod a+x /bin/start_vnc_server.sh
# docker run --rm -it --net=host antonkrug/yosys bash -c "start_vnc_server.sh && xterm"

VOLUME /docker_shares/common
