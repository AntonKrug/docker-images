# Background

This repository contains handful of containers handful for various tasks. The binary containers are deployed to docker.hub repository: 

https://hub.docker.com/u/antonkrug

The containers are tagged automatically with the commit hash that triggered their build, making sure that automatically all containers are unique, easy to identify (match to the coresponding commit in Dockerfile) and done in completely autonomous manner.

# Containers

The following containers are used for the following:
 
 - **documentation-builders-ng** To generate SoftConsole (and related) documentation and deploy it to ReadTheDocs or GitHub pages. Compared to the previous **documentation-builders** containers, these are python3 based instead of python2. It can be used on documentation for a whole project and also quickly applied on single file readme's to generate single page self-contained HTMLs/PDFs

 - **ead** A tool which can apply hexdumps in bulk and produce C/H files for easy integration with C projects

 - **eclipse-plugin-maven** Consitent maven 3.3.9 enviroment to build Eclipse plugins

 - **renode-builder** To compile Linux packages of Antmicro's Renode

- **softconsole-base** Bigger version of the **softconsole-base-slim** which contains the x11vnc and xvfb, which allows to run SoftConsole IDE GUI interactively in the container

 - **softconsole-base-slim** A base container for SoftConsole headleass builder container. This softconsole-base-slim container + SoftConsole IDE installation produces the headless containers deployed here:
  https://hub.docker.com/r/microsemiproess/softconsole-headless-slim/tags?page=1&ordering=last_updated


 - **ykush-controller-slim** Controler software to manipulate programmable USB hubs: https://www.yepkit.com/product/300110/YKUSH3
  Useful for RHEL 6.x which couldn't build this tool natively


# Why some packages are included

- dos2unix Set of new-line conversion tools, allowing to have shared outter host scripts with the inner container, yet use different line endings. This could be done on the host side and force encoding for one or the other OS. However the host scripts could be made to work from Linux or from shared Windows drive running WSL with the Docker for Windows (and could be invoked from both Linux and Windows machines). With the dos2unix the newlines can be convereted on each script before invoking it to make sure the new lines are as expected no matter what the host enviroment is.

# Base image and compatibility

The base image on most containers is upto Debian 9, newer base containers is often avoided as they wouldn't have kernel compatible with older RHEL 6.x kernel (and Docker 1.7 which is the latest version avaiable for this platform). By limiting the base images this gurantees compatibility acroos many host OSs (including legacy OSs).