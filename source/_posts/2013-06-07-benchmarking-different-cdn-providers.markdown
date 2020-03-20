---
layout: post
title: "Benchmarking different CDN providers"
date: 2013-06-07 05:36
comments: true
categories: [performance, cdn, benchmark]
published: false
---

When you decide to go with a CDN for
the static assets of your web applications,
you will of course consider different
providers: while making this choice,
2 very simple and mature tools become
very important to make the right choice.

<!-- more -->

## Akamai or not Akamai?

As everyone knows, Akamai is the biggest
and most reliable CDN provider in the market,
but the downside of using it is that,
unless you come up with big numbers
(and bigger bills) you won't be able
to discuss custom agreements.
For example, if you would need
to scale up with performances
during a specific peak hour of the day,
and rest the rest of the day, I doubt
you would be able to get around a tailored
solution with Akamai{% fn_ref 1 %}.

The general rule, anyhow, is to go
for Akamai as long as your budget allows you
to do so, but there might be certain
situations (as said budget as well as
geographical needs - Akamai is **almost**
everywhere) where you want to check
with 3 or 4 different CDN providers
before closing your research: in
these moments what you should do is
to ask for temporary accounts and start
benchmarking each provider.

For this purpose, [Apache Benchmark](http://httpd.apache.org/docs/2.2/programs/ab.html) and
[Siege](http://www.joedog.org/siege-home/)
will be, among others, you swiss-army
knife.

## Apache Benchmark

## Siege

{% footnotes %}
	{% fn But I can't really say that's true at 100%: you should always check with your trusted Akamai salesman ;-) %}
{% endfootnotes %}