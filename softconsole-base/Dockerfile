# All dependancies for SoftConsole install and X11-forwarding/VNC

FROM antonkrug/softconsole-base-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV DEBIAN_FRONTEND noninteractive

# One of the ways to use the X11 is:
# docker run --rm -it -e DISPLAY -v $XAUTHORITY:/root/.Xauthority --net=host antonkrug/softconsole-base

#Known openjdk bug https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199 will make /usr/share/man/man1 by hand
#Setting up openjdk-8-jre-headless:amd64 (8u222-b10-1~deb9u1) ...
#update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/rmid to provide /usr/bin/rmid (rmid) in auto mode
#update-alternatives: error: error creating symbolic link '/usr/share/man/man1/rmid.1.gz.dpkg-tmp': No such file or directory

# build-essential(make is needed by softconsole, gcc needed by renode) and few fundamental tools
RUN apt-get update && \
    echo "wireshark-common	wireshark-common/install-setuid	boolean	false" | debconf-set-selections && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y xdg-utils mc net-tools aptitude p7zip-full firefox-esr gedit x11-apps x11vnc xvfb systemd wireshark && \
    apt-get install -y wmctrl xserver-xephyr xnest metacity xvfb && \
    apt-get install -y default-jre default-jdk default-jdk-headless && \
    apt-get install -y pandoc texlive-xetex texlive-fonts-recommended lmodern && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    
    
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd password ~/.vnc/passwd

ENV HOME=/root/

VOLUME /docker_shares/common
