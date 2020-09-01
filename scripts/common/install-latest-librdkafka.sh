#!/bin/bash
#### Install latest librdkafka, right from the GIT repo.

### Define the version of kafka we are pinning to.
kafka_version=1.5.0


### Install librdkafka
## Install dependencies
apk add --no-cache libressl-dev || exit 2
apk add --no-cache cyrus-sasl-dev || exit 2
apk add --no-cache zstd-dev || exit 2
apk add --no-cache zlib-dev || exit 2
apk add --no-cache git || exit 2
apk add --no-cache make || exit 2
apk add --no-cache gcc || exit 2
apk add --no-cache g++ || exit 2

## Fetch librdkafka from github
git clone https://github.com/edenhill/librdkafka.git || exit 2
cd librdkafka/ || exit 2

## Check out the version we plan to build, so it's pinned.
git checkout v${kafka_version} || exit 2

## Actually build and install librdkafka
./configure --install-deps || exit 2
make || exit 2
make install || exit 2

## Install the confluent kafka python library
pip install confluent-kafka==${kafka_version} || exit 2
