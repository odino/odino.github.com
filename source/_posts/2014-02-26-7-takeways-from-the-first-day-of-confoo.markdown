---
layout: post
title: "7 takeways from the first day of ConFoo"
date: 2014-02-26 20:34
comments: true
categories: [confoo, conference, web]
---

Today it was the first day of ConFoo here in Montreal and,
as usual, a conference is always good to wrap your head around
solutions, different standpoints and discussions with other
nerds :)

<!-- more -->

{% img right /images/odino-confoo.jpg %}

## Websockets to the rescue

I've come to learn about [WebSocket](http://en.wikipedia.org/wiki/WebSocket)
quite a while ago but I honestly never found a practical application for our
architecture: nonetheless, in one of the talks it was [compared to REST](http://blog.arungupta.me/2014/02/rest-vs-websocket-comparison-benchmarks/)
in a context where multiple API calls are made, and the idea of re-using the same
TCP connection is pretty handy at that point.

For sure, things like [SPDY](http://stackoverflow.com/questions/12103628/spdy-as-replacement-for-websockets)
are probably already enough from that point of view, but that's not a valid excuse
for not digging deeper into the WS specification.

## Patterns of batch processing

During the same talk, [Arun Gupta](https://twitter.com/arungupta) spoke about 
[JSR 352](https://blogs.oracle.com/arungupta/entry/batch_applications_in_java_ee),
a specification for batch processing introduced in Java EE7.

It was really interesting as the specification is quite "obvious" but anyhow
efficient, as it structures batch jobs following a few rules:

* every job must process a specific number of items to process
* it is divided in steps
* each step is then again divided into 3 different sub-steps
  * reading the content of the item (`ItemReader`)
  * processing it, executing transformation and any kind of magic over that content (`ItemProcessor`)
  * writing the processed content *somewhere* (`ItemWriter`)

Dividing batches into jobs of a limited number of items is a golden rule (and I would say
your number should be as close to 1 as possible), while the structure that the JSR proposes
is very clean.

## Xamarin

This tool might be what you were looking for if you're into mobile development:
its aim is to write code once (in C#) that gets **converted to native code** for both
IOS and Android.

If you had to write an app twice, because you needed to go native, you might really
wanna [have a look at it](https://xamarin.com/) as, from what I heard, it might
really simplify your life.

## AppDynamics

My bad for not being aware of [AppDynamics](http://www.appdynamics.com/), but we're pretty
happy with one of their competitors ([NewRelic](http://newrelic.com/)) :)

AD is an **application performance management** platform that, just like NR, provides agents for
various platforms in order to collect metrics and reports from the stuff that runs on your
production servers: definitely worth a look, at least to understand the differences between
these guys and NewRelic. 

## Detach DOM elements while transforming them

Switching to something more browser-oriented, I found out about a very simple but
effective tecnique to optimize browser rendering performances when working with DOM
elements: instead of applying a bunch of transformations on a visible element you can
simply hide it, apply them and then show the element again, so that the browser
won't have to repaint and reflow at every transformation but only when you eventually
make the element visible again.

Another way to implement the same tecnique is to clone the element (so that we are actually
just working with a **virtual DOM node**), apply the transformations to that element and then
replacing the existing one by calling `parent.innerHtml(virtualElement)`.

Pretty simple but much valuable!

## Optimize DOM animations

Another way to optimize browser performance upon rendering is to execute animations
on elements with an absolute or fixed position.

Why? Again, because then the browser doesn't have to reflow the whole DOM.

## Lodash

A very [handy JS library](http://lodash.com/) that seems to be [way faster](http://lodash.com/benchmarks)
than underscore. It is now considered a [superset of underscore](http://stackoverflow.com/questions/13789618/differences-between-lodash-and-underscore)
and you might want to look into using it from now on, in place of its predecessor.

## All in all...

It was a fairly good day and my [presentation about OrientDB](/orientdb-the-fastest-document-based-graph-database/)
went pretty well, can't wait for tomorrow!