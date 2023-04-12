FROM cruizba/ubuntu-dind

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
RUN add-apt-repository ppa:saiarcot895/chromium-dev
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y git
RUN DEBIAN_FRONTEND=noninteractive apt install -y openjdk-17-jdk
RUN DEBIAN_FRONTEND=noninteractive apt install -y coreutils
RUN DEBIAN_FRONTEND=noninteractive apt install -y jq
RUN DEBIAN_FRONTEND=noninteractive apt install -y chromium-browser
RUN DEBIAN_FRONTEND=noninteractive apt install -y build-essential
RUN curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
RUN wget https://github.com/mikefarah/yq/releases/download/v4.25.1/yq_linux_amd64.tar.gz -O - | tar xz && mv yq_linux_amd64 /usr/bin/yq
RUN wget https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz -O - | tar xz && mv linux-amd64/helm /usr/bin/helm
RUN chmod +x /usr/bin/yq
RUN chmod +x /usr/bin/helm
RUN helm plugin install https://github.com/chartmuseum/helm-push
RUN curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl && mkdir -p ~/.local/bin && mv ./kubectl ~/.local/bin/kubectl
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV PATH=$PATH:/usr/local/go/bin
ENV PATH=$PATH:~/.local/bin
COPY docker-utils.sh /opt/
COPY docker-entrypoint.sh /usr/local/bin/
COPY dockerd-entrypoint.sh /usr/local/bin/
COPY concourse-dind-entrypoint.sh /usr/local/bin/
COPY startup.sh /usr/local/bin/

ENTRYPOINT ["/bin/bash"]
CMD ["bash"]