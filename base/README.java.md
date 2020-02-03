Better Java Base Image
======================

The Better Java base image is a fork of OpenJDK:14-jdk-alpine. Small
modifications are made so that the Dockerfile is similar to our others.

How to Update
-------------

If you try to use a new JDK build, the checksum will fail. One layer of
the image, however, prints out checksum details, including a constructed
link to the checksum page on the jdk.java.net webpage for the configured
version. So, do the following:

```
$ JDK_VERSION=<new-version>                             \
  JDK_EARLY_ACCESS_TAG=<new-ea-tag>                     \
  docker build --tag base-java --file Dockerfile.java .
```

The checksum for the old version will be printed, with a link to the
checksum page for the _new_ version. The checksum will fail to validate,
and the build will terminate. Copy the URL printed by the checksum debug
layer, and open it in your browser. Copy the new checksum, and update the
value of `JAVA_TGZ_CHECKSUM` appropriately:

```
$ JDK_VERSION=<new-version>                             \
  JDK_EARLY_ACCESS_TAG=<new-ea-tag>                     \
  JAVA_TGZ_CHECKSUM=<new-checksum>                      \
  docker build --tag base-java --file Dockerfile.java .
```

If the build succeeds, then update Dockerfile.java with the new default
values for `JDK_VERSION`, `JDK_EARLY_ACCESS_TAG`, and `JAVA_TGZ_CHECKSUM`.

Why fork?
---------

The OpenJDK image followed a release system that allowed breaking changes
(from early-access 15 to early-access 33 of the alpine-supporting
musl-libc OpenJDK build) to be installed by accident, because the update
was built as the latest tag for 14-jdk-alpine. When this happened, it
manifested as a cache invalidation bug for users of our Kafka image:
everything was fine, until you tried to run the image on a computer that
didn't have a cached version of the older build of 14-jdk-alpine.

In order to control for these sorts of upstream bugs, and after deciding
that the simple Dockerfile would be easy to maintain if it was forked, the
Java baseimage was born.
