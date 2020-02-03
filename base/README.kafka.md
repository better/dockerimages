Better Kafka Base Image
=======================

The Better Kafka base image is a fork of Spotify/Kafka, updated to later
versions of the JDK and with support for Kafka 2.2.1 for version
compatability with Amazon Managed Streaming with Kafka (MSK).

This Dockerfile originally lived in the Better application monorepo. It
has been extracted into our dockerimages repository so as to:

- Open-source the work to contribute back
- Benefit from versioning and release automation via Docker Hub
- Keep and maintain it with all our other images; esp. the java base image

***THIS IS NOT A PRODUCTION IMAGE.***

This image is only intended for use for local development. Its intent is
to approximately reproduce the configuration used in a cloud-based managed
Kafka service, like Amazon MSK, but on a single-CPU, single-machine setup
with only 1 broker.

Why fork?
---------

Spotify/kafka was a popular base image for local development with Kafka,
referenced by many online tutorials and still occasionally recommended to
this day. However, the image is stuck on Kafka versions in the old 0.x
stage. It doesn't align with the Kafka version or configuration we are
attempting to replicate from Amazon MSK.

We liked the image, and found it simpler and easier to understand than
ConfluentInc's docker images, and so we forked it to continue using it.
