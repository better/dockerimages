#/bin/sh -e
#
# Install semver-tool
#

GLIBC_VERSION=glibc-2.32-r0.apk

apk add libstdc++6

wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&
  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/$GLIBC_VERSION" &&
  apk add "$GLIBC_VERSION" &&
  rm "$GLIBC_VERSION"

wget -q https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip &&
  unzip BrowserStackLocal-linux-x64.zip &&
  rm BrowserStackLocal-linux-x64.zip
