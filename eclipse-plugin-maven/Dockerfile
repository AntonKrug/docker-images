FROM debian:9-slim
MAINTAINER Anton Krug <anton.krug@microchip.com>

ENV HOME=/root/
ENV DEBIAN_FRONTEND noninteractive
# https://stackoverflow.com/questions/53935949
# https://stackoverflow.com/questions/48162574
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV PATH="${PATH}:/opt/apache-maven-3.3.9/bin"
ENV JAVA_HOME=/opt/jdk1.8.0_131/


# wide privileges on new files, they can deleted easily from the mounted volumes
RUN echo "" >> /etc/bash.bashrc && \
    echo "umask 0000" >> /etc/bash.bashrc
    

RUN apt-get update && \
    apt-get -y install wget git unzip dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*    


RUN wget https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    cd /opt && \
    tar xvfz ../apache-maven-3.3.9-bin.tar.gz && \
    cd .. && \
    rm apache-maven-3.3.9-bin.tar.gz


RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz && \
    cd /opt && \
    tar xvfz ../jdk-8u131-linux-x64.tar.gz && \
    cd .. && \
    rm jdk-8u131-linux-x64.tar.gz && \
    update-alternatives --install "/usr/bin/java" "java" "/opt/jdk1.8.0_131/bin/java" 0 && \
    update-alternatives --install "/usr/bin/javac" "java" "/opt/jdk1.8.0_131/bin/javac" 0 && \
    update-alternatives --install "/usr/bin/jar" "java" "/opt/jdk1.8.0_131/bin/jar" 0 
