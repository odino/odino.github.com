---
layout: post
title: "5 technologies you should keep an eye on in 2015"
date: 2015-02-27 15:55
comments: true
categories: [web, tech]
published: true
description: Here are the technologies I'm going to keep an eye on this year
---

It's been a very short while since we landed
in 2015, but the technology scene is already
taking shape: here I'd like to point at some
of the technologies that you should definitely
keep an eye on this year.

<!-- more -->

## React native

Right out of [an article](http://jlongster.com/First-Impressions-using-React-Native) describing the experience
using react native:

{% blockquote %}
It only takes a few minutes playing with React Native to realize the potential it has. This works.

It feels like I'm developing for the web. But I'm writing a real native app, and you seriously can't tell the difference.

At the UI level, there is no difference; these are all native UIViews beautifully sliding around like normal.

This is solid engineering. And it completely reinforces the fact that React.js is the right way to build apps.
I can write a native app using the same techniques as I would write web app.

Let's start treating the DOM as an implementation detail, just like UIViews.
{% endblockquote %}

For those of you who have missed the news, Facebook
is planning to completely [open source it's react native](https://www.youtube.com/watch?v=KVZ-P-ZI6W4)
framework which is a layer to build native apps (on ios only, for now)
with good old DOM and a layer of JavaScript.

Not that similar tools do not exist as of now (among them
[ionic](http://ionicframework.com/) seems to be very popular,
as it's built over [cordova](http://cordova.apache.org/) and angular)
but the real deal is that it seems that react native
**feels really native**: the limitation of hybrid solutions
has always been the fact that the UI turns quite sluggish
and doesn't feel very smooth, which is why react native
is kind of uber-exciting.

## Docker's ecosystem

{% img right /images/docker.png %}

During the DockerCon in Amsterdam, at the end of last year,
the docker guys announced that [a bunch of new tools](https://blog.docker.com/2014/12/announcing-docker-machine-swarm-and-compose-for-orchestrating-distributed-apps/) were
coming along to support [better orchestration](https://blog.docker.com/2015/02/orchestrating-docker-with-machine-swarm-and-compose/).

In these days those tools have seen their first
decent beta and stable releases:

* [swarm](https://blog.docker.com/2015/02/scaling-docker-with-swarm/), a tool for clustering / scaling containers
* [compose](https://blog.docker.com/2015/02/announcing-docker-compose/), a way to orchestrate those clusters
* [machine](https://blog.docker.com/2015/02/announcing-docker-machine-beta/), the easiest way to get started with your first container

As someone stated durint the european docker event:

> Docker was on no one's agenda in 2014, it's on everyone's agenda in 2015

Can't use better words than those to describe how docker
is changing the way we want apps to be running.

Now, with the advent of these new tools that should provide
a better experience in terms of getting started / orchestration
things are just going to be more interesting.

## JavaScript

For better or for worse, JavaScript has taken the programming
ecosystem by storm over the past 5 years: it used to be just a
tool to make nicer interfaces whereas now hordes of programmers
are writing business logic with it{% fn_ref 1 %},
thanks to NodeJS and modern client-side frameworks like
AngularJS or Ember.

Truth is, JavaScript opens the door for [isomorphic apps](http://nerds.airbnb.com/isomorphic-javascript-future-web-apps/)
which is something developers are quite keen on (the ability
of running the "same" app / code both on the browser and the
server): the idea sounds quite crazy but it might become
more than a *weirdo* as we get more robust and solid solutions
to implement isomorphism.

{% img center /images/isomorphic-trend.png %}

In other words, **JavaScript ain't done yet**.

## Microservices

Microservices, an [implementation of SOA](/on-monoliths-service-oriented-architectures-and-microservices/),
are gaining a lot of attention simply because
the tooling around them has become much more
powerful in recent years: you can provision
hardware in minutes thanks to platforms like AWS
and deploy images of your application [in seconds](https://www.digitalocean.com/features/one-click-apps/docker/)
thanks to Docker.

There's a lot to [figure out when using microservices](http://tech.namshi.com/blog/2015/02/27/reflecting-on-microservices/),
and everyone quite agrees on the fact that to roll
this kind of architectures out your entire infrastructure
needs to be very mature and robust, but at the same time
a lot more organizations seem keen on giving them a shot,
as they provide great flexibility when compared to good
old monoliths.

I recently watched [Martin Fowler's take on microservices](https://www.youtube.com/watch?v=wgdBVIX9ifA&index=2&list=PLEx5khR4g7PIIBNcNhHOMmOhzxcwI5joG)
and read the [best practices Netflix uses](http://nginx.com/blog/microservices-at-netflix-architectural-best-practices/) in this kind
of architecture. I strongly recommend keeping an eye on the
topic as there will be more to come this year.

## Golang

{% img right /images/golang.png %}

Now, seriously, I have lost the count of how many
technologies are being built with [Golang](http://golang.org/)
these days!

You want me to mention a few of them?

* docker
* [terraform](https://github.com/hashicorp/terraform)
* [vegeta](https://github.com/tsenart/vegeta)
* [rancher/os](https://github.com/rancherio/os)
* [websocketd](https://github.com/joewalnes/websocketd)
* [kubernetes](https://github.com/GoogleCloudPlatform/kubernetes)
* [consul](https://github.com/hashicorp/consul)

The list can go on for a while...

What is clear is that it seems like we are witnesses
of a shift into 2 programming emispheres: on one side,
web development is being taken by storm by JavaScript;
on the other end, it looks like **Golang is ruling the
DevOps side of things**.

I am exploring Go these days mostly because I'm seeing a
lot of people going crazy for it, and I can understand where
they come from: sometimes you need strong typing and the
feeling that distributing your packages will be a painless
experience, plus the performances are great and the built-in
stuff in the [standard library](http://golang.org/pkg/) is
quite awesome. I'm not a big fan of some things of the language
(ie. not a big supporter of how error handling works{% fn_ref 2 %})
but, hey, who's perfect?

So, yeah, I like Go for some of the things it can do and I like
other tools for doing other stuff, which is, I think, the
essence of technology: **pick the right tool for the right
job**.

Nowadays DevOps is leaning towards Golang and that is why,
I believe, we will see an even bigger shift in 2015.

The next Varnish? Probably written in Go.

## To wrap up

This list gets a clear bias because of the fact that
I mostly work with the web, thus most of the tools
are either web-related or come from a web-ish background,
this is why you won't read about wearables or those
kind of things here.

I think these 5 technologies are something that we should
be closely monitoring in 2015 as they indicate which path
big players, industry leaders and the open source community
are taking.

{% footnotes %}
  {% fn How crazy, right? %}
  {% fn Which I hate in JS as well :) %}
{% endfootnotes %}