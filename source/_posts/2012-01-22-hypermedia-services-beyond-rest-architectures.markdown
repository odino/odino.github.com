---
published: false
layout: post
title: "Hypermedia services: beyond REST architectures"
date: 2012-01-22 12:04
comments: true
categories: [REST, HATEOAS, hypermedia, webservice]
---

As discussed earlier, the problem with REST is that **tons of people got it
wrong**: that's why *RESTafarians* should support the abandon of the
original term - REpresentational State Transfer -  in favour of 
some fresh new words.
<!-- more -->

## RESTcalation ##

REST became popular as an alternative to SOAP{LINK} in writing webservices.
Puah.

They are different and complementary in so many ways: first of all, SOAP is not
an architectural style; this is pretty interesting since lot of people actually
think that **REST = type of webservice**.

It was pretty obvious that REST would have gained so much attention:

* sold as **SOAP's nemesis**, while developers were starting to feel frustrated with the WS-* stack
* it seemed so simple: GET, POST, 404, 200, Cache-Control and you're done
* many RAD frameworks were using URI templates, so it seemed that using such this kind of
schemes was a *really good standardization* (while, in fact, they are coupling-prone, one
of the aspects that REST fights)

## The missing brick ##

So the problem with REST is the word itself: it wasn't able to suggest people how
build scalable architectures, with long-term lifecycle, but seemed to gain hype only
because of the misconceptions that were surrounding the whole thing.

REST has - basically - 5 constraints ( the sixth one is Code On Demand{LINK}, but it's
nor mandatory neither *that* important ):

* client/server communication
* stateleness
* caching
* layering
* uniform interface

and, on the web, mainly with the HTTP protocol, people have been able to build:

* client/server models
* stateless communications
* cacheable resources
* layered systems, thanks to services' needs (think at reverse proxies, load balancers, the cloud)

What's missing? The **uniform interface**.

## What is REST's uniform interface? ##

The greatest example of uniform interface is the HTTP protocol: something able to
make 2 pieces of software talk an ubiquitous language.

Think about HTTP verbs, status codes and media types which are transported along the
network: without HTTP everything woulb be a mess, **a complete mess**.

Thanks to the HTTP protocol we are able to face most of the real-world use-cases we need
to model in our software with a universal way to communicate applications' workflows.

## What is the greatest feature that the HTTP protocol leveraged? ##

## A failure so far

So REST failed: most of the times we hear people talking about REST, but they discuss about 
building *plain-old-xm over HTTP* webservices, without even knowing the importance of
having an extensible infrastructure supporting updates and not breaking retrocomptibility
with your consumers.

## What we should advertise/support? ##

**Hypermedia services** and **hypermedia-aware clients**.



## Why hypermedia? ##
