---
layout: post
title: "Generating a MD5 hash in NodeJS"
date: 2018-11-30 17:36
comments: true
categories: [JavaScript, NodeJS, crypto]
description: "How to generate an MD5 hash in NodeJS without relying on a 3rd party module."
---

A few days ago I wanted to integrate gravatar in
one of the applications I'v been working on, and
realized gravatar still uses MD5 for hashing the
user's email.

<!-- more -->

I was wondering whether I would need
an [external module](https://www.npmjs.com/package/md5)
to generate the hash, but quickly realized the native
`crypto` can do the trick:

``` js
const crypto = require('crypto')

let hash = crypto.createHash('md5').update('some_string').digest("hex")
```

It really doesn't get any easier than that -- adios!