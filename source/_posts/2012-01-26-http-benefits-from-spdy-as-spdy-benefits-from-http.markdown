---
layout: post
title: "The web benefits from SPDY just as SPDY benefits from HTTP"
date: 2012-01-27 19:27
comments: true
categories: [HTTP, SPDY]
---

In these days [SPDY](http://www.chromium.org/spdy/spdy-protocol) it's gaining
its *momentum* due to a good article which explained how you should build
your [technologic stack in the *realtime* web](http://www.igvita.com/2012/01/18/building-a-modern-web-stack-for-the-realtime-web/).
<!-- more -->

{% img left /images/http.png %}

## HTTP is slowly dying

This seems to be the conclusion that lot of people had after reading that article:
SPDY is a newer, faster, more modern protocol and I have no problem in admitting
that *a few* parts of the HTTP protocol need to be reviewed{% fn_ref 1 %}: you
can't simply advocate that HTTP fits [perfectly](http://lists.w3.org/Archives/Public/www-tag/2011Dec/0034.html)
in today's web, that's a *de-facto* issue.

## SPDY in a nutshell

{% img right /images/spdy.packet.png %}

SPDY is just a **really good protocol implementation**: it supports multiplexing,
**encourages** content compression, allows servers to **push notifications** and
lets you prioritize requests, just to mention the hottest features among
[others](http://www.chromium.org/spdy/spdy-whitepaper).

Amazon is currently shipping its Kindle with a browser that uses this protocol
to communicate with EC2 instances, [Firefox 11 will support it](https://wiki.mozilla.org/Platform/Features/SPDY)
while - if using a google product - you may already be using SPDY{% fn_ref 2 %}:
the road is long, but SPDY seems to be WWW's *next big thing*.

## SPDY needs to love HTTP

Before going out there yelling at HTTP and telling everyone that SPDY will be
the new, futuristic, what-we-were-missing web protocol I want you to consider a
few things.

It should not surprise you the fact that SPDY is [almost-completely](http://www.chromium.org/spdy/spdy-protocol/spdy-protocol-draft2#TOC-HTTP-Layering-over-SPDY)
implementing [RFC2616](http://www.ietf.org/rfc/rfc2616.txt): **the web relies on
established semantics**, clients and servers interact based on a series of
well-known verbs, feedbacks and metadata associated to resources, that are the
only immanent concept of the web.

## Divide et impera: HTTP's soul is here to stay

{% blockquote Mark Nottingham http://www.w3.org/2001/tag/2012/01/06-minutes#item02 HTTP futures and SPDY %}
[We have] 10 years of implementation experience of RFC2616
{% endblockquote %}

You should really reconsider the HTTP protocol as 2 separate layers: its
technical implementation and its interface.

{% blockquote Roy T. Fielding http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#sec_5_1_5 The uniform interface %}
The [HTTP] interface is designed to be efficient for large-grain [...] data transfer, optimizing for the common case of the Web.
{% endblockquote %}

The technical implementation may be a little updated{% fn_ref 3 %} but its
interface was thought to be able to let machine and humans interact with
resources in the most open, fault-tolerant, scalable, robust way we could have
ever thought: **without relying on HTTP, SPDY would not work**, not in the ancient,
not in the modern, not even in the future web.

HTTP 2.0 is close, and [the W3C is not blind](http://www.w3.org/2001/tag/2012/01/06-minutes#item02).

{% footnotes %}
  {% fn To be kind %}
  {% fn If you are currently reading this note with Chrome/Chromium, go here: chrome://net-internals/#events&q=type:SPDY_SESSION%20is:active %}
  {% fn Again, to be kind %}
{% endfootnotes %}