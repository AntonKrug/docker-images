# To build mingw projects which use fairly new cmake

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

RUN apt-get update && apt-get install -y clang-format python python-pip python-clan-3.8 && \
    pip install cppstyle && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /docker_shares/common

