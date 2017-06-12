---
layout: post
title: "HTTP cache 101: scaling the web"
date: 2017-06-11 14:04
comments: true
categories: [http, caching, web, performance]
description: "A modern view at the HTTP cache: scaling has never been easier."
published: false
---

{% img right nobo /images/internetz.png %}

I recently gave another read at my original post "[REST better: HTTP cache](http://odino.org/rest-better-http-cache/)"
and I felt compelled to write a more in-depth dive into the subject, especially since it's
one of the most popular topics in this blog; at the same time, with the advent of
new technologies such as [sevice workers](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers), people jumped into the bandwagon of
offline applications without, in my opinion, understanding that the HTTP cache
provides some basic but extremely interesting features for offline experiences
-- thus, I want to shed some light on one of the most ingenious sections of the
HTTP protocol.

## What is the HTTP cache?

First of all, let's start by diving the HTTP protocol into 2 entities:

* the [spec](https://www.w3.org/Protocols/rfc2616/rfc2616.txt){% fn_ref 1 %}, which highlights how messages can be exchanged between clients and servers
* the implementation (for example, Google Chrome is an HTTP client, Nginx implements an HTTP server and so on)

So, for example, with HTTP/2 we have seen a revamped *implementation*, one that
brings SSL by default, that turned plaintext messages (the way messages were exchanged
in HTTP/1) into binary, along with the introduction of [multiplexing](https://en.wikipedia.org/wiki/Multiplexing)
(in short: one connection can channel multiple requests and responses) and the
likes -- HTTP/2 was a massive upgrade to the protocol and is making the web a much
safer, faster place. At the same time, **the spec itself didn't change as much**, as
the semantics of the protocol have been widely unaffected by HTTP/2.

HTTP caching falls under the HTTP spec, as it's simply a chapter that defines how messages can be cached by both clients & servers: the current
version of the HTTP caching spec is [RFC7234](https://tools.ietf.org/html/rfc7234),
so you can always head there and have a look by yourself.

The goal of the HTTP caching spec is, in short, to:

{% blockquote RFC7234 https://tools.ietf.org/html/rfc7234 %}
[...] significantly improve performance by reusing a prior response message to satisfy a current request.
{% endblockquote %}

or, as [some smart guy](https://tomayko.com/) once said:

{% blockquote Ryan Tomayko https://tomayko.com/blog/2008/rack-cache-announce Introducing Rack Cache %}
[...] never generate the same response twice
{% endblockquote %}

{% pullquote %}
As you might have guessed, {"the HTTP cache is there so that we hit servers as less
as possible"}: if we can re-use an existing response, why sending a request to the
origin server? The request needs to cross the network (slow, and TCP is a "heavy"
protocol), hit the origin server (which could do better without the additional load)
and come back to the client. *No bueno*: if we can avoid all of that we, first of
all, take a huge burden off our servers and, second, make the web faster, as clients
don't need to hit your server to get the information they need.

A side effect of HTTP caching is the fact that it makes the web inconsistent: a
resource might have changed and, by serving a cached, stale version of it we don't
feed the clients the latest version of it: this is, generally, an acceptable
compromise we, as developers, make in order to scale better. In addition, these
inconsistencies can be avoided by tweaking the *cacheability* of our responses, and
we will look at how to do that in the next paragraph.

In defining mechanisms to implement this kind of performance optimizations, the
W3C working group split caching into 2 main variants: **expiration**, which is simpler
but very high-level, and **validation**, which gives you more granularity.

Let's look at expiration first, as it's the way we use HTTP caching on a daily
basis.
{% endpullquote %}

## Expiration

This is the sort of caching you're used to see every day, used to specify TTLs (
*time to live*) for static assets like JS, CSS & the likes: we know those assets
are cacheable for a long time, so we specify an expiration date on those resources,
through the `Expires` HTTP header:

{% img center nobo /images/expires.png %}

If the server needs to fetch the same resources later on, it will first figure out
if it has expired and, if not, use the local copy stored in the cache:

https://www.subbu.org/blog/2005/01/http-caching
https://tools.ietf.org/html/rfc7234
https://tools.ietf.org/html/rfc2616
https://www.chromestatus.com/features#reva
https://www.mnot.net/blog/2014/06/01/chrome_and_stale-while-revalidate
https://webdemo.balsamiq.com/
http://odino.org/rest-better-http-cache/

Expires
Cache-Control

## Fault tolerance

stale-if-error

## Scaling with compromises

stale-while-revalidate

## A note on offline apps

## Validation

Etag
Last-Modified

## Note: obsolete headers you'll still see around

Pragma

## Conclusion

## Further readings

* /categories/cache/
* mnot
* rtomayko
* https://www.subbu.org/blog/2005/01/http-caching

{% footnotes %}
  {% fn Worth to note that RFC2616 has been superseded by a few updates (RFCs 7230, 7231, 7232, 7233, 7234, 7235, which update part of the original spec) %}
{% endfootnotes %}

<!--

BALSAMIQ

{"mockup":{"controls":{"control":[{"ID":"3","measuredH":"128","measuredW":"128","properties":{"icon":{"ID":"server","size":"xxlarge"}},"typeID":"Icon","x":"871","y":"251","zOrder":"2"},{"ID":"5","measuredH":"128","measuredW":"128","properties":{"icon":{"ID":"laptop","size":"xxlarge"}},"typeID":"Icon","x":"246","y":"261","zOrder":"3"},{"ID":"10","h":"50","measuredH":"126","measuredW":"100","properties":{"hasHeader":"false","icons":{"icons":[{"size":null}]},"rowHeight":"39","size":"17","text":"GET /static/app.js","verticalScrollbar":"false"},"typeID":"List","w":"190","x":"517","y":"220","zOrder":"4"},{"ID":"14","h":"55","measuredH":"54","measuredW":"439","properties":{"curvature":"1","direction":"top","leftArrow":"false","p0":{"x":0,"y":44},"p1":{"x":0.4808345264880343,"y":0.10920433626508488},"p2":{"x":439,"y":54},"rightArrow":"true","shape":"bezier","text":""},"typeID":"Arrow","w":"440","x":"401","y":"232","zOrder":"1"},{"ID":"16","h":"30","measuredH":"54","measuredW":"439","properties":{"curvature":"-1","direction":"top","leftArrow":"true","p0":{"x":0,"y":0},"p1":{"x":0.48416925542342376,"y":-0.055030313088304694},"p2":{"x":439,"y":10},"rightArrow":"false","shape":"bezier","text":""},"typeID":"Arrow","w":"440","x":"401","y":"378","zOrder":"0"},{"ID":"17","h":"120","measuredH":"140","measuredW":"200","properties":{"size":"18","text":"HTTP/1.1 200 Ok\nContent-Type: application/javascript\nContent-Length: 1234\n*Expires: Wed, 21 Oct 2020 07:00:00*"},"typeID":"TextArea","w":"332","x":"455","y":"351","zOrder":"5"}]},"measuredH":"471","measuredW":"999","mockupH":"251","mockupW":"753","version":"1.0"}}
 -->
