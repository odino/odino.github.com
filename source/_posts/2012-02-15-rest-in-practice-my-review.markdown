---
layout: post
title: "REST in practice, my review"
date: 2011-03-26 23:24
comments: true
categories: [book]
alias: "/312/rest-in-practice-my-review"
---

I'm home after the [NoSQL day](http://www.nosqlday.it/) in Brescia, a great community-driven event, that I will recap on the next post: since I went to Brescia by train ( 4 + 4 hours ) I had the opportunity, after 20 days on intense love for this book, to finish it, so I publish my thoughts about.
<!-- more -->

{% img right /images/rip.jpg %}

I decided to buy this book because of its subtitle, **hypermedia and system architectures**, since I'm exploring the world of media types, hypermedia formats and how they improve semantics and evolvability, I was wondering if it could gave me a good overview about the right implementation of hypermedia-driven services.

## Richardson maturity model

This book has a great start, driving you from level 0 to 3 of the [Richardson Maturity Model](http://martinfowler.com/articles/richardsonMaturityModel.html): you'll be guided from writing an HTTP-tunneling service to an hypermedia-driven one, with the intermediate of an HTTP-loving CRUD.

These are fundamental steps because you will basically climb a mountain discovering:

* how to write an HTTP-tunnel
* how to write a better HTTP tunnel
* how an HTTP-loving CRUD works
* how to implement the [hypermedia tenet](http://en.wikipedia.org/wiki/HATEOAS) in your services

## Caching

An entire chapter was dedicated on [caching strategies](http://www.odino.org/301/rest-better-http-cache), in order to explain how to scale well from this point of view.

Starting from the explicit admission of **WWW's weak consistency**, the book guides you through HTTP's cache specification and how to correctly implement HTTP's cache on your system: it deserves a mention the fact that the authors explained really well why **cache invalidation is bad for the web** ( invalidation assumed that the server should know the state of N clients ).

## AtomMix

In the middle of this, the book starts to tightly couple with the Atom format and the AtomPub publishing protocol: it explains very well how to use Atom as a flexible and extensible format, and AtomPub to re-use a common but valid workflow for your Domain Application Protocol.

## A soft end

The last chapters are both interesting and soft to read: they deal with web security, semantics, **SOAP** and the **WS-* world**.

I really liked how it compares web oriented architectures to SOAP and WS, because it doesn't yell at anyone and doesn't blame ( too much :-P ) that world.

Security chapter deals with the OpenID and OAuth protocols but didn't really convinced me: I'm probably not so well documented about them to get into what the book tried to explain; semantics was a great chapter instead: [OWL](http://en.wikipedia.org/wiki/Web_Ontology_Language), [RDF](http://en.wikipedia.org/wiki/Resource_Description_Framework) and [SPARQL](http://www.w3.org/TR/rdf-sparql-query/) are well integrated with the code you previously built.

## Is it the right book for me?

If you don't know anything about REST, you probably need it: it explains very well how ( and **why** ) to implement a semantic hypermedia-driven service from nOOb to master. There's so much theory that you will find it really explanatory.

If you know this architectural style but want to get deeper into it, like me, the book won't disappoint you too: I lacked at security and semantics and was courious about authors' vision about hypermedia, so this book was really helpful to me.

There are a lot of code examples, in both .NET and Java ( I scrolled some pages really fast :) ), so you won't miss *that* part.