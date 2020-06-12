#!/bin/sh
until bash $ZOOKEEPER_HOME/bin/zkServer.sh status; do
  echo "Zookeeper not yet started"
  sleep 0.5
done
exec bash $KAFKA_HOME/bin/kafka-server-start.sh                         \
  $KAFKA_HOME/config/server.properties                                  \
  --override auto.create.topics.enable=${AUTO_CREATE_TOPICS_ENABLE}     \
  --override listeners="${LISTENERS}"                                   \
  --override advertised.listeners="${ADVERTISED_LISTENERS}"             \
  --override inter.broker.listener.name="${INTER_BROKER_LISTENER_NAME}" \
  --override listener.security.protocol.map="${LISTENER_SECURITY_PROTOCOL_MAP}"
