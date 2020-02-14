#!/bin/sh -e

# Install supervisor
apk add --no-cache --virtual .kafka-zk-deps curl

# Get specified version of Zookeeper
echo "Downloading $ZOOKEEPER_TGZ using mirror $APACHE_MIRROR"
curl                                                                \
  --show-error                                                      \
  "$APACHE_MIRROR"/zookeeper/"$ZOOKEEPER_PATH"/"$ZOOKEEPER_TGZ" \
  --output /tmp/"$ZOOKEEPER_TGZ"

tar                             \
  xfz /tmp/"$ZOOKEEPER_TGZ" \
  -C /opt

rm /tmp/"$ZOOKEEPER_TGZ"

# Get specified version of Kafka
echo "Downloading $KAFKA_TGZ using mirror $APACHE_MIRROR"
curl                                                       \
  --show-error                                             \
  "$APACHE_MIRROR"/kafka/"$KAFKA_VERSION"/"$KAFKA_TGZ" \
  --output /tmp/"$KAFKA_TGZ"

tar                         \
  xfz /tmp/"$KAFKA_TGZ" \
  -C /opt

rm /tmp/"$KAFKA_TGZ"

apk del .kafka-zk-deps
