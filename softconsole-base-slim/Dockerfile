# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>

# build-essential(make is needed by softconsole, gcc needed by renode) and few fundamental tools
RUN apt-get update && \
    apt-get install -y build-essential wget git vim p7zip-full unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    

# fPServer dependancies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libstdc++6:i386  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# Fixing apt-key no tty issue:
# https://stackoverflow.com/questions/53935949/apt-key-fails-recently-inside-docker
# https://stackoverflow.com/questions/48162574/how-to-circumvent-apt-key-output-should-not-be-parsed
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# https://stackoverflow.com/questions/48162574/how-to-circumvent-apt-key-output-should-not-be-parsed
# Renode dependancies
RUN apt-get update && \
    apt-get install -y apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" > /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get all apt dependancies for building the Renode package (if that is needed)
RUN apt-get update && \
    apt-get install -y --no-install-recommends git automake autoconf libtool g++ realpath policykit-1 libgtk2.0-dev screen uml-utilities gtk-sharp2 python2.7 && \
    apt-get install -y --no-install-recommends python-pip python-setuptools python-dev ruby ruby-dev build-essential rpm bsdtar && \
    gem install fpm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Robot framework dependancies
RUN python2.7 -m pip install --no-cache-dir robotframework netifaces requests psutil    

# This container has already root access, but for scripts which assume the sudo is installed
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

    
# Allow wider privileges on new files so they will be easier to delete, in case 
# they will be created by wrong user on a mounted volume
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc


ENV HOME=/root/

VOLUME /docker_shares/common
