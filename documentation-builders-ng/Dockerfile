# Doxygen, sphinx (python3 based), latex, pandoc, asciidoc

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV VENDOR_DIR=/opt/microchip
ENV PATH="${VENDOR_DIR}/bin:${PATH}"

RUN mkdir -p $VENDOR_DIR/bin

ADD footer.html $VENDOR_DIR/
ADD header.html $VENDOR_DIR/
ADD generate_html $VENDOR_DIR/bin/
ADD convert_all_md $VENDOR_DIR/bin/

# Get depedencies
RUN apt-get update && \
    apt-get install -y git build-essential autoconf libxml2-utils cmake flex bison texlive-full pandoc curl wget unzip docbook-xsl xsltproc tree && \
    apt-get install -y python3 python3-pip && \
    apt-get install -y graphviz libffi-dev libffi6 dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Sphinx related extensions and themes (upgrading to newer sphinx)
RUN python3 -m pip install --upgrade docutils sphinx pyyaml requests formic2 && \
    python3 -m pip install --upgrade sphinx_tabs sphinxcontrib-svg2pdfconverter myst-parser sphinxcontrib-wavedrom sphinx-panels sphinx-jinja sphinx-copybutton && \
    python3 -m pip install --upgrade sphinx_ops_theme sphinx_pdj_theme sphinx-rtd-theme wild_sphinx_theme pydata-sphinx-theme && \
    python3 -m pip install --upgrade sphinx-documatt-theme guzzle_sphinx_theme sphinx_bootstrap_theme && \
    python3 -m pip install --upgrade livereload livehtml

# Get nodejs for the wavedrom-cli
RUN apt-get update && \
    curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \    
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get the CLI wavedrom, not just the python wavedrom
RUN npm -g config set user root && \
    npm install wavedrom-cli --global && \
    wavedrom-cli --version

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
RUN chmod a+x $VENDOR_DIR/bin/convert_all_md

VOLUME /docker_shares/common

