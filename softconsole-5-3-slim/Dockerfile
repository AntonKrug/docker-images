# SoftConsole 5.3 preinstalled

FROM antonkrug/softconsole-base-slim
MAINTAINER Anton Krug <anton.krgu@microsemi.com>

ENV SOFTCONSOLE_FULL_CAPTURE scLinux-5.3.0.30-20180629-171539

RUN mkdir -p /opt/microsemi/imported_projects && \
    cd /opt/microsemi && \
    wget -q ftp://$SOFTCONSOLE_INTRANET_BASE_URL/$SOFTCONSOLE_FULL_CAPTURE.7z && \
    7za x $SOFTCONSOLE_FULL_CAPTURE.7z && \
    rm $SOFTCONSOLE_FULL_CAPTURE.7z && \
    ln -s /opt/microsemi/$SOFTCONSOLE_FULL_CAPTURE /opt/microsemi/softconsole && \
    chmod -R a+rw /opt/*

# Uninstall CppChekclipse as at the moment it's not compatible in headless mode
RUN cd /opt/microsemi/softconsole/eclipse && \
    ./eclipse -application org.eclipse.equinox.p2.director -profile SDKProfile -noSplash -roaming -uninstallIU com.googlecode.cppcheclipse.feature.feature.group
    

ENV SWT_GTK3=0
ENV SC_INSTALL_DIR=/opt/microsemi/softconsole
ENV LD_LIBRARY_PATH="/opt/microsemi/softconsole/openocd/bin:$LD_LIBRARY_PATH"
ENV RENODE_BINARY_LAUNCHER=/usr/bin/mono
ENV RENODE_BINARY_ARGUMENT=/opt/microsemi/softconsole/renode/bin/Renode.exe
ENV PATH="/opt/microsemi/softconsole:/opt/microsemi/softconsole/eclipse:/opt/microsemi/softconsole/arm-none-eabi-gcc/bin:/opt/microsemi/softconsole/riscv-unknown-elf-gcc/bin:$PATH"

VOLUME /docker_shares/common
