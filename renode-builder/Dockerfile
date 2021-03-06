#Dependancies and tools required to build Renode package

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Fixing apt-key no tty issue:
# https://stackoverflow.com/questions/53935949/apt-key-fails-recently-inside-docker
# https://stackoverflow.com/questions/48162574/how-to-circumvent-apt-key-output-should-not-be-parsed
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# Mono dependancies are needed first as otherwise the next run could end up 
# installing older mono
RUN apt-get update && \
    apt-get install -y apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF  && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" > /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get all apt dependancies for building the package
RUN apt-get update && \
    apt-get install -y --no-install-recommends git automake autoconf libtool g++ realpath policykit-1 libgtk2.0-dev screen uml-utilities gtk-sharp2 python3 && \
    apt-get install -y --no-install-recommends python3-pip python3-setuptools python3-dev ruby ruby-dev build-essential rpm bsdtar && \
    gem install fpm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Misc tools (to compress the sources and upload them)
RUN apt-get update && \
    apt-get install -y p7zip-full curl zip dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Robot framework dependancies
RUN python3 -m pip install --no-cache-dir robotframework netifaces requests psutil


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    
    
VOLUME /docker_shares/common
