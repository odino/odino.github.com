---
layout: post
title: "Using the Proxy pattern to implement lazy-loading"
date: 2012-11-23 10:38
comments: true
categories: [PHP, design patterns, Proxy pattern, orient]
published: false
---

This article mainly comes from what I've seen
in [Doctrine 2](http://www.doctrine-project.org/) and I tried to replicate in
[Orient](https://github.com/congow/Orient), an Object Document Mapper for
OrientDB, written in PHP: even though PHP
doesn't have a very good support for
metaprogramming and [AOP](http://en.wikipedia.org/wiki/Aspect-oriented_programming), proxying can be
really easy to implement and useful to
accomplish hard tasks.
