---
layout: post
title: "Please welcome the Doctrine2 OrientDB ODM"
date: 2012-12-28 23:12
comments: true
categories: [orientdb, doctrine, nosql, orientdb-odm]
---

It took almost 2 years from the
[first commit](https://github.com/doctrine/orientdb-odm/commit/65929ec57a2e2cb1f4af034d722e17b5339b9d48),
but [OrientDB](http://www.orientdb.org/)'s [PHP ODM](https://github.com/doctrine/orientdb-odm)
has been finally moved to the
[Doctrine](https://github.com/doctrine/)
organization.

<!-- more -->

## New daddy

I've blogged [so many times](/blog/categories/orientdb/)
about an imminent
integration into the Doctrine ecosystem, but
due to the workload of our contributors and
some major issues we wanted to solve before this,
we were only able to seriously approach the
Doctrine team today.

This is a very good news, as we will be able
to take advantage of the experience of all the
doctrine contributors as well as have a bigger stage
where we can show the ODM: the biggest part of the
ODM is still pending (persistence), but
HTTP binding, query builder and object
hydration are working like a charm, and the few
bugs that we face in [real-world scenarios](https://github.com/odino/sharah)
are solved in a matter of minutes.

## And now?

All the namespaces have been changed, so the old
`Congow\Orient` has been replaced by
`Doctrine\ODM\OrientDB` and `Doctrine\OrientDB`:
if you were already using the library, you will need
to work on the migration a bit.

You may also want to have a look at the new
[Packagist page](https://packagist.org/packages/doctrine/orientdb-odm),
as it contains the references to the new repository.