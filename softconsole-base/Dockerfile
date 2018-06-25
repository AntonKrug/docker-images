# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM debian:9.4-slim
MAINTAINER Anton Krug <anton.krgu@microsemi.com>

RUN apt-get update && apt-get install -y build-essential xdg-utils wget vim mc net-tools aptitude p7zip-full firefox-esr gedit x11-apps x11vnc xvfb

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libstdc++6:i386

RUN apt-get install -y apt-transport-https dirmngr
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update
RUN apt-get install -y mono-complete gtk-sharp2 libcanberra-gtk-module

RUN apt-get clean

RUN mkdir ~/.vnc
RUN x11vnc -storepasswd password ~/.vnc/passwd

CMD ["export", "HOME=/root/"]

VOLUME /docker_shares/common
