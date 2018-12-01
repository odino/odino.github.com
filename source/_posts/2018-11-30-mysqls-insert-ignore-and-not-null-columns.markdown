---
layout: post
title: "MySQL's INSERT IGNORE and NOT NULL columns"
date: 2018-11-30 18:35
comments: true
categories: [database, MySQL]
description: "Hatin' on MySQL's INSERT IGNORE, as it's probably more dangerous than you think."
---

Last week I was working on an application that has an idempotent
API, meaning the same request can come in multiple times without
generating errors or side effects: the request can be safely
replayed, as it won't affect the state of the server.

Since I was using MySQL as a storage engine behind this API, `INSERT IGNORE`
was my first thought.

What a tragic mistake.

<!-- more -->

## Hidden problems with IGNORE

Let's create a dummy table with a couple fields:

``` sql
CREATE TABLE `item` (
  `id` INT(11) COLLATE utf8_unicode_ci AUTO_INCREMENT NOT NULL,
  `title` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `reference` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY (`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
```

Let's say we want to insert in this table a list of items
we have to sell -- each item will have a unique human-readable
title and a reference in our system.

Let's add some records into our system:

``` sh
mysql> INSERT INTO item (title, reference) VALUES("iPad - the best tablet in the world", "IPAD-64GB");
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO item (title, reference) VALUES("iPad - the best tablet in the world", "IPAD-64GB");
ERROR 1062 (23000): Duplicate entry 'IPAD-64GB' for key 'reference'
```

as expected, the second insert fails it an item with the same reference already
exists in the database.

Now, suppose that we'd like to allow for our API to allow sending the
same request twice wthout throwing an error -- we can use
an `INSERT IGNORE`:

``` sh
mysql> SELECT * FROM item;
+----+-------------------------------------+-----------+
| id | title                               | reference |
+----+-------------------------------------+-----------+
|  1 | iPad - the best tablet in the world | IPAD-64GB |
+----+-------------------------------------+-----------+
1 row in set (0.00 sec)

mysql> INSERT IGNORE INTO item (title, reference) VALUES("iPad - the best tablet in the world", "IPAD-64GB");
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SHOW WARNINGS;
+---------+------+-------------------------------------------------+
| Level   | Code | Message                                         |
+---------+------+-------------------------------------------------+
| Warning | 1062 | Duplicate entry 'IPAD-64GB' for key 'reference' |
+---------+------+-------------------------------------------------+
1 row in set (0.00 sec)

mysql> 
```

Perfect, we tried to re-insert a record with an existing reference
and the query went through, without throwing errors or adding / updating
records in the DB.

Now, this is exactly what `INSERT IGNORE` is supposed to do: trigger an
insert and, if it causes an error, don't make a fuss out of it.

But...Surprise, surprise! Let's try with a slightly different query:

``` sh
mysql> SELECT * FROM item;
+----+-------------------------------------+-----------+
| id | title                               | reference |
+----+-------------------------------------+-----------+
|  1 | iPad - the best tablet in the world | IPAD-64GB |
+----+-------------------------------------+-----------+
1 row in set (0.00 sec)

mysql> INSERT IGNORE INTO item (reference) VALUES("SOMETHING");
Query OK, 1 row affected, 1 warning (0.01 sec)

mysql> SHOW WARNINGS;
+---------+------+--------------------------------------------+
| Level   | Code | Message                                    |
+---------+------+--------------------------------------------+
| Warning | 1364 | Field 'title' doesn't have a default value |
+---------+------+--------------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM item;
+----+-------------------------------------+-----------+
| id | title                               | reference |
+----+-------------------------------------+-----------+
|  1 | iPad - the best tablet in the world | IPAD-64GB |
|  6 |                                     | SOMETHING |
+----+-------------------------------------+-----------+
2 rows in set (0.00 sec)

mysql> 
```

What the heck is happening here? Rather than silencing an error
(no value provided for the non-nullable column `title`) the
`INSERT IGNORE` simply decides that it's better to let the `INSERT`
go through with all the missing non-nullable values set to an empty
string -- which is something I wasn't expecting at all.

## ON DUPLICATE KEY

I simply decided to convert my `INSERT IGNORE`
to `ON DUPLICATE KEY` in order to avoid sloppy clients
sending data without some required fields and then
finding empty strings all over the database.

The switch was very simple:

``` sh
mysql> SELECT * FROM item;
Empty set (0.00 sec)

mysql> INSERT INTO item (title, reference) VALUES("iPad - the best tablet in the world", "IPAD-64GB") ON DUPLICATE KEY UPDATE id  = id;
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO item (title, reference) VALUES("iPad - the best tablet in the world", "IPAD-64GB") ON DUPLICATE KEY UPDATE id  = id;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM item;
+----+-------------------------------------+-----------+
| id | title                               | reference |
+----+-------------------------------------+-----------+
|  7 | iPad - the best tablet in the world | IPAD-64GB |
+----+-------------------------------------+-----------+
1 row in set (0.00 sec)

mysql> 
```

...and that's about it: I must say I was very surprised at this behavior
but I guess it makes sense since `INSERT IGNORE` ignores **all** errors,
not just duplicate key ones.

To be honest, it looks like I'd better stop using `INSERT IGNORE`
sooner rather than later :)

Adios!