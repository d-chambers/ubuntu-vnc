FROM registry.forge.inrae.fr/teledec/ubuntu-qgis-vnc:latest-chromium

USER root

# Get Onyxia init script
RUN wget https://raw.githubusercontent.com/InseeFrLab/images-datascience/refs/heads/main/base/scripts/onyxia-init.sh -O /opt/onyxia-init.sh && \
    chmod +x /opt/onyxia-init.sh

## Allow sudo without password
RUN echo "headless     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Remove desktop shortcut 
RUN rm /home/headless/Desktop/versionsticker.desktop

## Full size by default
RUN sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/libexec/noVNCdim/app/ui.js

# Keep the connection alive to prevent timeouts
ENV NOVNC_HEARTBEAT=30

USER headless

WORKDIR /home/headless/work

