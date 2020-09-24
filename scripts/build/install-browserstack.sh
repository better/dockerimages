#/bin/sh -e
#
# Install BrowserStack
#

GLIBC_VERSION=2.32-r0

apk add --no-cache libstdc++ procps

wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&
  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" &&
  apk add "glibc-$GLIBC_VERSION.apk" &&
  rm "glibc-$GLIBC_VERSION.apk"

wget -q https://www.browserstack.com/browserstack-local/BrowserStackLocal-alpine.zip &&
  unzip BrowserStackLocal-linux-x64.zip &&
  chmod +x BrowserStackLocal &&
  mkdir -p /root/.browserstack/ &&
  mv BrowserStackLocal /root/.browserstack/ &&
  rm BrowserStackLocal-linux-x64.zip
