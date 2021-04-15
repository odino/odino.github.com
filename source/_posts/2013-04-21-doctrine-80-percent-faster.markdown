---
layout: post
title: "Doctrine 80% faster?"
date: 2013-04-21 10:54
comments: true
categories: [doctrine, php]
---

A post in the *doctrine-dev* mailing list
caught my attention last week, and I want to
share its insights with you.

<!-- more -->

The good [Marco Pivetta](https://github.com/Ocramius)
took initiative in adding proxy generation for hydrators,
and in [a lonely branch](https://github.com/Ocramius/ProxyManager/pull/29)
he's pretty far with the progress on the matter: his 
latest tests show that the [hydration process is improved by 80%](https://travis-ci.org/Ocramius/ProxyManager/jobs/6485136#L127)
which is a very good news, considered metadata-based
software usually need to find a way to drastically
improve performances because of the basic lack of
performances due to having to read metadata.

Hoping to see this changes integrated in a stable
branch very soon!