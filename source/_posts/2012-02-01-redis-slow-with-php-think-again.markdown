---
layout: post
title: "Redis slow with PHP? Think again!"
date: 2011-01-25 13:56
comments: true
categories: [php, redis]
alias: "/276/redis-slow-with-php-think-again"
---

So [you have a problem](http://www.odino.org/275/approaching-a-cmf-architecture-with-symfony) and think that a NoSQL solution should work for you.

Good.

Then you realize you use PHP.

Damn.
<!-- more -->

As demonstrated in redis' mailing list, there are tons of PHP clients ( also native extensions ) but [they do really suck at performances](http://groups.google.com/group/redis-db/search?group=redis-db&q=php&qt_g=Search+this+group).

I've tried a couple of benchmarks ( not written by me ):

* [https://gist.github.com/794293](https://gist.github.com/794293)
* [https://gist.github.com/794294](https://gist.github.com/794294)

that were basically saying that Redis was able to perform about `11k` SET/GET per second.

The almost same thing, done with MySQL

``` php
<?php

mysql_connect('127.0.0.1', 'root');
mysql_select_db('redis_benchmark');
$query = mysql_query('SELECT * FROM users WHERE id = 1');
 
for ($i = 0; $i < 100; $i++) {
  $start = microtime(true);
  for ($j = 0; $j < 10000; $j++) {
    $key = sprintf("key:%05d", $j);
 
    $persone = mysql_fetch_row($query);
  }
  $time = microtime(true)-$start;
  printf("%6d req/sec\n", $j/$time);
}
```

was identical: `11k` GETs per second.

As Salvatore, the lead developer of Redis, [stated months ago](http://groups.google.com/group/redis-db/msg/2669d6c13361db72), the biggest percentage of benchmarks suck and the problem with PHP is PHP itself.

However [Kijin](http://groups.google.com/group/redis-db/browse_thread/thread/8061cf422260517b/007d8fabaf43705a?lnk=gst&q=php+slow#007d8fabaf43705a) highlighted that the main part of the benchmarks made with PHP are single threaded and not-pipelined.

##What if we only use the pipeline?

Editing the second gist:

``` php
<?php

  $start = microtime(true);
  for ($j = 0; $j < 10000; $j++) {
    $key = sprintf("key:%05d", $j);
    $redis->pipeline();
    /* GET or SET */
    if (rand() % 2 == 0) {
      $redis->set($key, rand());
    } else {
      $redis->get($key);
    }
```

we see that the transaction rate goes up to > `40k` SET/GET per second!

Adding the pipeline to the first gist ( which only does SETs ) make it reach the `90k` SETs per second.

Don't believe?

See it before

{% img center /images/redis-before.png %}

and after

{% img center /images/redis-after.png %}

So, guys, yes, **Redis is fast also with PHP**.