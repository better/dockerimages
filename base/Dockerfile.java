FROM alpine:3.10

LABEL maintainer="core-tech@better.com"

# Configurable versions
ENV JDK_VERSION          14
ENV JDK_EARLY_ACCESS_TAG 15

# Version-based paths, filenames
ENV OPENJDK_VSTRING openjdk-${JDK_VERSION}-ea+${JDK_EARLY_ACCESS_TAG}
ENV JAVA_HOME       /opt/java/${OPENJDK_VSTRING}

# Mirror URL components; full target tarball filename
ENV ALPINE_MIRROR https://download.java.net/java/early_access/alpine
ENV JDK_BIN_PATH  ${JDK_EARLY_ACCESS_TAG}/binaries
ENV JAVA_TGZ      ${OPENJDK_VSTRING}_linux-x64-musl_bin.tar.gz

ENV JAVA_TGZ_CHECKSUM \
  76091da1b6ed29788f0cf85454d23900a4134286e5feb571247e5861f618d3cd

# Print checksum debug information
RUN                                                     \
  printf "sha256 checksum:\n%s\n%s\n"                   \
    ${ALPINE_MIRROR}/${JDK_BIN_PATH}/${JAVA_TGZ}.sha256 \
    ${JAVA_TGZ_CHECKSUM}

# Make sure JAVA_HOME exists before attempting to extract to it
RUN mkdir -p ${JAVA_HOME}

# Perform download, checksum, extract, install...
ARG SCRIPT=download-and-install.java.sh
COPY ./scripts/${SCRIPT} /tmp/
RUN :                        \
  && chmod +x /tmp/${SCRIPT} \
  && /tmp/${SCRIPT}          \
  && rm /tmp/${SCRIPT}       \
  ;

# Basic smoke test: did install probably work?
RUN :                                 \
  && ${JAVA_HOME}/bin/java  --version \
  && ${JAVA_HOME}/bin/javac --version \
  ;

# This sets a java setting to improve startup speed in... ways. See below:
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# https://openjdk.java.net/jeps/341
RUN ${JAVA_HOME}/bin/java -Xshare:dump &>/dev/null

# Add java installation to PATH
ENV PATH ${JAVA_HOME}/bin:${PATH}
