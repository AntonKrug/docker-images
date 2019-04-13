# Doxygen and sphinx

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

RUN apt-get update && apt-get install -y git build-essential cmake python python-sphinx flex bison texlive-latex-base texlive-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/doxygen/doxygen.git && \
    cd doxygen && \
    mkdir build && \
    cd build && \
    cmake -G "Unix Makefiles" .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf doxygen

VOLUME /docker_shares/common

