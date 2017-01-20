---
layout: post
title: "The MySQL ARCHIVE storage engine"
date: 2015-07-25 18:24
comments: true
categories: [mysql]
description: If you want an append-only solution for MySQL, the ARCHIVE engine might be for you
---

Ever wondered how you can treat MySQL as an append-only storage?
Enter the [ARCHIVE storage engine](https://dev.mysql.com/doc/refman/5.5/en/archive-storage-engine.html).

<!-- more -->

{% img right /images/mysql.png %}

I am pretty sure there will be other, more effective and efficient
solutions in the market, but if you want to go the simple way
I guess this is a pretty solid solution.

Append-only storages make it impossible to update  or delete data that has been
written to them (think of logs or a [ledger](https://en.wikipedia.org/wiki/Ledger)),
so that, once an entry is in the DB, you can (kind of) confidently
access the DB knowing that clients won't  be able to screw the data
much. I believe this is a pretty good use-case when you want to enforce
some business logic principles at the storage level.

Of course, it seems like there are some quirks with this
[engine](https://en.wikipedia.org/wiki/MySQL_Archive):

{% blockquote MySQL Archive https://en.wikipedia.org/wiki/MySQL_Archive Wikipedia %}
One of the current restrictions of Archive tables is that they do not support any indexes, thus necessitating a table scan for any SELECT tasks.
[...] MySQL is examining index support for Archive tables in upcoming releases.
The engine is not ACID compliant.
{% endblockquote %}

It is, though, an interesting option for some scenarios: when implementing
a ledger for [Namshi](https://www.namshi.com) we bumped into
this requirement (have an append-only table) but then decided to work it
out at the application level rather than at the storage level, simply because
we didn't find many battle-tested solutions (or a lot of feedback) for
[RDS](http://aws.amazon.com/rds/mysql/), plus the points highlighted by
the article on wikipedia felt a bit *scary*{% fn_ref 1 %} at that time.

{% footnotes %}
  {% fn And, by the way, there isn't much on StackOverflow as well (http://stackoverflow.com/questions/612428/pros-and-cons-of-the-mysql-archive-storage-engine and http://stackoverflow.com/questions/3546567/for-a-stats-systems-whats-better-in-mysql-innodb-archive-or-myisam) %}
{% endfootnotes %}
