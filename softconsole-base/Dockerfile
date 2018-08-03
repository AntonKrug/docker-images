# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM antonkrug/softconsole-base-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>

# build-essential(make is needed by softconsole, gcc needed by renode) and few fundamental tools
RUN apt-get update && \
    apt-get install -y xdg-utils mc net-tools aptitude p7zip-full firefox-esr gedit x11-apps x11vnc xvfb systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    
    
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd password ~/.vnc/passwd

ENV HOME=/root/

VOLUME /docker_shares/common
