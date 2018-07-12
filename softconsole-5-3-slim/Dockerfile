# SoftConsole 5.3 preinstalled

FROM antonkrug/softconsole-base-slim
MAINTAINER Anton Krug <anton.krug@microsemi.com>

ENV SOFTCONSOLE_FULL_CAPTURE scLinux-5.4.0.0-20180712-120503
ENV SC_INSTALL_DIR=/opt/microsemi/softconsole

RUN mkdir -p /opt/microsemi/imported_projects && \
    cd /opt/microsemi && \
    wget -q ftp://$SOFTCONSOLE_INTRANET_BASE_URL/$SOFTCONSOLE_FULL_CAPTURE.7z && \
    7za x $SOFTCONSOLE_FULL_CAPTURE.7z && \
    rm $SOFTCONSOLE_FULL_CAPTURE.7z && \
    ln -s /opt/microsemi/$SOFTCONSOLE_FULL_CAPTURE $SC_INSTALL_DIR && \
    chmod -R a+rw /opt/*

# Uninstall CppChekclipse as at the moment it's not compatible in headless mode
RUN cd $SC_INSTALL_DIR/eclipse && \
    ./eclipse -application org.eclipse.equinox.p2.director -profile SDKProfile -noSplash -roaming -uninstallIU com.googlecode.cppcheclipse.feature.feature.group && \
    chmod -R a+rw /opt/*
    

ENV SWT_GTK3=0
ENV LD_LIBRARY_PATH="$SC_INSTALL_DIR/openocd/bin:$LD_LIBRARY_PATH"
ENV RENODE_BINARY_LAUNCHER=/usr/bin/mono
ENV RENODE_BINARY_ARGUMENT=$SC_INSTALL_DIR/renode/bin/Renode.exe
ENV PATH_ADDON=$SC_INSTALL_DIR:$SC_INSTALL_DIR/eclipse:$SC_INSTALL_DIR/arm-none-eabi-gcc/bin:$SC_INSTALL_DIR/riscv-unknown-elf-gcc/bin
ENV PATH="$PATH_ADDON:$PATH"

VOLUME /docker_shares/common
