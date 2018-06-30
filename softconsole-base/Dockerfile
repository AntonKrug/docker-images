# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM debian:9.4
MAINTAINER Anton Krug <anton.krgu@microsemi.com>

# build-essential(make is needed by softconsole, gcc needed by renode) and few fundamental tools
RUN apt-get update && \
    apt-get install -y build-essential xdg-utils wget git vim mc net-tools aptitude p7zip-full firefox-esr gedit x11-apps x11vnc xvfb systemd && \
    apt-get clean    

# fPServer dependancies
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libstdc++6:i386 && apt-get clean

# Renode dependancies
RUN apt-get install -y apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module && \
    apt-get clean

# Allow wider privileges on new files so they will be easier to delete, in case they will be created by wrong user on a mounted volume
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0022" >> /etc/bash.bashrc
    
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd password ~/.vnc/passwd

ENV HOME=/root/

VOLUME /docker_shares/common
