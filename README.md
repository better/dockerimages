# Better Docker images
Images for Better's projects.

Tags are currently written according to the format:

```
{"build"|"base"}-{language|domain}-{distro}-{distroVersion}
```

Currently, the following tags exist, effectively mimicking the tag
structure in `better/baseimage` but with an additional prefix to
differentiate the "same" image but when used for a different purpose
(currently, the only "purpose"s are "build" and "base"):

- build-node-alpine-3.10
- build-alpine-3.10
- build-analytics-alpine-3.9
