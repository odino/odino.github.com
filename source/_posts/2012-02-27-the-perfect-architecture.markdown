---
published: false
layout: post
title: "The perfect architecture?"
date: 2012-02-27 23:42
comments: true
categories: [scalability]
---

In order to take extreme advantage of the HTTP cache on
both local and shared caches, here's my vision of a
really solid, powerful and scalable architecture.
<!-- more -->

## Components: bye bye ESI

I love ESI but I feel that [HInclude](/scaling-through-hinclude/) is a better
solution for scaling out: there are a few open questions
but the idea I have is that ESI is way less powerful
than fully taking advantage of clients.

Our architecture is composed by:

* the origin server
* a reverse proxy
* HInclude{% fn_ref 1 %}
* `stale` headers

## First user

## A second user

## When it stales

## Why it scales

## Room for improvements

{% footnotes %}
  {% fn Although HInclude is not an architectural element, it plays a huge part here, so it needs to be mentioned. Same would have been for Edge Side Includes. %}
{% endfootnotes %}
