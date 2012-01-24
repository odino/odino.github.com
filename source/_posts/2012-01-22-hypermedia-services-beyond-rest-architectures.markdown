---
layout: post
title: "Media types and hypermedia services: beyond REST architectures"
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
in writing webservices, while, in fact, they are different and some kind
of complementary in some ways: first of all, **SOAP is not an architectural
style**; this is pretty interesting since lot of people actually think that
**REST *equals* some kind of API style**.

It was pretty obvious that REST would have gained so much attention:

* sold as **SOAP's nemesis**, while developers were starting to feel frustrated
with the WS-* stack
* it seemed so simple: `GET`, `POST`, `404`, `200`, `Cache-Control` and you're done
* many RAD frameworks were using **URI templates**, so it seemed that using such
this kind of schemes was a **really good standardization** (while they
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
network: without HTTP
[it would be hard to face most of the real-world use-cases](http://tomayko.com/writings/rest-to-my-wife)
we need to model in our software with a universal way to communicate applications' workflows.

This{% footnote_ref 3 %} wouldn't be sensational omitting two things which explain
why the web has been able to tremendously benefit from its uniform interface:
**media types** and **hyperlinks**.

## Media types

They are - basically - the contract{% footnote_ref 4 %} between a client and
a server, which defines how they should communicate and exchange resources: an
example is `application/xml`, another one is `text/plain`: never forget that
you can have *vendor-specific* media types (in [DNSEE](http://www.dnsee.com) we have
used our own `application/vnd.dnsee.ses.+xml;v=1.0`{% footnote_ref 5 %}, an XML -
atom-based - dialect), if you are not ok with re-using existing types from the
[IANA registry](http://www.iana.org/assignments/media-types/index.html).

Media types are not only important for understanding HTTP responses' bodies,
since - before even parsing a response's body - machines can agree on exchanging
informations in a specific format:

``` bash The Accept header of an HTTP request
Accept: text/*, text/html
```

The `Accept` header seen above is an example of how a client tells a server
**which media types it understands**: 

* `text/*` tells the server that any kind of text-based media
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

## Hypermedia

{% blockquote Roy Fielding http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven#comment-718 REST API must be hypertext-driven %}
When I say hypertext, I mean the simultaneous presentation of information and
controls such that the information becomes the affordance through which the user
(or automaton) obtains choices and selects actions. Hypermedia is just an
expansion on what text means to include temporal anchors within a media stream;
most researchers have dropped the distinction.
{% endblockquote %}

When talking about hypermedia on the web, we usually think about **hyperlinks**:

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

[Cache channels](http://ietfreport.isoc.org/idref/draft-nottingham-http-cache-channels/)
, which let you build more efficient, reliable and scalable services, are a good example
of leveraging the power of hyperlinks in a complex scenario:

``` xml A cache channel: reverse proxies take a loot at them in order to invalidate cached representations
  <feed xmlns="http://www.w3.org/2005/Atom"
   xmlns:cc="http://purl.org/syndication/cache-channel">
    <title>Invalidations for www.example.org</title>
    <id>http://admin.example.org/events/</id>
    <link rel="self"
     href="http://admin.example.org/events/current"/>
    <link rel="prev-archive"
     href="http://admin.example.org/events/archive/1234"/>
    <updated>2007-04-13T11:23:42Z</updated>
    <author>
       <name>Administrator</name>
       <email>web-admin@example.org</email>
    </author>
    <cc:precision>60</cc:precision>
    <cc:lifetime>2592000</cc:lifetime>
    <entry>
      <title>stale</title>
      <id>http://admin.example.org/events/1125</id>
      <updated>2007-04-13T10:31:01Z</updated>
      <link href="http://www.example.org/img/123.gif" type="image/gif"/>
      <link href="http://www.example.org/img/123.png" type="image/png"/>
      <cc:stale/>
    </entry>
  </feed>
```

Hyperlinks are used to connect resources and verify their freshness in a M2M scenario,
and not only rendered by a browser "just" to be clicked by a user.

## REST in the world

Never talked about [media types](http://tools.ietf.org/html/rfc3023) with your
colleagues?    
Ordinary.

Never heard about [hreflang](http://www.w3.org/TR/html4/struct/links.html#adef-hreflang)
attributes in hyperlinking?    
Ordinary.

Don't you know the difference between `text/xml` and `application/xml`?    
Ordinary.

Never thought that if you consume some data, when their URL changes you can still
fetch them without changing any line of code?    
Less ordinary, but I can't judge you.

REST failed: most of the times we hear people talking about REST they discuss about 
building **plain-old-XML over HTTP webservices*, without even knowing the importance of
having an extensible infrastructure supporting updates and not breaking
retrocompatibility with your consumers.

## Enter hypermedia services

{% blockquote Roy Fielding http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_1_5 The uniform interface %}
By applying the software engineering principle of generality to the component interface, the overall system architecture is simplified and the visibility of interactions is improved. Implementations are decoupled from the services they provide, which encourages independent evolvability.
The trade-off, though, is that a uniform interface degrades efficiency, since information is transferred in a standardized form rather than one which is specific to an application's needs.
The REST interface is designed to be efficient for large-grain hypermedia data transfer, optimizing for the common case of the Web, but resulting in an interface that is not optimal for other forms of architectural interaction.
{% endblockquote %}

Hypermedia services are the ones that rely on hypermedia controls in order to efficiently
implement decoupling and avoid breaking retrocompatibility.

For instance, let's look at the *URI templates coupling* problem:

``` bash When a resource is created, tell the client its address
201 Created
Location: /personas/24
```

``` bash When a resource is moved, tell the client its new address
301 Moved Permanently
Location: /api/personas/24
```

``` html Throw some semantic CRUD into the mix
<ul>
  <li>
    <a href="/products/5" rel="update" ... >Product 1</a>
  </li>
  ...
```

## Enter hypermedia-aware clients

{% blockquote Craing McClanahan http://tech.groups.yahoo.com/group/rest-discuss/message/12358 REST-discuss mailing list %}
When the client decides which URI to call and when, they run the risk of attempting to request state transitions
that are not valid for the current state of the server side resource. 
An example from my problem domain ... it's not allowed to "start" a virtual machine (VM) until you have "deployed" it.
The server knows about URIs to initiate each of the state changes (via a POST), but the
representation of the VM lists only the URIs for state transitions that are valid from the current state.
This makes it extremely easy for the client to understand that trying to start a VM that hasn't been deployed yet is not legal, because there will be no corresponding URI in the VM representation.
{% endblockquote %}

Hypermedia-aware clients are those client able to detect, understand, process, ignore hypermedia
controls, making no assumption in consuming a resource.

People should really care about implementing HATEOAS{% footnote_ref 6 %} and HATEOAS-detection,
since it has proven to be a winning factor in writing robust, fault-tolerant, balanced and
durable systems:

{% slideshare 1547275 100% 550 %}

{% footnotes %}
  {% fn URI templates would not be a problem - per sè - if developers wouldn\'t forget about decoupling URIs with the application\'s flow %}
  {% fn Layered system are now a big part of the web, not only of the enterprise world, thanks to social services and the social web: in order to face webscale problems we now need - more than ever - reverse proxies, gateway caches, the cloud... %}
  {% fn Machine-To-Machine ubiquitous communication %}
  {% fn As stated earlier in some of my posts or at some conferences, REST has contracts (called media types) just like SOAP has WSDLs %}
  {% fn "ses" stands for Service Expression Synthax %}
  {% fn Hypermedia As The Engine Of Application State %}
{% endfootnotes%}
