Better Kafka Base Image
=======================

The Better Kafka base image is a fork of Spotify/Kafka, updated to later
versions of the JDK and with support for Kafka `2.x`.

***THIS IS NOT A PRODUCTION IMAGE.***

This image is only intended for use for local development. Its intent is
to approximately reproduce the configuration used in a cloud-based managed
Kafka service, like Amazon MSK, but on a single-CPU, single-machine setup
with only 1 broker.

Settings
--------
The image is set up by default to work correctly with:

```
$ docker run --publish 9092:9092 better/dockerimages:base-kafka-latest
```

Any more complicated setup (e.g. docker-compose) will require changing the
following Kafka configurations via their associated environment variable:

```
listeners (env: LISTENERS)
  Named internal interfaces to listen on for connections.
  The interface 0.0.0.0 means "all interfaces".

  Example:

    LOCAL://0.0.0.0:9092,DOCKER://0.0.0.0:9092,INTERNAL://0.0.0.0:9092

advertised.listeners (env: ADVERTISED_LISTENERS)
  Named externally-reachable interfaces for configured `listeners`.
  Not all listeners must be advertised. Clients will be redirected to the
  advertised interface for a named listener if they contact the broker
  directly.

  Example:

    LOCAL://127.0.0.1:9092,DOCKER://local-kafka:9092

listener.security.protocol.map (env: LISTENER_SECURITY_PROTOCOL_MAP)
  Security protocol (e.g. PLAINTEXT or SSL) used by each named listener.

  Example:
    INTERNAL:PLAINTEXT,LOCAL:PLAINTEXT,DOCKER:PLAINTEXT

inter.broker.listener.name (env: INTER_BROKER_LISTENER_NAME)
  Name of the listener to use for inter-broker communication.

  Example:
    INTERNAL
```

With our common setup, having a single broker, the inter-broker listener
name is generally unimportant, except that it MUST be set to the name of a
configured listener.

Example docker-compose.yml
--------------------------
See `examples/kafka/docker-compose.yml` for an example
`docker-compose.yml` that sets up a single-broker Kafka cluster with
KafkaHQ, accessible both from `127.0.0.1:9092` on the host and from
`local-kafka:9092` from within the docker-compose network.

Why fork?
---------

Spotify/kafka was a popular base image for local development with Kafka,
referenced by many online tutorials and still occasionally recommended to
this day. However, the image is stuck on Kafka versions in the old 0.x
stage. It doesn't align with the Kafka version or configuration we are
attempting to replicate from Amazon MSK.

We liked the image, and found it simpler and easier to understand than
ConfluentInc's docker images, and so we forked it to continue using it.
