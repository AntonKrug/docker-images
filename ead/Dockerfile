# To build mingw projects which use fairly new cmake

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

RUN apt-get update && apt-get install -y wget && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -nv --no-check-certificate https://github.com/AntonKrug/ead/releases/download/v0.5.7/ead-linux-x86-64-20190723-163730 -O /bin/ead

VOLUME /docker_shares/common

