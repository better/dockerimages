# Better Docker images

Images for Better's projects.

## Tagging scheme

Tags are currently written according to the format:

```
{purpose}-{language|domain}-{version}
```

Purpose corresponds to a folder in the repo. Language|domain corresponds
to the suffix of a Dockerfile in that folder. For example,
`base-node-1.0.0` is version 1.0.0 of `base/Dockerfile.node`. Note
that's _not_ version 1.0.0 of node; it's revision 1.0.0 of the
Dockerfile.

Our images follow semantic versioning. Please version accordingly based on
breaking changes in your update.

## Tag Granularity

There may be many ways to specify the same image. If `1.2.3` is the latest
version of `base-node`, then:

- `base-node-latest`
- `base-node-1`
- `base-node-1.2`
- `base-node-1.2.3`

all refer to the same image. Specifying a less-exact tag version can
result in the image you use changing on repeat runs of `docker build`.

## How to reference one of these images

To write a Dockerfile based on one of these images, write:

`FROM better/dockerimages:{purpose}-{language|domain}-{version}`

In a new Dockerfile. For example:

`FROM better/dockerimages:base-node-1.0.0`

## Building one of these images

To build any of these images:

`make build-IMAGE`

For example:

`make build-build-node`

## Viewing existing images

This repo is connected to Dockerhub which deals with building our images
whenever tags are updated. This is configured through a regular
expression set in Dockerhub that converts the tag into a path to a
Dockerfile and directory for building. When tags are updated or set for
the first time provided they follow the format above they should be
automatically built and published by Dockerhub.

To view the status on Dockerhub you can go [here](https://hub.docker.com/repository/docker/better/dockerimages).
Credentials for if you need additional info can be found in Okta if you
search for "Dockerhub." Depending on the size of the image the build
might take quite some time but generally our smaller images finish in
less than 10 minutes total after tags are set.

## Updating an existing image

First make the appropriate update to the Dockerfile in question. Next
test that it builds properly by running:

`make test-IMAGE`

So for example:

`make test-build-node`

This will make sure that your build runs all the way through. At this
point you should open a pull request with your changes to the image and
get it merged to master.

Once the changes are merged you should merge master and run the
following:

`make release-TYPE-IMAGE`

So a full version of this command could look like:

`make release-patch-build-node`

This command will do all the proper tagging which will kick off builds
on dockerhub based on the tags changed. It will release the current
version to the following tags:

- `build-node-1`
- `build-node-1.1`
- `build-node-1.1.0`

The release process will also detect if this appears to be the latest
version released and ask you to confirm if it should update the `build-node:latest` tag.

Available TYPES are

- `major`
- `minor`
- `patch`

## Adding a fully new image

To add a new image it should be as simple as creating a new Dockerfile
in the correct folder with the correct extension.

Then in [docker hub](https://hub.docker.com/repository/docker/better/dockerimages/builds)
add an automated build configuration that uses tag as the source type and...
* source in the form `/^{purpose}-{language|domain}-*/`
* docker tag `{sourceref}`
* docker file location `Dockerfile.{language|domain}`
* build context `/{purpose}/`

Press save on the automated build rules. This seems to remove
permissions from the github webhook that kicks off dockerhub builds. Go
to the [webhook settings](https://github.com/better/dockerimages/settings/hooks)
for this repo and click into the dockerhub webhook. Make sure that
"Branch or tag creation" is check and click "Update webhook" at the
bottom.

Once the changes are merged you should merge master and follow the steps for [updating an existing image](#updating-an-existing-image)

