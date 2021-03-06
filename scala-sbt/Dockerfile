# Scala and sbt tools on to of full yosys
FROM antonkrug/yosys:latest
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


# getting java jdk 8
# https://stackoverflow.com/questions/6784463
RUN apt-get update && \
    apt-get install -y software-properties-common sudo apt-transport-https ca-certificates dos2unix && \
    mkdir -p /usr/share/man/man1/ && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    update-alternatives --config java && \
    update-alternatives --config javac && \
    update-ca-certificates -f && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    


# scala-sbt - https://www.scala-sbt.org/
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -y sbt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    


# verilator, clone/build from repo as apt will give older version
RUN apt-get update && \
    apt-get install -y git make autoconf g++ flex bison && \
    git clone http://git.veripool.org/git/verilator && \
    unset VERILATOR_ROOT && \
    cd verilator && \
    git pull && \
    git checkout verilator_3_918 && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf verilator && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 


# Building and installing SpinalHDL's OpenOCD
RUN apt-get update && \
    apt-get install -y libtool automake libusb-1.0.0-dev texinfo libusb-dev libyaml-dev pkg-config && \
    git clone https://github.com/SpinalHDL/openocd_riscv.git && \
    cd openocd_riscv && \
    ./bootstrap && \
    ./configure --enable-ftdi --enable-dummy && \
    make && \
    make install && \
    cd .. && \
    rm -rf openocd_riscv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 


VOLUME /docker_shares/common
