FROM golang:1-alpine3.12

LABEL maintainer="core-tech@better.com"

ARG BASE_DEPENDENCIES
ARG BUILD_DEPENDENCIES

# Install the base requirements
COPY                                         \
  scripts/common/install-rds-certificates.sh \
  scripts/common/install-sops.sh             \
  /tmp/scripts/common/
RUN :                                                         \
  && apk update                                               \
  && apk upgrade                                              \
  && apk add --no-cache                                       \
    # Base dependencies                                       \
    ${BASE_DEPENDENCIES}                                      \
    # Base build dependencies                                 \
    ${BUILD_DEPENDENCIES}                                     \
  # Run common install scripts                                \
  && chmod +x /tmp/scripts/common/install-rds-certificates.sh \
  && chmod +x /tmp/scripts/common/install-sops.sh             \
  && /tmp/scripts/common/install-rds-certificates.sh          \
  && /tmp/scripts/common/install-sops.sh                      \
  ;

RUN curl -fL https://getcli.jfrog.io | sh
