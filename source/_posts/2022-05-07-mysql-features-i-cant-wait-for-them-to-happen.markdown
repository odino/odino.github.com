---
layout: post
title: "MySQL features I can’t wait for them to happen"
date: 2022-05-07 14:32
comments: true
categories: [MySQL, database]
---

Having worked with MySQL for over ten years, and having had the chance to
see other storage engines at work during my career, I've developed a list of 
features that I'd like to see MySQL implement. The inspiration of this post comes
from the implementation of [SKIP LOCKED](https://www.percona.com/blog/2020/08/03/using-skip-lock-for-queue-processing-in-mysql/) in v8 -- which was one of the items in my
bucket list :)

<!-- more -->

## TTL

I recently bumped into [Google Cloud Spanner's TTL feature](https://cloud.google.com/spanner/docs/ttl), which I love:
you can specify a policy to delete "old" rows from a table you don't care
about anymore. 

The [doc](https://cloud.google.com/spanner/docs/ttl/working-with-ttl#syntax) is pretty self-explanatory:

```sql
CREATE TABLE MyTable(
  Key INT64,
  CreatedAt TIMESTAMP,
) PRIMARY KEY (Key)
, ROW DELETION POLICY (OLDER_THAN(CreatedAt, INTERVAL 30 DAY));
```

Over the course of my career I've had to setup a whole bunch of
jobs that would, at intervals, have to go and delete rows from a
table, and would be an enthusiastic user of this feature!

## Record archival

Similar to the above, archival of records would be pretty neat.

I haven't bumped into this problem just yet (or when I did, I simply
opted for getting rid of those old rows), but being able to support
record archival would be fun, for example by specifying a dynamic
set of tables records would end up in after a certain time:

```sql
CREATE TABLE rider_location (
    id_rider INT ...,
    created_at TIMESTAMP ...
) ...
ARCHIVE (OLDER_THAN(created_at), INTERVAL 1 MONTH)
IN rider_location_%yyyy_%mm
```

and then you would need to go and query `rider_location_2022_01`
to get records that were initially inserted in January.

## Implicit GROUPing

This is easily one of my biggest frustrations -- having such a verbose
implementation of `GROUP BY` without being able to infer grouping columns
implicitly. 

I'm talking about having to write:

```sql
SELECT city, district, age, gender, count(*)
FROM users
GROUP BY 1,2,3,4
```

instead of:

```sql
SELECT city, district, age, gender, count(*)
FROM users
```

having the engine implicitly use selected columns that aren't aggregated
with functions such as `MIN`, `count(...)` or `AVG` by default.

[Folks at DZONE have summed it up pretty well](https://dzone.com/articles/how-sql-group-should-have-been), 
so I'll let you go through their article and see what kind of solution
they've proposed.

## Table and DB aliases

Countless of times I've made mistakes naming tables and DBs
([it's one of the hard things at the end of the day!](https://martinfowler.com/bliki/TwoHardThings.html))
and I would love to be able to specify DB and table name aliases
without having to think about renaming / migrating them
altogether -- table names are more manageable, so that's
probably something I don't really need (though it would still
be helpful to migrate tables used by different sets of apps eg.
writer and reader apps), but DB aliasing would make me fairly happy :)

## Want more?

I'm sure I'm forgetting some big ticket item, but these above would
already make the ergonomics of working with MySQL a lot smoother for me.

What would *you* like to see in MySQL instead? Feel free to
reach out on [twitter](https://twitter.com/_odino_)!