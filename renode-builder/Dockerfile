#Dependancies and tools required to build Renode package

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Mono dependancies are needed first as otherwise the next run could end up installing older mono
RUN apt-get update && \
    apt-get install -y apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get all apt dependancies for building the package
RUN apt-get update && \
    apt-get install -y --no-install-recommends git automake autoconf libtool g++ realpath policykit-1 libgtk2.0-dev screen uml-utilities gtk-sharp2 python2.7 && \
    apt-get install -y --no-install-recommends python-pip python-setuptools python-dev ruby ruby-dev build-essential rpm bsdtar && \
    gem install fpm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Robot framework dependancies
RUN python2.7 -m pip install --no-cache-dir robotframework netifaces requests psutil
    
VOLUME /docker_shares/common
