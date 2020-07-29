# Doxygen, sphinx (python3 based), latex, pandoc, asciidoc

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV VENDOR_DIR=/opt/microchip
ENV PATH="${VENDOR_DIR}/bin:${PATH}"

RUN mkdir -p $VENDOR_DIR/bin

ADD footer.html $VENDOR_DIR/
ADD header.html $VENDOR_DIR/
ADD generate_html $VENDOR_DIR/bin/

# Get depedencies
RUN apt-get update && \
    apt-get install -y git build-essential autoconf libxml2-utils cmake python3 python3-sphinx python3-pip flex bison texlive-latex-base texlive-base pandoc wget unzip docbook-xsl xsltproc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install sphinx_tabs sphinxcontrib-svg2pdfconverter

# Build asciidoc    
RUN wget https://github.com/asciidoc/asciidoc-py3/releases/download/9.0.2/asciidoc-9.0.2.zip && \
    unzip asciidoc-9.0.2.zip && \
    rm asciidoc-9.0.2.zip && \
    cd asciidoc-9.0.2/ && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -rf asciidoc-9.0.2

# Build doxygen
RUN git clone https://github.com/doxygen/doxygen.git && \
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

RUN chmod a+x $VENDOR_DIR/bin/generate_html

VOLUME /docker_shares/common
