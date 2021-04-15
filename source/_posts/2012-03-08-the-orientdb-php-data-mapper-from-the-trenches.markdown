---
layout: post
title: "The OrientDB PHP data mapper, from the trenches "
date: 2011-05-29 13:32
comments: true
categories: [orientdb]
alias: "/352/the-orientdb-php-data-mapper-from-the-trenches"
---

Yesterday me and David just [started working](https://github.com/odino/Orient/commit/d0558ea63ea4dc20c284542fb9b8ba6e3d0f151f) on the data mapper for OrientDB, pretty inspired by Doctrine2 ORM and MongoDB ODM.
<!-- more -->

As far as I feel, things are really going smooth for now and, as you can see, you are already able to [map POPOs with proper annotations](https://github.com/odino/Orient/blob/440d353ad95b7092497f8e059b5f2b8336d5e614/Test/ODM/Document/Stub/Contact/Address.php), which are parsed using [Doctrine annotation library](https://github.com/doctrine/common).

For now, the mapper is able to hydrate [single records](https://github.com/odino/Orient/blob/440d353ad95b7092497f8e059b5f2b8336d5e614/Test/ODM/MapperTest.php#L84) and [collections](https://github.com/odino/Orient/blob/440d353ad95b7092497f8e059b5f2b8336d5e614/Test/ODM/MapperTest.php#L177), and some [type casting](https://github.com/odino/Orient/blob/9d0d4e6dafa857cf3db2a40ed9aa879456092a68/Test/Formatter/CasterTest.php#L29) has been done ( you are currently able to cast to [boolean, string and datetime objects](https://github.com/odino/Orient/blob/mapper/Test/ODM/Document/Stub/Contact/Address.php#L19) ).

The [query builder](https://github.com/odino/Orient/blob/master/Query.php#L13) will probably be finished in the next 2 weeks ( some SQL indexes operators are missing and, most important, integration tests ), while in the [binding](https://github.com/odino/Orient/blob/master/Test/Foundation/BindingTest.php#L18), thanks to [Daniele Alessandri](https://github.com/nrk), the [HTTP response class](https://github.com/odino/Orient/commit/ea998f894b81f5433fa668966d295d32132d8c8b) has been polished and improved.