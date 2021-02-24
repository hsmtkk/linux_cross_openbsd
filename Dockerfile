FROM ubuntu:20.04 AS builder

RUN apt-get -y update \
 && apt-get -y install curl gcc g++ make

ADD vendor/binutils-2.36.1.tar.xz /usr/local/src
ADD vendor/gcc-10.2.0.tar.xz /usr/local/src/
ADD vendor/base68.tgz /opt
ADD vendor/comp.tgz /opt

WORKDIR /usr/local/src/binutils-2.36.1

RUN ./configure \
 --prefix=/opt \
 --target=amd64-unknown-openbsd6.8

RUN make -j8

RUN make install

WORKDIR /usr/local/src/gcc-10.2.0

RUN ./contrib/download_prerequisites \
 && mkdir /usr/local/src/objdir

WORKDIR /usr/local/src/objdir

RUN ../gcc-10.2.0/configure \
 --disable-multilib \
 --enable-languages=c,c++ \
 --prefix=/opt \
 --target=amd64-unknown-openbsd6.8 \
 --with-sysroot=/opt

RUN make -j8

RUN make

RUN make install

FROM ubuntu:20.04

COPY --from=builder /opt /opt

