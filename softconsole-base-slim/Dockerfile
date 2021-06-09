# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV HOME=/root/

# Fixing apt-key no tty issue:
# https://stackoverflow.com/questions/53935949/apt-key-fails-recently-inside-docker
# https://stackoverflow.com/questions/48162574/how-to-circumvent-apt-key-output-should-not-be-parsed
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# build-essential(make is needed by softconsole, gcc needed by renode) and few fundamental tools
RUN apt-get update && \
    apt-get install -y build-essential wget git vim p7zip-full unzip curl dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    

# fPServer dependancies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libstdc++6:i386  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
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

# SSH server so the container can be accessed from outside interactively. And NodeJS to build SSH client
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/bin && \
    cd /opt && \
    wget https://nodejs.org/dist/v14.17.0/node-v14.17.0-linux-x64.tar.xz && \
    tar vxf node-v14.17.0-linux-x64.tar.xz && \
    rm node-*.tar.xz && \
    cd bin && \
    ln -s ../node-v14.17.0-linux-x64/bin/npm npm && \
    ln -s ../node-v14.17.0-linux-x64/bin/npx npx && \
    ln -s ../node-v14.17.0-linux-x64/bin/node node

# Setting timezone with using the json/exec form https://docs.docker.com/engine/reference/builder/
# To solve problem with regular shell when redirection is used:
# https://stackoverflow.com/questions/2462317/bash-syntax-error-redirection-unexpected
RUN ["/bin/bash", "-c", "debconf-set-selections <<< \"tzdata tzdata/Areas select Europe\" && \
                         debconf-set-selections <<< \"tzdata tzdata/Zones/Europe select Dublin\" "]

# Timezone database
RUN apt-get update && \
    apt-get install -y tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Robot framework dependancies
RUN python2.7 -m pip install --no-cache-dir robotframework netifaces requests psutil    

# Solving https://stackoverflow.com/questions/34819221/why-is-python-setup-py-saying-invalid-command-bdist-wheel-on-travis-ci
RUN python2.7 -m pip install --no-cache-dir wheel

# Additional Robot framework plugins
RUN python2.7 -m pip install --no-cache-dir robotframework-seriallibrary robotframework-datadriver

# Adding HSS dependencies
RUN python2.7 -m pip install --no-cache-dir kconfiglib

# This container has already root access (without sudo), but this for scripts which assume the sudo is installed
RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo debconf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

    
# Allow wider privileges on new files so they will be easier to delete, in case 
# they will be created by wrong user on a mounted volume
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc

VOLUME /docker_shares/common
