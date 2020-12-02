# sphinx (python3 based with more extensions)

FROM debian:10-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Get depedencies
RUN apt-get update && \
    apt-get install -y flex bison texlive-full docbook-xsl xsltproc && \
    apt-get install -y python3 python3-sphinx python3-pip python3-requests && \
    apt-get install -y graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install sphinx_tabs sphinxcontrib-svg2pdfconverter myst-parser sphinxcontrib-wavedrom mkdocs && \
    python3 -m pip install sphinx_ops_theme sphinx_pdj_theme git+https://github.com/bashtage/sphinx-material.git sphinx-rtd-theme wild_sphinx_theme sphinx-panels pydata-sphinx-theme sphinx-book-theme

# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc

VOLUME /docker_shares/common

