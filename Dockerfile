#################
# Security Tools Container

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    curl \
    wget \
    zsh \
    nano \
    python3 \
    python3-pip \
    python3-dev \
    golang-go \
    john \
    hashcat \
    dirb \
    p7zip-full \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_linux_amd64.tar.gz \
    && wget -q https://github.com/OJ/gobuster/releases/download/v3.6.0/gobuster_Linux_x86_64.tar.gz \
    && tar -xzf ffuf_2.1.0_linux_amd64.tar.gz \
    && tar -xzf gobuster_Linux_x86_64.tar.gz \
    && mv ffuf gobuster /usr/local/bin/ \
    && chmod +x /usr/local/bin/ffuf /usr/local/bin/gobuster \
    && rm *.tar.gz

RUN python3 -m pip install --no-cache-dir --upgrade pip==24.0 setuptools --break-system-packages \
    && python3 -m pip install --no-cache-dir wfuzz --break-system-packages

RUN mkdir -p /usr/share/wordlists && \
    printf '%s\n' admin administrator login dashboard panel config content uploads images js css api backup test dev staging data files media assets static public private secret hidden temp tmp cache logs db database wp-admin wp-content phpmyadmin .git .env robots.txt sitemap.xml index home about contact > /usr/share/wordlists/web-common.txt && \
    printf '%s\n' liamup2u password 123456 admin root 12345678 qwerty password123 admin123 letmein welcome monkey 1234567890 abc123 password1 iloveyou sunshine master trustno1 dragon baseball football shadow superman qazwsx michael jennifer hunter buster soccer harley batman andrew tigger charlie robert thomas jordan ranger dandelion liverpool ashley > /usr/share/wordlists/passwords.txt && \
    ln -s /usr/share/wordlists/web-common.txt /usr/share/wordlists/common.txt && \
    ln -s /usr/share/wordlists/web-common.txt /usr/share/wordlists/medium.txt && \
    ln -s /usr/share/wordlists/passwords.txt /usr/share/wordlists/rockyou.txt

RUN echo 'PROMPT="%B%F{red}[SECURITY]%f%b %~ %# "' > /root/.zshrc && \
    echo 'alias ll="ls -lah"' >> /root/.zshrc && \
    echo 'alias fuzz="ffuf -c"' >> /root/.zshrc

RUN mkdir -p /home/security/work

WORKDIR /home/security/work

ENV DEBIAN_FRONTEND=dialog

LABEL maintainer="Security Tools Container" \
      version="1.0.0"