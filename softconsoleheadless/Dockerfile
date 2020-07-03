# SoftConsole preinstalled
FROM $SC_BASE_IMAGE
MAINTAINER Anton Krug <anton.krug@microchip.com>
ENV SC_INSTALL_DIR=/opt/microsemi/softconsole

# Create dedicate folder for extracting projects temporary and being ready for imports
RUN mkdir -p /opt/microsemi/imported_projects

# Copy softconsole partially, do not use COPY command as in older docker only ADD supported
# it could be done quickly with "ADD scLinux*.zip /opt/microsemi/" and "unzip scLinux*.zip && \" but that would create one large layer
# adding smaller parts will cause multiple separate layers which are smaller and only layers which changed
# will be re-cached, the common layers can be re-used, saving diskspace, network bandwith, speeding up downloads etc...
ADD scLinux*/arm-none-eabi-gcc $SC_INSTALL_DIR/arm-none-eabi-gcc/
ADD scLinux*/CMSIS $SC_INSTALL_DIR/CMSIS/
ADD scLinux*/documentation $SC_INSTALL_DIR/documentation/
ADD scLinux*/notices $SC_INSTALL_DIR/notices/
ADD scLinux*/eclipse $SC_INSTALL_DIR/eclipse/
ADD scLinux*/SoftConsole.xpm scLinux*/softconsole.sh $SC_INSTALL_DIR/
ADD scLinux*/extras $SC_INSTALL_DIR/extras/
ADD scLinux*/openocd $SC_INSTALL_DIR/openocd/
ADD scLinux*/gdbinit $SC_INSTALL_DIR/gdbinit/
ADD scLinux*/fpServer $SC_INSTALL_DIR/fpServer/
ADD scLinux*/riscv-unknown-elf-gcc $SC_INSTALL_DIR/riscv-unknown-elf-gcc/
ADD scLinux*/renode $SC_INSTALL_DIR/renode/
ADD scLinux*/renode-microchip-mods $SC_INSTALL_DIR/renode-microchip-mods

RUN ls -la $SC_INSTALL_DIR/

# Uninstall CppChekclipse as at the moment it's not compatible in headless mode
RUN cd $SC_INSTALL_DIR/eclipse && \
    ./eclipse -application org.eclipse.equinox.p2.director -profile SDKProfile -noSplash -roaming -uninstallIU com.googlecode.cppcheclipse.feature.feature.group && \
    chmod -R a+rw /opt/*    


ENV SWT_GTK3=0
ENV LD_LIBRARY_PATH="$SC_INSTALL_DIR/openocd/bin:$LD_LIBRARY_PATH"
ENV RENODE_BINARY_LAUNCHER=/usr/bin/mono
ENV RENODE_BINARY_ARGUMENT=$SC_INSTALL_DIR/renode/bin/Renode.exe

ENV OS_BINARY_EXTENSION=""
ENV EAD_BINARY=$SC_INSTALL_DIR/extras/ead/ead
ENV UST_RESOURCES=$SC_INSTALL_DIR/ultrasoc/share

# Python and JAVA
ENV PYTHONPATH=$SC_INSTALL_DIR/python3
ENV MACRO_PYTHON_BINARY_PATH=$SC_INSTALL_DIR/python3/bin
ENV MACRO_PYTHON_BINARY_EXECUTABLE=python3
ENV MACRO_PYTHON_BINARY_PATH_AND_EXECUTABLE=$SC_INSTALL_DIR/python3/bin/python3
ENV JAVA_HOME=$SC_INSTALL_DIR/eclipse/jre/
ENV MACRO_EXECUTABLE_EXTENSION=""

ENV PATH_ADDON=$SC_INSTALL_DIR:$MACRO_PYTHON_BINARY_PATH:$SC_INSTALL_DIR/eclipse/jre/bin:$SC_INSTALL_DIR/eclipse:$SC_INSTALL_DIR/arm-none-eabi-gcc/bin:$SC_INSTALL_DIR/riscv-unknown-elf-gcc/bin
ENV PATH="$PATH_ADDON:$PATH"

VOLUME /docker_shares/common
