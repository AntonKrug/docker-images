# All dependancies for Liber 11.8

FROM centos:6.9
MAINTAINER Anton Krug <anton.krug@microchip.com>

# Basic dependancies
RUN yum install -y info mc git wget vim curl htop joe zip p7zip yum-utils && \
    yum clean packages

# X11 dependancies
RUN yum install -y libcroco-0.6.2-5.el6.x86_64 mesa-libGL-11.0.7-4.el6.x86_64 xorg-x11-apps-7.7-6.el6.x86_64 && \
    yum clean packages

# update the packages
RUN yum -y check-update; \
    yum -y update && \
    yum clean packages

# larger X11 applications
RUN yum install -y firefox && \
    yum clean packages
    

# Libero dependancies
RUN yum -y check-update; \
    yum -y update && \
    yum install -y atk-1.30.0-1.el6.i686 cairo-1.8.8-3.1.el6.i686 compat-expat1-1.95.8-8.el6.i686 \
                   fontconfig-2.8.0-3.el6.i686 freetype-2.3.11-6.el6_1.7.i686 gdk-pixbuf2-2.24.1-6.el6_7.i686 \
                   gtk2-2.24.23-8.el6.i686 glib2-2.22.5-6.el6.i686 libICE-1.0.6-1.el6.i686 \
                   pango-1.28.1-3.el6_0.3.i686 libSM-1.1.0-7.1.el6.i686 libstdc++-4.4.7-17.el6.i686 \
                   libX11-1.3-2.el6.i686 libXau-1.0.6-4.el6.i686 libXcursor-1.1.13-2.el6.i686 \
                   libXdmcp-1.0.3-1.el6.i686 libXext-1.3.1-2.el6.i686 libXfixes-4.0.4-1.el6.i686 \
                   libXinerama-1.1.3-2.1.el6.i686 libXi-1.3-3.el6.i686 openmotif22-2.2.3-19.el6.i686 \
                   libXmu-1.0.5-1.el6.i686 libXp-1.0.2-2.1.el6.i686 libXrandr-1.5.1-1.el6.i686 \
                   libXrender-0.9.10-1.el6.i686 libXt-1.1.4-6.1.el6.i686 zlib-1.2.3-26.el6.i686 glib2.i686 \
                   ksh.x86_64 xorg-x11-fonts-75dpi libcanberra-gtk2.i686 PackageKit-gtk-module.i686 && \
    yum clean packages


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    

VOLUME /docker_shares/common
