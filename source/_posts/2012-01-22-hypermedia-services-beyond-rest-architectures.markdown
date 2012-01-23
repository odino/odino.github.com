---
published: false
layout: post
title: "Hypermedia services: beyond REST architectures"
date: 2012-01-22 12:04
comments: true
categories: [REST, HATEOAS, hypermedia, webservice]
---

RESTafarians should support the abandon of the
original term - REpresentational State Transfer -  in favour of 
some fresh new words.
<!-- more -->

## RESTcalation ##

REST became popular as an alternative to [SOAP](http://www.w3.org/TR/2000/NOTE-SOAP-20000508/)
in writing webservices.

They are different and some kind of complementary in so many ways: first of all,
**SOAP is not an architectural style**; this is pretty interesting since lot of people
actually think that **REST *equals* some kind of API style**.

It was pretty obvious that REST would have gained so much attention:

* sold as **SOAP's nemesis**, while developers were starting to feel frustrated
with the WS-* stack
* it seemed so simple: GET, POST, 404, 200, Cache-Control and you're done
* many RAD frameworks were using URI templates, so it seemed that using such
this kind of schemes was a **really good standardization** (while, in fact, they
are coupling-prone{% footnote_ref 1 %}, one of the aspects that REST fights)

REST has - basically - 5 constraints ( the sixth one is
[Code On Demand](http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_1_7),
but it's not *that* important ):

* client/server communication
* stateleness
* caching
* layering
* uniform interface

and, on the web, mainly with the HTTP protocol, people have been able to build:

* client/server models
* stateless communications
* cacheable resources
* layered systems{% footnote_ref 2 %}

What's missing? The **uniform interface**.

## What is REST's uniform interface? ##

The greatest example of uniform interface is the [HTTP protocol](http://my.safaribooksonline.com/9780596809140/1):
something able to make 2 pieces of software talk an [ubiquitous language](http://domaindrivendesign.org/node/132).

Think about HTTP verbs, status codes and media types which are transported along the
network: without HTTP everything would be a mess, **a complete mess**.

Thanks to the HTTP protocol we are [able to face most of the real-world use-cases we need
to model in our software with a universal way to communicate applications' workflows](http://tomayko.com/writings/rest-to-my-wife).

## What is the greatest feature that the HTTP protocol leveraged? ##

This{% footnote_ref 3 %} wouldn't be sensational omitting two things which explain
why the web has been able to tremendously benefit from its uniform interface:
**media types** and **hyperlinks**.

Media types are basically the contract{% footnote_ref 4 %} between a client and
a server, which defines how they should communicate and exchange resources: an
example is `application/xml`, another one is `text/plain`: never forget that
you can have *vendor-specific* media types (in [DNSEE](http://www.dnsee.com) we have
used our own `application/vnd.dnsee.ses.+xml;v=1.0`{% footnote_ref 5 %}, an XML -
atom-based - dialect), if you are not ok with re-using existing types from the
[IANA registry](http://www.iana.org/assignments/media-types/index.html).

Media types are not only bound to HTTP responses' bodies, since - before even
parsing a response's body - machines can agree on exchanging informations in a
specific format:

``` bash The Accept header of an HTTP request
Accept: text/*, text/html
```

The `Accept` header seen above is an example of how a client tells a server
**which media types it understands**: 

* `text/*` is accepted, telling the server that any kind of text-based media
type can be succesfully interpreted by the client
* being a declination of `text/*`, `text/html` should be the preferred response
format

Servers can behave in different ways based on the media-type requested or used by
clients: for example, if the client POSTs a new resource with a media type the
server doesn't get, it will receive back a `406 Not Acceptable` status code.

All these practices have a name, **content negotiation**, which is applied not
only to media types but also to more human concepts, like responses' language:

``` bash Content negotation based on the language of the resource
Accept-Language: en; q=1.0, it; q=0.7
```

Acceptance is not the only criteria used to instantiate a correct communication
at the protocol level: for example, if the server  - on a certain resource -
provides an `Allow: HEAD, GET` and the client PUTs at that resource it will
receive a `405 Method Not Allowed` back.

Another important aspect of the web's success is the extensive usage of
**hypermedias**.

{% blockquote Roy Fielding http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven#comment-718 REST API must be hypertext-driven %}
When I say hypertext, I mean the simultaneous presentation of information and
controls such that the information becomes the affordance through which the user
(or automaton) obtains choices and selects actions. Hypermedia is just an
expansion on what text means to include temporal anchors within a media stream;
most researchers have dropped the distinction.
{% endblockquote %}

When talking about hypermedia on the web, we usually imagine **hyperlinks**:

``` html A simple example of web link
<a href="http://amazon.com" >Cool stuff</a>
```

without considering that hyperlinks can be really complex data structures:

``` html A more complex hyperlinking example
<a 
  href="http://amazon.com/payment/2068"
  rel="payment"
  hreflang="en"
  type="text/html"
  name="amazon-payment-2068"
>Cool stuff</a>
```

and that they are not bound to (X)HTML documents:

``` xml Atom link indicating how to edit a resource
<link href="/personas/100" rel="edit" type="application/json">Modify this!</link>
```

Given this, let's analyze how to refactor a *plain-old-XML* document:

``` xml An XML document representing a person and its city
<persona>
  <id>38</id>
  <avatar>http://personas.com/avatar.jpg</avatar>
  <description>...</description>
  <city>
    <name>Rome</name>
    <description>...</name>
  </city>
  ...
</persona>
```

We can throw some basic hypermedia to the mix:

``` xml The XML document refactored
// import the atom namespace
<persona>
  <id>38</id>
  <avatar>http://personas.com/avatar.jpg</avatar>
  <description>...</description>
  <atom:link href="http://example.org/cities/302" rel="http://example.com/cities" type="application/xml" />
  ...
</persona>
```

This is important for some factors:

* payload: your response is lightweight
* caching: you fragment your resources, having the possibility to specify different
*time-to-live*
* fallbacks: getting a `404` on the city, a client is able to render a response
saying that informations on the city are currently unavailable, but the main
object - person - is complete

and many others that you can imagine.

Pushing forward this *linking passion*, here's how you solve URI templates
coupling:

``` bash When a resource is created, tell the client its address
201 Created
Location: /personas/24
```

``` bash When a resource is moved, tell the client its new address
301 Moved Permanently
Location: /api/personas/24
```

A more complex example of the advantages of *going hyperlinked*?
[Cache channels](http://ietfreport.isoc.org/idref/draft-nottingham-http-cache-channels/)
, which let you build more efficient, reliable and scalable services.

## No one knows

Never talked about [media types](http://tools.ietf.org/html/rfc3023) with your
colleagues?    
Ordinary.

Never heard about [hreflang](http://www.w3.org/TR/html4/struct/links.html#adef-hreflang)
attributes in hyperlinking?    
Ordinary.

Don't you know the difference between `text/xml` and `application/xml`?    
Ordinary.

Never seen how the [Atom Publishing Protocol](http://www.ietf.org/rfc/rfc5023.txt)
solved the "[lost update](http://www.w3.org/1999/04/Editing/)" problem?    
Less ordinary, but I can't judge you.

So REST failed: most of the times we hear people talking about REST they discuss about 
building **plain-old-XML over HTTP webservices*, without even knowing the importance of
having an extensible infrastructure supporting updates and not breaking
retrocompatibility with your consumers.

## What we should advertise/support? ##

**Hypermedia services** and **hypermedia-aware clients**.



{% footnotes %}
  {% fn URI templates would not be a problem - per sè - if developers wouldn\'t forget about decoupling URIs with the application\'s flow %}
  {% fn Layered system are now a big part of the web, not only of the enterprise world, thanks to social services and the social web: in order to face webscale problems we now need - more than ever - reverse proxies, gateway caches, the cloud... %}
  {% fn Machine-To-Machine ubiquitous communication %}
  {% fn As stated earlier in some of my posts or at some conferences, REST has contracts (called media types) just like SOAP has WSDLs %}
  {% fn "ses" stands for Service Expression Synthax %}
{% endfootnotes%}