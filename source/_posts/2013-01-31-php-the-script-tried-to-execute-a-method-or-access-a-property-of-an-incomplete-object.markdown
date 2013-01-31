---
layout: post
title: "PHP: 'The script tried to execute a method or access a property of an incomplete object'"
date: 2013-01-31 13:28
comments: true
categories: [php]
---

Have you ever got this error in PHP? I bet no, never.

<!-- more -->

Basically, it happens when you serialize an object
of class `A` and try to unserialize it when class
`A` doesn't exist anymore.

## How (the hell) do I get there?

If you are working with auto-generated proxy classes,
store objects in the session and then clear your
cache, once you retrieve an object from the session
you are going to face it. A solution is to
re-generate all the proxies before retrieving objects
from the session{% fn_ref 1 %}.

{% footnotes %}
  {% fn in an ideal world, at every deployment you clear and re-generate proxies %}
{% endfootnotes %}