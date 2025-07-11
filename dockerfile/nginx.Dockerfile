FROM nginx:latest

USER root

RUN apt update && apt install -y \
    nano \
    apt-utils \
    certbot \
    python3-certbot-nginx \
    ca-certificates && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
