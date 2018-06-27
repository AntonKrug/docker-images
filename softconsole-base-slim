# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM debian:9.4-slim
MAINTAINER Anton Krug <anton.krgu@microsemi.com>

RUN apt-get update && apt-get install -y build-essential p7zip-full && apt-get clean
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libstdc++6:i386  && apt-get clean

RUN apt-get install -y apt-transport-https dirmngr && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module && \
    apt-get clean

ENV HOME=/root/

VOLUME /docker_shares/common
