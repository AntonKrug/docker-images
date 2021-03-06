# sphinx (python3 based with more extensions)

FROM debian:10-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Get depedencies
RUN apt-get update && \
    apt-get install -y flex curl git bison texlive-full docbook-xsl xsltproc tree dos2unix && \
    apt-get install -y python3 python3-pip && \
    apt-get install -y graphviz && \
    curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \    
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install --upgrade docutils sphinx pyyaml requests formic2 gitpython pyOpenSSL && \
    python3 -m pip install --upgrade sphinx_tabs sphinxcontrib-svg2pdfconverter myst-parser sphinxcontrib-wavedrom sphinx-panels sphinx-jinja sphinx-copybutton sphinx-charts sphinx-multiversion readthedocs-sphinx-search && \
    python3 -m pip install --upgrade sphinx_ops_theme sphinx_pdj_theme sphinx-rtd-theme wild_sphinx_theme pydata-sphinx-theme && \
    python3 -m pip install --upgrade git+https://github.com/bashtage/sphinx-material.git sphinx-book-theme sphinx-documatt-theme guzzle_sphinx_theme sphinx_bootstrap_theme && \
    npm -g config set user root && \
    npm install wavedrom-cli --global && \
    wavedrom-cli --version

# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc

VOLUME /docker_shares/common

