# To build mingw projects which use fairly new cmake

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>


RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y build-essential gcc-multilib g++-multilib libc6-dev-i386 gdb-multiarch gcc-mingw-w64-i686 wget dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN chmod 2777 /opt && \
    wget -nv --no-check-certificate https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.sh -O /tmp/cmake.sh && \
    bash /tmp/cmake.sh --skip-license --prefix=/opt --exclude-subdir && \
    rm /tmp/cmake.sh


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    

VOLUME /docker_shares/common

