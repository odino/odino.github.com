---
layout: post
title: "Get prepared for OrientDB's query builder "
date: 2011-06-03 13:46
comments: true
categories: [orientdb]
alias: "/357/get-prepared-for-orientdb-s-query-builder"
---

As you can see on [Github](https://github.com/odino/Orient/commits/master), today we fixed all the minor issues of the beta-3 milestone of the [Orient](https://github.com/odino/Orient) library ( a set of tools to manage OrientDB in PHP ).
<!-- more -->

Since the only thing left is to write the query-builder integration tests ( which will directly speak with OrientDB ), we are confident that the next release, the [beta-3](https://github.com/odino/Orient/issues?milestone=1&state=open), will happend during this weekend.

Writing the remaining tests will take a man-day circa so, since I'm pretty focused on releasing as early as possible, we should see this component coming out soon.

For those of you who don't know what is gonna come in this release ( which is not "official" but intended for early adopters ), I can tell you that the main thing will be the query-builder and nothing more: the QB is an OO library in order to build OrientDB SQL commands with a nice fluent interface, in Doctrine 1 style.

By the way: in [DNSEE](http://www.dnsee.com/) we are currently setting-up our brand strategies to expose this and other products ( mainly the CMF ), so, in a few weeks, you should be able to reach something like components.dnsee.com ;-)