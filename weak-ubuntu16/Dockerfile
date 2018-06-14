# docker run --name ubuntu16ssh -v /docker_shares/ubuntu16:/docker_shares/export_to_host -it antonkrug/weak-ubuntu16:latest
# It's very weak container, do not use anywhere

FROM ubuntu:16.04
MAINTAINER Anton Krug <anton.krgu@microsemi.com>

RUN apt-get update && apt-get install -y openssh-server sudo whois p7zip
RUN useradd -m -p DA7i7c8mpufJs -s /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

VOLUME /docker_shares/common

CMD ["/etc/init.d/ssh", "start"]
