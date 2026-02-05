FROM registry.forge.inrae.fr/teledec/ubuntu-qgis-vnc:latest-chromium

USER root

# Get Onyxia init script
RUN wget https://raw.githubusercontent.com/InseeFrLab/images-datascience/refs/heads/main/base/scripts/onyxia-init.sh -O /opt/onyxia-init.sh && \
    chmod +x /opt/onyxia-init.sh

# Installing mc
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# Installing vault
RUN cd /usr/bin && \
    wget https://releases.hashicorp.com/vault/1.8.2/vault_1.8.2_linux_amd64.zip && \
    unzip vault_1.8.2_linux_amd64.zip && \
    rm vault_1.8.2_linux_amd64.zip
RUN vault -autocomplete-install

# Installing kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Installing helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

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

