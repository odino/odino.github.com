---
layout: post
title: "Frontend web development is not as fun as it could be"
date: 2013-11-10 19:53
comments: true
categories: [JavaScript, AngularJS, CORS, NGINX, Internet Explorer, xDomain, Varnish, HTTP, JWS, Android]
---

{% img right /images/browsers.jpg %}

I am writing this post in the middle of revamping
[Namshi's architecture](http://en-ae.namshi.com)
with AngularJS, reverse proxies,
SPDY and HTTP APIs, because I
strongly believe in the future of these technologies and
that they are the de-facto cutting-edge solution for
most of the antipatterns that we've seen so far:
monolithic applications, unscaleable frontends,
limited protocols.

So why would I rant about it? Well, this is not a real
rant but it's more of a retrospective on the *gotchas*
that we faced over the past months: I do **really**
enjoy all of this techs, but also
recognize that most of them are at a
very early stage and have their pitfalls when it comes
to develop real-world, scaleable architectures.

The boring part's over, let's get into the real mess ;-)

<!-- more -->

## Reducing redirects?

Suppose that you have a frontend, maybe built with AngularJS,
that proxies all the requests to an API, so if you request
`example.org/about`, your frontend actually gets the content
from `api.example.org/about`.

One of the things that you can start optimizing are the
round trips between the client and the server (very important
for mobile connections): for example,
instead of sending simple redirects from your API to the
frontend, you can return a `30X` and include the actual body
in the response; in this way, the client can:

* read the body of the response and work with it (output or whatever)
* update the browser URL according to the `Location` header provided in the response with the [browsers' history API](http://diveintohtml5.info/history.html)

NOT. SO. FAST.

Turns out that modern browsers intercept redirects and make an
additional HTTP request to the `Location` provided by the response.

This behavior is pretty useful in 98% of your use-cases, as
you dont have to take care of handling AJAX redirects on
your own and you have a pretty simple solution, using a
custom HTTP status
code, like [278](http://stackoverflow.com/questions/199099/how-to-manage-a-redirect-request-after-a-jquery-ajax-call), for the remaining 2% of scenarios.

NOT. SO. FAST. 2.

Of course, the magnificent [Android native browser](http://www.zdnet.com/blog/networking/the-number-one-mobile-web-browser-googles-native-android-browser/2091)
will mess this up, thinking that `278` is an error code: so if, for
your HTTP request, you have a callback in case of success and
one in case of an error, the latter will be triggered.

How to deal with this?

Well, we decided to return straight `200 Ok` codes and include
2 custom headers, `X-Location` and `X-Status-Code`, that our
clients will parse to find out if they need to update the
browser's URL.

In pseudo-code:

```
res = http.get('api.example.org?search=BMW')

if (res.status_code === 200 && res.headers.x-location) {
	browser.url = res.headers.x-location
}
```

## Reverse proxies and HTTP cache

{% img left /images/varnish-cache.jpg%}

Two of the most [important directives](http://www.mnot.net/blog/2007/12/12/stale) 
that you can use while taking advantage of the HTTP cache
are `stale-while-revalidate` and `stale-if-error`:
the former lets you return stale responses
while you revalidate the cache while the latter lets you serve
cached responses if your backend is down (`50X` errors).

Of course, you will need a reverse proxy in front
of your webserver in order to really take advantage of
these directives: [Squid](http://www.squid-cache.org/) natively implements
both of them but, in our case, it was too much of a hassle to setup,
as it's bloated compared to its cousin [Varnish](https://www.varnish-cache.org/),
which doesn't natively implement `stale-*` directives instead.

Setting up Varnish to support those 2 directives it's a matter
of a few tries anyhow, as you can mimic the (almost) same 
behaviors with Varnish's [grace and saint modes](https://www.varnish-software.com/static/book/Saving_a_request.html#core-grace-mechanisms).

## Android's native browser

{% img right /images/android.jpg %}

Android, oh Android!

## Performances on old devices

## What a hard time debugging browser events

## Authentication

## A note on AngularJS and the Grunt ecosystem

## Internet Explorer. As always.

## CORS and HTTP headers

## How to do RUM?

## All in all...