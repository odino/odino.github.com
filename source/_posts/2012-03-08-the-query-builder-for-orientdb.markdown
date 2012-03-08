---
layout: post
title: "The query builder for OrientDB"
date: 2011-05-22 13:36
comments: true
categories: [OrientDB]
alias: "/348/the-query-builder-for-orientdb"
---

Just a quick one, to inform you that I just released the [beta-2](https://github.com/odino/Orient/tree/beta-2) tag of the [Orient library](https://github.com/odino/Orient), which is a set of tools to use [OrientDB](http://www.orientechnologies.com/orient-db.htm) in PHP.
<!-- more -->

In this tag, I've added an OO interface to build SQL queries for OrientDB, while some stuff of the binding has been refactored.

If you take a look at some tests ( like the one for the [Select](https://github.com/odino/Orient/blob/beta-2/Test/Query/Command/SelectTest.php) ) you'll notice that everything can be done in Doctrine's style, with a fluent interface:

``` php Sample query
<?php

$this->select(array('name', 'username', 'email'), false)
      ->from(array('12:0', '12:1'), false)
      ->where('any() traverse ( any() like "%danger%" )')
      ->orWhere("1 = ?", 1)
      ->andWhere("links = ?", 1)
      ->limit(20)
      ->orderBy('username')
      ->orderBy('name', true, true)
      ->range("12:0", "12:1");
```

Since we don't have integration tests to test the query builder with a real OrientDB instance ( we based the work on the docs ), I don't encourage you to use the QB now: this post is just a way to tell you that things are going the right way.

Our next step is doing integration tests, so you will finally be able to use the QB in production, and starting to work on the **Object Graph Mapper**.
