# Litex migen, based on scala-sbt which contains x11, yosys ...
FROM antonkrug/scala-sbt
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV PATH="${PATH}:/opt/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14/bin/"


# https://github.com/enjoy-digital/litex
RUN cd /opt && \
    wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py && \
    chmod +x litex_setup.py && \
    ./litex_setup.py init install

RUN cd /opt && \
    wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz && \
    tar -xvf riscv64-unknown-elf-gcc-8.1.0-2019.01.0-x86_64-linux-ubuntu14.tar.gz && \
    rm riscv64-*.tar.gz


VOLUME /docker_shares/common
