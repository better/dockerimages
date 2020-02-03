#!/bin/sh
until bash $ZOOKEEPER_HOME/bin/zkServer.sh status; do
  echo "Zookeeper not yet started"
  sleep 0.5
done
exec bash $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
