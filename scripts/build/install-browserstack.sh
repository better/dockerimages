#/bin/sh -e
#
# Install BrowserStack
#

GLIBC_VERSION=2.32-r0

apk add --no-cache libstdc++6

wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" &&
  apk add "glibc-$GLIBC_VERSION.apk" &&
  rm "glibc-$GLIBC_VERSION.apk"

wget -q https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip &&
  unzip BrowserStackLocal-linux-x64.zip &&
  rm BrowserStackLocal-linux-x64.zip
