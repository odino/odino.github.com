---
layout: post
title: "Search engines are making the web slower"
date: 2012-04-07 10:00
comments: true
categories: [scaling, web, performances]
---

Like it or not, pushing the work to the clients is
a tecnique which made the web able to scale the way
it is now: **search engines are making it slower** and
less scalable, as they don't want us to do so.
<!-- more -->

The problem is that JavaScript - the *creepy* JavaScript -
is now recognized as a first-level programming language{% fn_ref 1 %},
although SE are around since more than a decade: thus,
crawlers and spiders, although able to interpretate basic
JS code, cannot do more complex stuff, like managing
[Handlerbars](http://handlebarsjs.com/) or [HInclude](http://mnot.github.com/hinclude/).

Or, at least, we don't know if they can.

There would be a workaround to this kind of issue, by just
**serving different content for JS-aware clients**, so that a
spider could see the whole resource without the need of
executing JS code: a workaround that would cost in terms of
development time, but still an acceptable workaround.

The problem, here, is that tis tecnique, known as [cloacking](http://en.wikipedia.org/wiki/Cloaking)
is part of the [black hat SEO](http://en.wikipedia.org/wiki/Search_engine_optimization#White_hat_versus_black_hat) list, so you basically can't take 
advantage of it as malicious web developers would use
cloacking to serve keyword-stuffed contents to bots and
"normal" webpages to humans, and this is something you
really want to avoid, since SERPs' relevance is an
important part of a user's eb experience.

But, at least, we don't know how search engines would react
to the workaround I just explained.

## What do we need?

We should have clarifications from SE vendors, to know whether
they are able or not to let us take advantage of great JS-based
technologies able to make our applications scale better, or - better -
have fully JS-aware spiders and crawlers, able to elaborate
resources like real-world browsers.

It's not about me, it's not about you, it's about the web: a faster,
and **definitely better**, web.

{% footnotes %}
  {% fn Mainly because of the NodeJS hype %}
{% endfootnotes %}
