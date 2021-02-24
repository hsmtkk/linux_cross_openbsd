#!/bin/sh
DOCKER_BUILDKIT=1 BUILD_PROGRESS=plain docker build -t hsmtkk/linux_cross_openbsd .
