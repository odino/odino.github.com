---
layout: post
title: "How to easily deaggregate an IP address range"
date: 2018-03-08 14:11
comments: true
categories: [networking, linux, sysadmin, devops, SRE]
published: true
description: "Meet ipcalc, one of the most convenient networking tools ever."
---

A few days ago I needed to [nullroute](https://en.wikipedia.org/wiki/Null_route)
an address range, so I found myself with the incredibly tedious task of de-aggregating
IP ranges.

<!-- more -->

Sure that I wouldn't do such thing by hand, I googled around and found [ipcalc](http://jodies.de/ipcalc),
which can be installed on most Linux systems:

```
$ apt-get install ipcalc

$ ipcalc 1.2.168.0 - 1.2.169.255
deaggregate 1.2.168.0 - 1.2.169.255
1.2.168.0/23
```

As simple as that!
