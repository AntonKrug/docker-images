# Slim version to access ykush USB controller

FROM antonkrug/ykush-controller
MAINTAINER Anton Krug <anton.krug@microsemi.com>


# Remove build dependancies
RUN export SUDO_FORCE_REMOVE=yes && \
    apt-get remove --purge -y build-essential git wget unzip sudo


# Remove source 
RUN rm -rvf ./ykush-master/


VOLUME /docker_shares/common

