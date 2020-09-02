#!/bin/bash -e
#### Install latest librdkafka, right from the GIT repo.

### Define the version of kafka we are pinning to.
kafka_version=1.5.0
path__kafka_tarfile="v${kafka_version}.tar.gz"
path__kafka_build_directory="librdkafka-${kafka_version}"

### Install librdkafka
## Install user dependencies
apk add --no-cache libressl-dev
apk add --no-cache cyrus-sasl-dev
apk add --no-cache zstd-dev
apk add --no-cache zlib-dev

## Install developer dependencies
apk add -t kafka-installer --no-cache curl
apk add -t kafka-installer --no-cache make
apk add -t kafka-installer --no-cache gcc
apk add -t kafka-installer --no-cache g++

## Fetch librdkafka from github
curl -LO "https://github.com/edenhill/librdkafka/archive/v${kafka_version}.tar.gz"
tar zxf "${path__kafka_tarfile}"
pushd "${path__kafka_build_directory}"

## Actually build and install librdkafka
./configure --install-deps
make -j
make install

## Remove the build directory
popd
rm -f "${path__kafka_tarfile}"
rm -rf "${path__kafka_build_directory}"

## Install the confluent kafka python library
pip install confluent-kafka==${kafka_version}

## Remove the temporary packages we needed to build with
apk del kafka-installer
