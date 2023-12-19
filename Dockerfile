FROM docker.io/debian:bookworm

ARG revision="revision_should_be_set"

RUN apt update && apt install -y build-essential git wget bison flex bash-completion neovim coreutils
RUN echo 'deb-src http://deb.debian.org/debian/ bookworm main' >> /etc/apt/sources.list
RUN apt update && apt build-dep -y gcc
## https://gcc.gnu.org/install/test.html
RUN apt update && apt install -y dejagnu expect tcl python3 python3-pytest autogen
RUN mkdir -p /gcc &&\
    cd /gcc &&\
    git init &&\
    git remote add origin https://github.com/gcc-mirror/gcc &&\
    git fetch --depth=1 origin $revision &&\
    git checkout $revision &&\
    ./contrib/download_prerequisites &&\
    ./configure --prefix=/gcc-bin --enable-languages=c,c++ --disable-bootstrap --disable-multilib &&\
    make --jobs=$(nproc) &&\
    make install
ENV PATH=/gcc-bin/bin:${PATH}
#RUN cd /gcc &&\
#    make check -j$(nproc) 2>&1 | tee check.log
