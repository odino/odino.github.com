---
layout: post
title: "Aspect-oriented logging with the Proxy pattern"
date: 2012-11-23 10:39
comments: true
categories: [aop, design patterns, log management, php, proxy pattern]
published: false
---

One of the **key**-missing features
of PHP is the poor support that you
get from the language in terms of
[Aspect Oriented Programming](http://en.wikipedia.org/wiki/Aspect-oriented_programming):
essentially, there is no easy way
to distribute modules (or *aspects*)
of your application (it is usually done
with metaprogramming).

However, thanks to the [Proxy pattern](/proxy-pattern-lazy-loading/)
and a [dependency-injection container](http://fabien.potencier.org/article/12/do-you-need-a-dependency-injection-container),
we can provide a layer supporting a bit
of AOP: in this article we will find out how
to, silently, implement *logging*
without modifying the behaviour of the classes
of your PHP application.