---
layout: post
title: "A docker primer: embrace the technology of the future"
date: 2015-01-09 13:01
comments: true
categories: [docker, vm]
published: false
---

Everything you wanted to know
(but were afraid to ask) to get
started with Linux containers.

<!-- more -->

## Introduction

Linux containers are a groundbreaking
technology that is taking the tech sector
by storm.

> You only know two things about Docker. First, it uses Linux containers.
> Second, the Internet won't shut up about it.

Using VMs as a way to efficiently utilize 
and abstract the underlying hardware is a
common tecnique we've been exposed to for the
past few years, as players like [AWS](https://aws.amazon.com/)
or [Digital Ocean](https://www.digitalocean.com/)
have been steadily growing, acquiring market
chunks while the traditional good old ways of
"the home made linux server" or "a rack full
of HW at the $WHATEVER datacenter" have started to
disappear: nowadays most of us run their production
applications on virtualized servers running *god knows where*.

So, how do linux containers (LXC) compare to this?

Well, containers are a smart abstraction similar to VMs
in the sense that they are able to abstract an isolated
system on top of an existing one, thanks to Linux's
[cgroups and namespaces](http://en.wikipedia.org/wiki/Cgroups);
you can see a container as a very ightweight VM that,
thanks to the mentioned features, can boot in milliseconds
and easily integrates with the host machine.

Probably the most important feature of Linux
containers is that they can be ported from your
dev machine to production with very few steps:
the container engine (like docker) is your only
dependency, and from that you can pull your
container and run it at will, no matter it contains
a Java app, a NoSQL DB that exposes an HTTP interface
or whatsoever other tool.

Linux containers provide you a way to run any kind
of app in an isolated environment that does not affect
your host.

## Then, why docker?

Any linux container engine can do this
"lightweight VM" thing but docker has
positioned itself ahead of 
[any other competitor](http://thevarguy.com/virtualization-applications-and-technologies/091614/flockport-rivals-docker-open-source-container-virtualiz)
due to the ease of use and underlying
philosophy that accompanies this tool:
Docker is in line with the evolution of
the tech ecosystem from monolithic apps
to microservice-based architectures in a way
that it promotes running single-process
containers, where you usually define a container
that does one thing and does it well.

Sure, Linux containers (LXC) and docker itself
can be used to run containers where you have a
node app, elasticsearch and redis running together
but the philosophy that Docker follows is completely
different: run 3 containers, get them to
[discover each other](https://www.google.ae/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=service+discovery+docker)
and let them take the stage. You can see Docker
as your own **Heroku on steroids**.

Last but not least, Docker is **simple as hell**:
simplicity, one of the most important aspects of
softwares, is king as this tools let's you do
very few things and they are very straightforward;
usually there aren't 2/3 ways of doing something in
Docker, and if you find yourself unable to figure out
how to do X in Docker, it probably means that you are
doing something wrong.

Docker embraces KISS, and this is the most important
(and powerful) feature of the [Docker platform](https://www.docker.com/whatisdocker/).

## Your first app

## How do I see it?

## Clear your memory

## Volumes

## Environment configuration

## Deployment

## On top of a build

## Next?