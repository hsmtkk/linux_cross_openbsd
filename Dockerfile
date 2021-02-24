FROM ubuntu:20.04 AS builder

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install curl gcc g++ make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD vendor/binutils-2.36.1.tar.xz /usr/local/src
ADD vendor/gcc-10.2.0.tar.xz /usr/local/src/
ADD vendor/base68.tgz /opt
ADD vendor/comp68.tgz /opt

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

COPY patch/gcc/config/t-openbsd /usr/local/src/gcc-10.2.0/gcc/config/t-openbsd

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

