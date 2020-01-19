FROM node:12-alpine3.10

LABEL \
maintainer="core-tech@better.com"

RUN apk update                                                                                \
  && apk add --upgrade --no-cache                                                             \
      coreutils openssl curl make bash git build-base docker                                  \
  && curl -o sops -L https://github.com/mozilla/sops/releases/download/3.3.1/sops-3.3.1.linux \
  && sha1sum sops | grep af2fc3d3a29565b0d6a73249136965ffee62892f                             \
  && chmod +x sops                                                                            \
  && mv sops /usr/local/bin

# Check for CVE-2019-5021
RUN grep -F 'root:!::0:::::' /etc/shadow
