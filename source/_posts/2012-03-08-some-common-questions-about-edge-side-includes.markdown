---
layout: post
title: "Some common questions about Edge Side Includes"
date: 2011-05-30 15:07
comments: true
categories: [ESI, cache]
alias: "/345/some-common-questions-about-edge-side-includes"
---

After my [REST in (a mobile) peace](http://www.slideshare.net/odino/rest-in-a-mobile-peace-whymca-05212011) talk at the WHYMCA in Milan, 2 weeks ago, I was surrounded by a few developers trying better understand how does Edge Side Includes behave: after I realized that some concepts are not so "standard", here's a parade of little things to know about [ESI](http://en.wikipedia.org/wiki/Edge_Side_Includes).
<!-- more -->

## Is it a single-construct language?

No: although the most used tag is the include one:

``` xml Typical ESI tag
<esi:include src="http://www.example.net" />
```

the ESI specification has a [plethora of commands](http://www.w3.org/TR/esi-lang), while the Oracle website has a specific section on more [detailed insights](http://download.oracle.com/docs/cd/B15897_01/caching.1012/b14046/esi.htm).

## If I install Varnish and use ESI, do I need to do something specific?

No: after you set up Varnish in order to do [ESI processing](http://www.varnish-cache.org/trac/wiki/ESIfeatures), everything will magically happen :)

## Do I need, in my architecture, an ESI processor?

Yes, otherwise the ESI tags won't be replaced.

Luckily, Varnish and Squid do it for free since years: the RAD framework for PHP Symfony2 implements a [custom-made reverse proxy](http://www.odino.org/343/symfony2-http-cache-the-good-parts-of-both-of-em) and something is moving also in the [Ruby ecosystem](https://github.com/ramsingla/rack-rsi).

## Does it work with modern browsers?

No: since ESI never got hype browser vendors never thought about implementing the specification.

The topic is also subject of [various arguments](/339/esi-upside-down-will-the-client-be-happier).

## Does ESI invalidate my output format?

No: since ESI processors ( like Varnish ) work on the server side, before sending the response to the clients esi tags get replaced with the actual content.

## Does it work with HTML?

Well, the specification works regardless the format of your response: it can be application/xml, json, html, a custom media type...

## How do I avoid my middleware to look for ESI tags in every response?

Parsing responses, in order to look for ESI tags, is expensive, we all know.

In order to let your ESI processor ignore responses not containing ESI tags you can specify a declination of your content type:

``` bash HTTP response with profile parameter in the media type
HTTP/1.1 200 OK
Content-Type: application/xhtml+xml;profile=esi 
```

and make your processor checking this `profile` attribute.

Unfortunately, it seems that only the `application/xhtml+xml` [supports the `profile` attribute](http://www.ietf.org/rfc/rfc3236.txt), but you can "hack" the media type of your needs and make it support it, since you are working on the server side, without sending non-standardized media type descriptions over the internet.

## How does my application know if it can send ESI tags or not?

There are 2 common scenarios:

* when a middleware supports the ESI specification, and your application can send a response with ESI tags
* when you have no ESI processors in your architecture, and your application should assemble a single whole response

In order to take this decision a custom HTTP header is used: `Surrogate-Capability`, which has been introduced in the [edge side architectures](http://www.w3.org/TR/edge-arch) specification.

## Is ESI a new technology?

10 years old, baby :)
