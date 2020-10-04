FROM golang:1.12-stretch
RUN \
    apt update && \
    apt install -y libglib2.0-dev curl make sudo && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt install -y nodejs && \
    useradd -m filestash && \
    adduser filestash sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER filestash
