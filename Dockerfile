FROM registry.forge.inrae.fr/teledec/ubuntu-qgis-vnc:latest-chromium

USER root

# Install uv (latest)
RUN wget -qO- https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" UV_NO_MODIFY_PATH=1 sh

# Ensure Miniforge is on PATH for all users
ENV PATH="/opt/conda/bin:${PATH}"

# Use the repo's Onyxia init script
RUN wget https://github.com/d-chambers/ubuntu-vnc/blob/main/onyxia-init.sh -O /opt/onyxia-init.sh
RUN chmod +x /opt/onyxia-init.sh

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
