FROM ubuntu:20.04

RUN apt-get -y update \
 && apt-get -y install curl gcc g++ make

ADD source/gcc-10.2.0.tar.xz /usr/local/src/

WORKDIR /usr/local/src/gcc-10.2.0

RUN ./contrib/download_prerequisites

WORKDIR /usr/local/src

RUN mkdir objdir

WORKDIR /usr/local/src/objdir

RUN ../gcc-10.2.0/configure \
 --enable-languages=c,c++ \
 --prefix=/usr/local \
 --target=amd64-unknown-openbsd6.8

RUN make -j2

