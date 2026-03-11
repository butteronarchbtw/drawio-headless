FROM debian:latest
ARG TARGETARCH

RUN apt update
RUN apt install -y wget 

WORKDIR /drawio

RUN <<EOF
set -e
drawio_version="29.6.1"
drawio_deb="drawio-${TARGETARCH}-${drawio_version}.deb"
wget -q "https://github.com/jgraph/drawio-desktop/releases/download/v${drawio_version}/${drawio_deb}"
apt install -y ./${drawio_deb}
rm ./${drawio_deb}
EOF

RUN apt install -y xvfb libgbm1 libasound2

COPY drawio-headless drawio-headless

RUN chmod 755 drawio-headless

RUN apt remove -y wget \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
