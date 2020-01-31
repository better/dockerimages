#!/bin/sh -e
apk update
apk add --no-cache --virtual .java-deps curl

echo "Downloading ${OPENJDK_VSTRING} using mirror ${ALPINE_MIRROR}"
echo "curl ${ALPINE_MIRROR}/${JDK_BIN_PATH}/${JAVA_TGZ} ..."
curl                                           \
  --show-error                                 \
  ${ALPINE_MIRROR}/${JDK_BIN_PATH}/${JAVA_TGZ} \
  --output /tmp/${JAVA_TGZ}

echo "Evaluating checksum"
echo "Sum: ${JAVA_TGZ_CHECKSUM}"
echo "${JAVA_TGZ_CHECKSUM} */tmp/${JAVA_TGZ}" | sha256sum -c -;

echo "Extracting /tmp/${JAVA_TGZ} to ${JAVA_HOME}"
tar xzf /tmp/${JAVA_TGZ}   \
  --directory ${JAVA_HOME} \
  --strip-components 1
rm /tmp/${JAVA_TGZ}

# Clean up temporary dependencies used by the install script.
apk del .java-deps

