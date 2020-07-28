# Doxygen and sphinx

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

RUN apt-get update && \
    apt-get install -y git build-essential autoconf libxml2-utils cmake python3 python3-sphinx python3-pip flex bison texlive-latex-base texlive-base pandoc wget unzip docbook-xsl xsltproc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install sphinx_tabs sphinxcontrib-svg2pdfconverter && \
    wget https://github.com/asciidoc/asciidoc-py3/releases/download/9.0.2/asciidoc-9.0.2.zip && \
    unzip asciidoc-9.0.2.zip && \
    rm asciidoc-9.0.2.zip && \
    cd asciidoc-9.0.2/ && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -rf asciidoc-9.0.2 && \
    git clone https://github.com/doxygen/doxygen.git && \
    cd doxygen && \
    mkdir build && \
    cd build && \
    cmake -G "Unix Makefiles" .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf doxygen


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


VOLUME /docker_shares/common

