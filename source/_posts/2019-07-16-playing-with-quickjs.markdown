---
layout: post
title: "Playing with QuickJS"
date: 2019-07-16 19:10
comments: true
categories: [JavaScript, QuickJS]
description: "Fabrice Bellard just released QuickJS, a small, embeddable JS engine...and using it is simpler than I thought."
published: false
---

A few days ago [Fabrice Bellard](https://bellard.org/) released
[QuickJS](https://bellard.org/quickjs/), a small JS engine that
targets embedded systems.

Curious to give it a try, I downloaded and set it up on my system
to try and understand this incredible piece of software.

<!-- more -->

## Installation

Setting up QuickJS is *dead* simple:

* clone one of the Github mirrors with `git clone git@github.com:ldarren/QuickJS.git`
* `cd QuickJS`
* `make`

...and that's it: the installation will leave you with a few
interesting binaries, the most interesting one being `qjsc`,
the compiler you can use to create executables out of your JS
code.

## Trying it out

