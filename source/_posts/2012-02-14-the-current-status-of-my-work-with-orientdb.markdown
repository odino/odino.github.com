---
layout: post
title: "The current status of my work with OrientDB"
date: 2011-05-24 14:09
comments: true
categories: [orientdb, orient, open source]
alias: "/349/the-current-status-of-my-work-with-orientdb"
---

Since I just merged everything on the master, on [GitHub](https://github.com/odino/Orient), I made a few decisions about the OrientDB PHP library ( named Orient ) lifecycle.
<!-- more -->

Great news: **we are compatible with the RC1 version of OrientDB** ( the README on GitHub is not updated, sorry ).

Since the RC2 snapshot has been released, I'll look if something is broken.

## What's new?

As [I said](http://www.odino.org/348/the-query-builder-for-orientdb), the huge work for the query builder has been done: you can find it in the `beta-2` tag.

Now we're only waiting integration tests and the resolution of [a bug in OrientDB's SQL parser](http://code.google.com/p/orient/issues/detail?id=374&q=quotes).

## The old stuff?

I fixed some links from my first post talking about [OrientDB and PHP](http://www.odino.org/328/graph-in-php-through-orientdb), through the binding of the library.

If you want to use it, just use the `beta-1` tag.

## What's coming?

We plan to have 4 beta releases in the next 3/4 months:

* `beta-3`, which marks the end of the whole query builder, meaning that all the new SQL commands are integrated in the QB and integration tests are done
* `beta-4`, where we will be able to retrieve hydrated records from a query executed with the QB: it obviously includes annotations on your domain POPOs
* `beta-5`, in which you'll be able to manage repository classes
* `beta-6`, when you will be able to persist records through the document manager

## Wanna help?

Help would be really appreciated: not only in writing bunches of code, but also in helping with the design of the whole library; for example, I just asked in OrientDB ML questions about [protocols interoperability in PHP](https://groups.google.com/d/topic/orient-database/0hPWojYPJ9Q/discussion).

Feedbacks on this kind of stuff are really welcome.

## What's ok with this library?

The aim is to build a general purpose library to manage OrientDB from PHP: having loosely coupled components means that you'll be able to use the query builder to build SQL statements, or the binding to query OrientDB with raw strings through the HTTP protocol.

Keyword: decoupling; that's why we're already thinking about **interoperability**.

Anton Terekhov is building the binding for the [binary protocol](https://github.com/AntonTerekhov/OrientDB-PHP), so we don't want, for example, to force people to use the HTTP one, and that's why the design of the whole library is made preventing coupling between components.

## Ah, I was forgetting about...

You can download the library and, with phpunit, run the tests ( the integration one, for the binding, are disabled by default, since they require a working instance of OrientDB ) with:

```
phpunit --configuration=Test/PHPUnit/phpunit.xml
```

from the root of the library.

I've setup also the PHP_CodeSniffer code analysis, just run:

```
chmod +x report.sh
./report.sh 
```

and look into `log/report/index.html` with a browser.