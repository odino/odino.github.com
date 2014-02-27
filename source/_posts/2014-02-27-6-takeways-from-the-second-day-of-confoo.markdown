---
layout: post
title: "6 takeways from the second day of ConFoo"
date: 2014-02-27 18:27
comments: true
categories: [ConFoo, conference, web, performance]
---

Today it was an interesting day here at ConFoo, and I've
seen some good content dealing with web performances.

<!-- more -->

## Don't pollute domain models with specifications

{% img right /images/odino-confoo-2.jpg %}

During a very good talk I was waiting for since the conference started,
[Mathias Verrase](http://twitter.com/mathiasverraes) has been talking
about DDD and domain models and has shown to the audience how you
should not pollute them with specifications.

The proposed approach introduces a bit more verbosity with the advantage
of having cleaner models that reflect your domain.

So, instead of having models knowing the business specification:

```
$customer->isPremium();
```

you might want to refactor the code in a way that makes the
information as part of a business rule (hence, the *specification*),
that will accept a subject in order to verify that it actually
satisfies the rule / specification:


```
$premiumSpecification->isSatisfiedBy($customer);
```

## Optimizing images

[Imageoptim]() is a very handy tool to losslessly compress images
and save bandwidth while serving them.

## gzip_static

Instead of gzipping each and every assets *on-the-fly* you can tell `nginx`
to look for a previously gzipped version of the same file.

Compile `nginx` with this option enabled:

```
./configure --with-http_gzip_static_module
```

and then turn it on:

```
gzip_static on;
```

## Turn off tcp_slow_start_after_idle

[Turning off window resizing](http://www.lognormal.com/blog/2012/09/27/linux-tcpip-tuning/)
(or... downsizing) after a slow start will help clients who take a while
to send back packets over the same, slow, TCP connection, as it doesn't resize
the TCP window contrary to what the system would do by default.

## Pagespeed at nginx level

I already knew about [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed)
but totally forgot to use it :)

## More RUM monitoring tools

I've come across [mpulse](https://mpulse.soasta.com) which is another RUM platform.

Even though their UI is a bit old school, they're (of course) real-time and provide
valuable insides, like pageload times and DOM rendering performances.

Sign up on their site, it's free up to 1M visits a month!

## All in all

Good day for optimizations and delivering a faster experience to your users, looking
forward to my third day - with my last talk, about SOAs - in this cold land!