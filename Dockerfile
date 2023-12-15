FROM debian:bookworm

RUN apt update && apt install -y build-essential git wget
RUN echo 'deb-src http://deb.debian.org/debian/ bookworm main' >> /etc/apt/sources.list
RUN apt update && apt build-dep -y gcc
RUN mkdir -p /gcc && cd /gcc && git init &&\
    git remote add origin https://github.com/gcc-mirror/gcc &&\
    git fetch --depth=1 origin 97094d2ffd7d00261e6d7cc5d4a62dc7c2c89b64
RUN cd /gcc &&\
    git checkout 97094d2ffd7d00261e6d7cc5d4a62dc7c2c89b64
RUN cd /gcc &&\
    ./contrib/download_prerequisites
RUN cd /gcc &&\
    ./configure --prefix=/gcc-bin --enable-languages=c --disable-bootstrap --disable-multilib &&\
    make --jobs=$(nproc) &&\
    make install
