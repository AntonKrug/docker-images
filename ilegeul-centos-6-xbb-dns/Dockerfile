
FROM ilegeul/centos:6-xbb-v2.2
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Using Liviu Ionescu's docker image, which are used to build portable binaries
# of Arm, RISC-V toolchains, Arm QEMU and OpenOCD. 
#
# https://xpack.github.io/arm-none-eabi-gcc/
# https://xpack.github.io/riscv-none-embed-gcc/
# https://xpack.github.io/qemu-arm/
# https://xpack.github.io/openocd/
# 
# Due to Microchip's IT infrastructure constrains, the DNS will not get resolved
# and fetching sources of the projects will fail. This container take's the base 
# container and changes DNS resolv so they will work from whitin Microchip's 
# network.
#
# Note: This is a 64-bit container, for 32-bit there ilegeul/centos32:6-xbb-v2.2

RUN echo "nameserver 10.204.34.11" > /etc/resolv.conf 

# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    


VOLUME /docker_shares/common
