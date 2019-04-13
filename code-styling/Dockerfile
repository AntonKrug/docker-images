# To run formating and linting tools

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

RUN apt-get update && apt-get install -y clang-format python python-pip && \
    pip install --no-cache-dir cpplint && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /docker_shares/common

