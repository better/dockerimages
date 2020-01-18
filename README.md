# Better Docker images

Images for Better's projects.

## Tagging scheme

Tags are currently written according to the format:

```
{purpose}-{language|domain}-{version}
```

The purpose should correspond to a folder in this repo which describes
what we are using those images for. And the language/domain should
correspond to the extension on a Dockerfile in that directory. E.g. the
tag `base-node-12.0.0` corresponds to version 12.0.0 of the file in
`base/Dockerfile.node`.

Note that all of our images follow a semver versioning process so make
sure to update the version accordingly based on if there are potential breaking
changes in your update.

## Updating an existing image

First make the appropriate update to the Dockerfile in question. Next
test that it builds properly by running:

`IMAGE={purpose}-{language|domain} make test`

So for example:

`IMAGE=build-node make test`

This will make sure that your build runs all the way through. At this
point you should open a pull request with your changes to the image and
get it merged to master.

Once the changes are merged you should merge master and run the
following:

`IMAGE={purpose}-{language|domain} VERSION={new version} make release`

The `VERSION` input should be a full version number in the form `X.X.X`
with an optional `-<special tag>`.

So a full version of this command could look like:

`IMAGE=build-node VERSION=13.4.6 make release`

This command will do all the proper tagging which will kick off builds
on dockerhub based on the tags changed. It will release the current
version to the following tags:

- `build-node-13`
- `build-node-13.4`
- `build-node-13.4.6`

The release process will also detect if this appears to be the latest
version released and ask you to confirm if it should update the `build-node:latest` tag.

### Zshell

It seems some Zsh configurations (possibly OhMyZsh) alias make to add
color to the output. This seems to break some printing behavior when
invoking a script from within a makefile. If these scripts appear to
hang for you then you can skip running aliases by prepending the command
with a `\\` so it would look something like:

`IMAGE=build-node VERSION=13.4.6 \make release`

## Adding a fully new image

To add a new image it should be as simple as creating a new Dockerfile
in the correct folder with the correct extension. Note that because the
tags are matched on dockerhub via regular expression the following
restrictions apply:

The top level folder must only contain upper and lowercase letters and
underscores in its name. This is the part that matches the `purpose`
portion of the tag. The extension on the Dockerfile must only contain
alphanumerics and underscores in its name. As long as these rules are
followed and things are tagged properly everything should work as
expected.
