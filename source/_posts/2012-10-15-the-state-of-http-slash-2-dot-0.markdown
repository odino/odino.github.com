---
layout: post
title: "The state of HTTP/2.0"
date: 2012-10-15 23:45
comments: true
categories: [http, spdy, web]
---

With a few days of delay I'm here reporting and commenting
the last **revolutions** about the protocol of the web,
its upcoming groundbreaking new version and its state.
<!-- more -->

A few days back [Mark Nottingham](http://www.mnot.net/) announced that the
group is [officially working on the new draft of `HTTP/2.0`](https://twitter.com/mnot/status/253175410383278081):
even though rumors about the shape of this new version were
going on since a couple years, this **official**
news brings some fresh hope on the topic.

As the HTTP protocol was always directly influenced
by great minds ([Tim Berners-Lee](http://en.wikipedia.org/wiki/Tim_Berners-Lee) and [Roy Fielding](http://en.wikipedia.org/wiki/Roy_Fielding), just
to mention a couple names) when I first heard about
Mark taking the responsability to publish `HTTP/2.0` I
was pretty sure something great would have come out of
his mind.

I wasn't wrong.

It's been 13 years since HTTP doesnt see a major change
in its specification (recent changes are the addition of
the `PATCH` method, for example, but we're talking about
**minor** stuff) and SPDY - a new protocol created by Google -
came out in the recent history of the web with a disruptive
force.

HTTP needed something.

## SPDY

But before having a look at what `HTTP/2.0` will look like,
let's mention the good things that SPDY brings on the table:

* prioritization: it allows to send different requests and
tell the server to prioritize some of them
* multiplexing: allows parallel requests and asynchronous
responses, unlike *pipelining* which is bound to multiple
requests/responses at the same time
* server push: servers can now push resources to the client
without them having to ask for
* better performances: extended compression is one of the
key FTW of SPDY

But there is one things that SPDY doesn't change at all:
the **interface** between the machines.

As recognized worldwide, the HTTP protocol was an almost
perfect example of M2M interface which allows servers
and clients to follow DAPs (*domain-application protocols*)
according to a loosely coupled interface - the protocol itself,
with its verbs, semantics and workflows{% fn_ref 1 %}.

So SPDY, recognizing the perfection of the contract that HTTP
puts among clients and servers, isn't a real new protocol, it's
a **better implementation of the same interface**.

## HTTP/2.0 is an evolution of an evolution

No wonder, then, in reading the words of Nottingham, as, after
all, he "just" announced that [`HTTP/2.0` will be **based on SPDY**](http://lists.w3.org/Archives/Public/ietf-http-wg/2012OctDec/0004.html):
a great news that is basically telling you the "don't reinvent the wheel"
principle is even applied at the foundation of the web{% fn_ref 2 %}.

The layers will definitely be different, but, again, I think
that having a newer version of our beloved protocol, based on a
specification which already improves it and adds tons of new and
interesting features, is going to be **a game-changer for web
applications**.

Will we see `HTTP/2.0` being deployed with multiplexing, server push,
prioritization and extended compression next year?

{% footnotes %}
	{% fn No wonder why Roy Fielding, after having heavily influenced the HTTP protocol and the Apache ecosystem, came out with REST, an architectural style meant for long-living and scalable architectures %}
	{% fn So, think about it, why do you need to re-write huge portions of code when better FOSS is out there? %}
{% endfootnotes %}