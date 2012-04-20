---
layout: post
title: "Back in track with OrientDB"
date: 2012-04-20 15:26
comments: true
categories: [OrientDB, open source, NoSQL]
---

It's been a while since I don't release any update about
Orient, the PHP data mapper for OrientDB: we recently got
back on track and I have a few interesting news.
<!-- more -->

I just moved to Dubai, as you may know, so the last couple
of months have been a huge mess for me, while David was
doing some [major experiments](https://github.com/congow/Orient/tree/persistence)
for the library: we only had the time, at the end of March,
to talk about OrientDB and the ODM at the
[Codemotion](http://www.slideshare.net/ingdavidino/graph-db-inphp).

Since in the last week we restarted pairing together to
finalize a few open things in the library, I will explain what
is the current status of Orient.

## Beta-5

We decided to put back our effort on the `beta-5` release,
instead of letting me complete the issues still belonging
to this version by myself.

In these days we are finalizing the integration tests for
OrientDB's native data types, and refactoring a bit the
implementation of the **hydration mechanism**, which will be more
configurable: we will release an ODM able to let the developer
decide what to do when an hydration error occurs (in other words,
you mapped an attribute as integer but in the OrientDB record
that attribute is mistakenly set as a date): before this
refactoring process `null` was returned by default, but now
you'll be able to decide whether to [force the casting or raise an exception](https://github.com/congow/Orient/blob/master/src/Congow/Orient/Formatter/Caster.php#L520) for these errors.

As we complete these 2 tasks, we will remove the TODOs from
the codebase and then we will release this version which,
I remind it for those who are not up-2-date with the library's
lifecycle, is the one introducing **hydration**, which is the
ability to run SQL queries against an OrientDB instance and map
the results as PHP objects.

Similarly to Doctrine2, Orient offers the ability to map objects
from PHP to OrientDB via annotations:

``` php
<?php

use Congow\Orient\ODM\Mapper\Annotations as ODM;

/**
* @ODM\Document(class="Address")
*/
class Address
{
    /**
     * @ODM\Property(type="link")
     */
    public $city;
}

```

## Doctrine ODM

From the beginning, we've been committed in finding a way to make
[interoperability](https://github.com/congow/Orient/blob/master/src/Congow/Orient/Contract/Protocol/Adapter.php#L23)
a feature of Orient: another side of this issue is the fact that
we tried to stick to Doctrine2's design for lots of our problems,
from the implementation of mapping to lazy-loading through
auto-generated proxy classes.

In the last weeks I pro-actively asked the Doctrine2 community if they
would be happy in welcoming this project in their community, and the
responses we received were positive: as a result, after going out with
the `beta-5` release we will refactor the library's namespaces and move
the repository on Github.

There will be lots of things to do, lot of code to refactor, lot of
complaints from the Doctrine2 core members because of our "strange"
code, but this is a huge step towards a more robust PHP library
for OrientDB.

## Beta-6

After the incubation inside the Doctrine organization we will re-start
working on the `beta-6` version, which will bundle **persistence** - the
ability to persist mapped PHP objects into OrientDB, using a couple
well known design patterns like the [unit of work](http://martinfowler.com/eaaCatalog/unitOfWork.html)
and the [identity map](http://martinfowler.com/eaaCatalog/identityMap.html).

I won't commit myself in an estimate: **this will take a long time**,
especially if only me and [David](http://davidfunaro.com) will keep
the good work on this library.

But since we had **huge contributions** from 
[Daniele Alessandri](https://github.com/nrk) and
are gonna be part of the Doctrine community, I bet we will be able to
deliver what promised in less than then what I currently think.

## RC

Last but not least, there will be a few planned refactorings and feature
add-ons that we don't need now but are mandatory for a decent stable
version, which will come as we roll out our first `RC`. 

## Thanks, again

I could not keep my effort and motivation constant during
[this year](https://github.com/congow/Orient/commit/65929ec57a2e2cb1f4af034d722e17b5339b9d48)
without your many "thank you", your enthusiasm and
encouraging words: this is what makes me eager to type
with my fat fingers new LoCs dealing with PHP and NoSQL.

This won't be a library I wrote{% fn_ref 1 %}, this is something an entire
community was waiting for and contributed to.

So, *thank y'all*.

{% footnotes %}
  {% fn Although I still remember the first commit on Github: I was only wearing my underwear, alone in the hall of my flat %}
{% endfootnotes %}
