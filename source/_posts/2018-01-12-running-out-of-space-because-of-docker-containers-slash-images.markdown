---
layout: post
title: "Running out of space because of docker containers / images?"
date: 2018-01-12 16:25
comments: true
categories: [docker, linux]
description: "Those gigabytes are precious: let's see how to clean docker artifacts up"
---

Almost 3 years ago I published a much-needed post around [cleaning up space taken
by docker](/spring-cleaning-of-your-docker-containers/) (it's been one of the most
popular posts on this blog according to Google Analytics), but since a year or so
there's a much better way to achieve the same.

<!-- more -->

Disk space has been one of the biggest painpoints for whoever worked with docker:
you build containers, run them and don't bother cleaning them up :)
Images, build
caches and container filesystems pile up and, before you know it, there's some
50GB of space taken by docker.

Luckily enough, the docker CLI now has a very simple way to free space taken
by images / containers:

```
$ docker system prune

WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N]

...
Total reclaimed space: 513.6MB
```

The disadvantage of this approach is that it actually kills a few things you might
be interested in (build caches, for example), but it's one of those instructions
each and everyone of us should dump in the crontab of our servers, or run seldom
on a local machine.

Adios!