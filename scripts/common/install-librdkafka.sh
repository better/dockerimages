#!/bin/bash -e
#### Install librdkafka.

### Inputs: can specify version, checksum
librdkafka_version=${LIBRDKAFKA_VERSION:-1.6.0}
librdkafka_sha256_sum=${LIBRDKAFKA_SHA256_SUM:-"f7fee59fdbf1286ec23ef0b35b2dfb41031c8727c90ced6435b8cf576f23a656"}
### GitHub download URLs and paths
librdkafka_url_base="https://github.com/edenhill/librdkafka/archive"
path__kafka_tarfile="v${librdkafka_version}.tar.gz"
path__kafka_build_directory="librdkafka-${librdkafka_version}"

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

## Fetch librdkafka from github, validate checksum, extract
echo -e "\033[1;38;2;255;255;0mFetching librdkafka from \033[0;1;3m${librdkafka_url_base}/${path__kafka_tarfile}\033[0m"
curl -LO "${librdkafka_url_base}/${path__kafka_tarfile}"
echo -e "\033[1;38;2;255;255;0mComparing checksum (\033[0;1;3m$(sha256sum "${path__kafka_tarfile}")\033[0;1;38;2;255;255;0m) against records (\033[0;1;3m${librdkafka_sha256_sum}\033[0;1;38;2;255;255;0m)\033[0m"
sha256sum "${path__kafka_tarfile}" | grep ${librdkafka_sha256_sum}
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
python3 -m pip install confluent-kafka==${librdkafka_version}

## Remove the temporary packages we needed to build with
if [[ -n "${purge_temporary}" ]]; then
  ${apt_purge} ${temporary_dependencies[*]}
fi
