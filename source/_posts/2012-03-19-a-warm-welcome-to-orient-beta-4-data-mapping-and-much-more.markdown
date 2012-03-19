---
layout: post
title: "A warm welcome to Orient beta-4: data-mapping and much more"
date: 2011-09-20 16:13
comments: true
categories: [OrientDB]
alias: "/383/a-warm-welcome-to-orient-beta-4-data-mapping-and-much-more"
---

After a great, as usual, monday-mini-hackaton with my colleague [David](http://davidfunaro.com/), I'm happy to announce that Orient has reached its fourth beta: instead of a generic post, I will describe here, step by step, which amazing things you'll be able to do with this new release :)
<!-- more -->

## Data mapping all the way

The biggest feature of this beta-4 is the amount of work done in the Data Mapper: you are now able to hydrate POPOs with a few data types:

* boolean
* binary
* date|datetime
* embedded record|list|set|map
* integer|float
* link, link set|list|map
* byte, long, short and double
* string

To map them, with annotations, is pretty easy:

``` php Mapping in Orient
<?php

class IGottaMap extends IShouldaMap
{
    /**
     * @ODM\Property(name="toMap", type="float")
     */
    protected $to_map;

  ...
} 
```

where `name` is the name of the attribute in OrientDB and type the porting of [OrientDB types](http://code.google.com/p/orient/wiki/Types) in PHP: primitive types are pretty similar ( float is `float`, integer is a value casted with `(int)` and so on ).

## We be lazy

Lazy loading has already been implemented: this means that, if you hydrate through the mapper an object with no related record, but only references to them like

``` 
Object:
  rid: 1:1
  description: my awesome description!
  related_record: 2:1
```

and you call `$object->getRelatedRecord()` the related record is lazily fetched.

Orient's lazy loading is a mix between [Closure-based](http://blog.verraes.net/2011/05/lazy-loading-with-closures/) and [code-generation-based](http://www.odino.org/383/w.doctrine-project.org/docs/orm/2.0/en/reference/working-with-objects.html#entity-object-graph-traversal) LL: once we started trying the Closure implementation, we noticed that there were too many limitations from a developer's point of view ( too much end-developer code to write ), so we started looking at Doctrine2's implementation, which is done using **code generation through proxy classes**.

The idea is really awesome ( I will blog about that later on ) and we were about to start implementing code generation while we realized that using Proxy classes would have seriously limited Orient potentialities: since we don't always know the class of the records connected to our sample record, we could not implement a proxy without forcing the user to explicit the "class" of the related records, which rapes one of the most interesting features of OrientDB, cluster ( = table ) inheritance.

Cluster inheritance means that if I have a record of type `Menu`, he can have a relations `Items` with records of type `ExternalLink`, `NewsLink`, `ProductLink` and so on ( an issue I already discussed ): since we don't want to use OrientDB in the wrong way - because the motivation which pushed us to use OrientDB was that we were using RDBMS for doing the wrong things - we decided to pollute the end-developer's resulting POPOs instead of loosing such a feature.

Polluting POPOs means that, if you want to retrieve a link, or a series of links, you have 2 choices for writing your getters:

``` php
<?php

public function getFriends()
{
    return call_user_func($this->friends);
}

```
or

``` php
<?php

public function getFriends()
{
    $friends = $this->friends;

    return $friends();
} 
```

We also thought about something like:

``` php
<?php


/**
 * @ODM\Property(name="items", type="linklist", classes="ExternalLink, ProductLink, NewsLink, BlaBlaLink, ...")
*/
protected $items;
```

which would have eventually helped us in implementing Doctrine2's proxies, but, as you see, things become ridicolous as your domain grows.

If you want to take a deep look at Orient's lazy loading, just bare in mind that it's implemented using simple, generic purpose Proxy objects that you "execute" ( `call_user_func()` ) with [PHP 5.3's `__invoke` magic method](https://github.com/congow/Orient/blob/beta-4/src/Congow/Orient/ODM/Proxy.php#L44).

## Persisting cURL

Thanks to [Daniele Assandri](https://github.com/nrk)'s [patch](https://github.com/congow/Orient/commit/d77c4ec401dae73ae2625bc154a46054219920a3), we managed [not to restart the curl client](https://github.com/congow/Orient/blob/master/src/Congow/Orient/Http/Client/Curl.php#L78) at every requests of the HTTP binding: this means **faster requests, thus faster responses**.

## Code coverage

In a couple of intense coding sessions we managed to cover almost every class of the library with a unit test: this does not mean we have 100% code-coverage and the software is bug-free, but that's a good starting point.

{% img center /images/cc-beta-4.png %}

## New SQL commands

We added the `TRUNCATE` command, which is used to truncate records, classes or - also - clusters:

``` php
<?php

$query = new Congow\Orient\Query();

$query->truncate('#12:1'); // truncates record 12:1
$query->truncate('myClass;); // truncates class "myClass"
$query->truncate('myClass', true); // truncates cluster "myClass"
```

## Put quality back into LoCs

We are not PHP gurus ( I will never define myself guru in any context ) but we tried to follow a few metrics in order to mantain the internal quality of the software pretty high: if you take a look at what PHPLoC outputs, you will notice that **cyclomatic complexity is low** and **static methods are not as used as you might think**:

{% img center /images/phploc-beta-4.png %}

## Removed constructors from interfaces

Since PHP allows you to insert a constructor in an interface, we started [adding them](https://github.com/congow/Orient/tree/master/src/Congow/Orient/Contract), but we eventually noticed that they limit extensibility.

## Compatibility with OrientDB RC4

Ok ok, **RC5 is out, and we will adjust the compatibility with it in the beta-5 release**: the good news is that, as OrientDB goes on, we don't stop and **tests are always green** :)

## Minor tweaks to the mapper

Like, for exampe, [less coupling to the HTTP protocol](https://github.com/congow/Orient/issues/40) and an [interface for protocol adapters](https://github.com/congow/Orient/issues/44): the latter is one of the most crucial parts of the library, because the adapter let's you **use the data mapper and the query builder with any protocol supported by OrientDB** ( HTTP or binary ).

## What's next?

We're already working on the beta-5 release, which will be a **relaxing release** ( a few refactorings, a couple of other issues ): bare in mind that [implementing doctrine/common's persistence interfaces is in our plans](https://github.com/doctrine/common/tree/master/lib/Doctrine/Common/Persistence), and will probably become real in this next beta.

The next one, beta-6, will deal with the last hard thing, **persisting POPOs to OrientDB**: probably the most difficult thing in the whole library, we are thinking about implementing the [Unit Of Work](http://martinfowler.com/eaaCatalog/unitOfWork.html) there.

So, so, so... May I say that the first RC is targeted during Christmas? :) I said it!
