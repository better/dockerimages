#!/bin/sh
until bash $ZOOKEEPER_HOME/bin/zkServer.sh status; do
  echo "Zookeeper not yet started"
  sleep 0.5
done
exec bash $KAFKA_HOME/bin/kafka-server-start.sh \
  $KAFKA_HOME/config/server.properties \
  --override advertised.listeners=${ADVERTISED_LISTENERS}
  --override listeners=${LISTENERS}
  --override listener.security.protocol.map=${LISTENER_SECURITY_PROTOCOL_MAP}
