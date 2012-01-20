---
layout: post
title: "Edge Side Includes, how to spare terabytes every day"
date: 2012-01-20 14:15
comments: true
categories: [ESI, HTTP, scaling]
---

I have an idea for an RFC that I would like to write, based on some thoughts I
had in the last months.
<!-- more -->

Lots of you probably know [ESI](http://www.w3.org/TR/esi-lang), the specification
written by [Akamai](http://www.akamai.com/) and [Oracle](http://www.oracle.com/index.html)
back in 2001.

It basically consists in a XML dialect which lets [reverse proxies](http://en.wikipedia.org/wiki/Reverse_proxy)
(eg. [Varnish](https://www.varnish-cache.org/)) cache fragments of your webpages
in order not to hit your application for output fragments that can be re-used
across many clients.

``` html A webpage including an ESI tag
<html>
  <head>
    ...
  </head>
  <body>
    ...

    long pile of crap

    ...

    <esi:include src="http://example.com/footer.html" />
  </body>
</html>
```

A **really good presentation** about ESI is [Caching On The Edge](http://www.slideshare.net/fabpot/caching-on-the-edge/99)
, by [Fabien Potencier](http://fabien.potencier.org/).

## ESI's context ##

ESI is a really great technology that recently gained hype, in my ecosystem (PHP),
thanks to the Symfony2 architecture, fully embracing the HTTP specification:
consider that Symfony2 has **no application-level caching layer**, so everything
is done with the HTTP cache, and ESI is the solution for really dynamic webpages.

...but who's responsible of processing ESI fragments?

{% blockquote %}
Processing ESI tags is a matter of an ESI processor
{% endblockquote %}

Thanks, captain obvious.

Digging some more, an esi processor can be a [middleware in your architecture](http://rack.rubyforge.org/)
, a reverse proxy or a [software component](http://symfony.com/doc/2.0/book/http_cache.html#using-edge-side-includes)
; basically any kind of software implementing the ESI specification.

But hey, all this kind of things are softwares that lie in the server side.

## A different approch ##

I was thinking about pushing ESI to the client side.

Ugly idea, cause if the browser is capable to merge different fragments, retrieved
with different HTTP requests, for assembling a really simple webpage you would
need to hit your application far more times than a single request.

``` html The response retrieved with the browser would generate lots of subrequests
<html>
  <head>
    ...
  </head>
  <body>
    <esi:include src="http://example.com/header.html" />
    <esi:include src="http://example.com/navigation.html" />
    <esi:include src="http://example.com/foo.html" />
    <esi:include src="http://example.com/bar.html" />
    <esi:include src="http://example.com/footer.html" />
  </body>
</html>
```

So there is no real need to ask for ESI support in clients, in this scenario.

But there's a *real-world* application of ESI in the client side that should
**save lot of traffic** over the internet and **lot of bandwith**.

**Rarely-changing output fragments**.

A RCOF - sorry for this bad acronym - is everything that can be **cached for
relatively long time** (talking more about days than hours), like Facebook's
footer of your google analytics JS code.

{% img center /images/fb.footer.png %}

## The use-case

Why should we always transport Facebook's footer over the network?

We don't need this waste: once the user landed on his profile page, as he jumps
to other FB pages, the footer it's always the same, and should be retrieved from
the client's cache instead of being sent over the network.

## A few numbers

## Client side ESI invalidation

If you are scared about invalidating this kind of cache, the solution would be
really easy:

``` html Facebook before updating the footer
<html>
  <head>
    ...
  </head>
  <body>
    ...

    Pile of FB crap

    ...

    <esi:include src="http://example.com/footer.html?v=1" />
  </body>
</html>
```

``` html Facebook after updating the footer
<html>
  <head>
    ...
  </head>
  <body>
    ...

    Pile of FB crap

    ...

    <esi:include src="http://example.com/footer.html?v=2" />
  </body>
</html>
```

Note the revision change in the ESI tag, something we already, daily, use for
managing static assets' caching.

## Opinions?

I don't wanna sound arrogant proposing this tecnique, but I would really like to
get feedbacks about such this kind of approach.