#!/bin/bash -e
#### Install latest librdkafka, right from the GIT repo.

### Define the version of kafka we are pinning to.
kafka_version=1.5.0
path__kafka_tarfile="v${kafka_version}.tar.gz"
path__kafka_build_directory="librdkafka-${kafka_version}"

apt_install="apt-get install --no-install-recommends --yes"
apt_purge="apt-get purge --yes"
temporary_dependencies=(curl make gcc g++)
purge_temporary="${PURGE_BUILD_DEPENDS}"

### Install librdkafka
## Install user dependencies
${apt_install} \
  zlib1g-dev   \
  libssl-dev   \
  libzstd-dev  \
  libsasl2-dev

## Install developer dependencies
${apt_install} ${temporary_dependencies[*]}

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
python3 -m pip install confluent-kafka==${kafka_version}

## Remove the temporary packages we needed to build with
if [[ -n "${purge_temporary}" ]]; then
  ${apt_purge} ${temporary_dependencies[*]}
fi
