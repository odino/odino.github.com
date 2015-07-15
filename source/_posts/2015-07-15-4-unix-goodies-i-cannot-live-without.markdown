---
layout: post
title: "4 unix goodies I cannot live without"
date: 2015-07-15 14:15
comments: true
categories: [unix, linux]
---

In the past few years I managed to discover
some nice unix / unix-inspired utilities that
are, simply, life-savers.

Not sure if you already know all the
stuff here, but I hope you'll be able to find
this brief list useful!

<!-- more -->

## watch

Ever needed to run a command multiple times at a certain interval?
Enter [watch](http://www.linfo.org/watch.html).

(funny enough, my friend [Cirpo](https://twitter.com/cirpo)
yesterday told me "*Why do everytime I have to look for a unix command I end up on a bad-looking webpage?*")

Anyhow, at its core, `watch -n X cmd` simply re-executes `cmd` every `X`
seconds:

```
~  ᐅ watch -n 1 "mysql -h 127.0.0.1 -u root -proot -e 'show processlist;'"

Every 1.0s: mysql -h 127.0.0.1 -u root -proot -e 'show processlist;'                                                                                                                 Wed Jul 15 18:30:19 2015

Id      User    Host    db      Command Time    State   Info
10      root    172.17.42.1:56805       NULL    Query   0       init    show processlist
```

Useful when you're waiting for something to happen!

## htop

If you are familiar, and possibly frustrated with, [top](http://www.unixtop.org/man.shtml) you will
definitely love [htop](https://github.com/hishamhm/htop).

{% img center /images/htop.png %}

In general, just imagine top with a better user-interface and
an intuitive way to sort, filter and so on.

## $?

Oh Jesus, help with exit codes here!

Ever ran a program to then wondered what its exit code was?
You can simply do it with a `$?` which will return the exit
code of the last command you executed:

```
/tmp/test  ᐅ ls -la
total 44
drwxrwxr-x  2 odino odino  4096 Jul 15 18:40 .
drwxrwxrwt 24 root  root  40960 Jul 15 18:40 ..
/tmp/test  ᐅ echo $?
0
/tmp/test  ᐅ ls -la non-existing
ls: cannot access non-existing: No such file or directory
/tmp/test  ᐅ echo $?
2
/tmp/test  ᐅ  i-dont-exist
zsh: command not found: i-dont-exist
/tmp/test  ᐅ echo $?
127
/tmp/test  ᐅ
```

## screen

You SSH into a server, run a command, the internet goes off...profanities all
around you!

Had you used [screen](http://aperiodic.net/screen/quick_reference), this
wouldn't have happened!

With screen, you will:

* create a new terminal session with `screen -S executing-long-command`
* launch your command
* switch off your laptop
* go home
* have a shower
* hopefully have some [qeema](https://en.wikipedia.org/wiki/Qeema) for dinner
* check if your command was successful by SSHing into the remote server again
and re-attaching onto your session with `screen -r executing-long-command`

[Boom baby!](http://www.urbandictionary.com/define.php?term=boom+baby&defid=2707082)

## Bonus: mysql's \G

A hidden gem I really like to use is the `\G` option when doing `SELECT`s,
which will format returned records in a very particular way (vertically-aligned, though it's
only doable for queries that return very few results):

```
mysql> SELECT * FROM TABLES LIMIT 1;
+---------------+--------------------+----------------+-------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
| TABLE_CATALOG | TABLE_SCHEMA       | TABLE_NAME     | TABLE_TYPE  | ENGINE | VERSION | ROW_FORMAT | TABLE_ROWS | AVG_ROW_LENGTH | DATA_LENGTH | MAX_DATA_LENGTH | INDEX_LENGTH | DATA_FREE | AUTO_INCREMENT | CREATE_TIME         | UPDATE_TIME | CHECK_TIME | TABLE_COLLATION | CHECKSUM | CREATE_OPTIONS | TABLE_COMMENT |
+---------------+--------------------+----------------+-------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
| def           | information_schema | CHARACTER_SETS | SYSTEM VIEW | MEMORY |      10 | Fixed      |       NULL |            384 |           0 |        16434816 |            0 |         0 |           NULL | 2015-07-15 14:56:18 | NULL        | NULL       | utf8_general_ci |     NULL | max_rows=43690 |               |
+---------------+--------------------+----------------+-------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+-------------+------------+-----------------+----------+----------------+---------------+
1 row in set (0.03 sec)

mysql>
mysql>
mysql>
mysql>
mysql>
mysql>
mysql> SELECT * FROM TABLES LIMIT 1\G
*************************** 1. row ***************************
  TABLE_CATALOG: def
   TABLE_SCHEMA: information_schema
     TABLE_NAME: CHARACTER_SETS
     TABLE_TYPE: SYSTEM VIEW
         ENGINE: MEMORY
        VERSION: 10
     ROW_FORMAT: Fixed
     TABLE_ROWS: NULL
 AVG_ROW_LENGTH: 384
    DATA_LENGTH: 0
MAX_DATA_LENGTH: 16434816
   INDEX_LENGTH: 0
      DATA_FREE: 0
 AUTO_INCREMENT: NULL
    CREATE_TIME: 2015-07-15 14:56:21
    UPDATE_TIME: NULL
     CHECK_TIME: NULL
TABLE_COLLATION: utf8_general_ci
       CHECKSUM: NULL
 CREATE_OPTIONS: max_rows=43690
  TABLE_COMMENT:
1 row in set (0.04 sec)
```

Neat, ah?
