---
layout: post
title: "OrientDB ODM beta 5: repositories, compatibility with 1.2.0 and more stability"
date: 2012-11-23 09:10
comments: true
categories: [orientdb, orient, odm, php]
published: true
---

It has almost been a baby's delivery, but we eventually made it:
the PHP [ODM](http://css.dzone.com/articles/era-object-document-mapping) for [OrientDB](http://code.google.com/p/orient/) has finally reached its **5th beta**.

<!-- more -->

Thanks to the huge effort of [David Funaro](http://davidfunaro.com) and the push from [Marco Pivetta](https://twitter.com/Ocramius) we
have just released the `beta-5` version of this library, which lets
you work with the infamous GraphDB in PHP: there is a plethora of
changes and some news about the future of the library, so I'll try
to recap a bit what we've done so far in almost **one year** of
active development.

## Composer

The entire library (query builder, HTTP binding and ODM) is now
*composerified* (have a look at the [dependencies](https://github.com/congow/Orient/blob/beta-5/composer.json#L24)):
this was an important step since we wanted to completely get
rid of git submodules and embrace this new and - sorry PEAR -
finally decent packaging system for PHP.

## Symfony2: gimme MOAR

We hate the [NIH approach](http://en.wikipedia.org/wiki/Not_invented_here), so whenever there is a library which is tested, decoupled
and does what we need, we tend to use it instead of rewriting from scratch some new
userland code.

This has been the case for our filesystem classes, that - as they were first very simple
but tended to grow - have now been replaced with the [Symfony2 finder](http://symfony.com/doc/2.0/components/finder.html).

At the same time we also added the [ClassLoader component](http://symfony.com/doc/2.0/components/class_loader.html), which replaces
our old [PSR-0 compatible basic autoloader](https://github.com/congow/Orient/blob/beta-5/test/PHPUnit/bootstrap.php).

## Compatibility with the stable OrientDB 1.2.0

OrientDB is stable [since months](http://www.h-online.com/open/news/item/NoSQL-Document-Graph-database-OrientDB-1-0-released-1576260.html),
we couldn't release a version of our library without
upgrading the compatibility to OrientDB (we were still at version `1.0-rc6`):
we are now compatible with OrientDB `1.2.0`.

The move has been quite easy thanks to the test suite that we have
built so far, but we are still probably missing a few features
introduced in `1.1` and `1.2`: as soon as we will go on with the
library we will map what the OrientDB team has added to the DB -
for example, [functions](http://nuvolabase.blogspot.com/2012/09/orientdb-supports-functions.html).

## Fetchplans integrated in the Manager

[Fetchplans](http://code.google.com/p/orient/wiki/FetchingStrategies) specify the way OrientDB should lazy-load records:
we have now [added support to them](https://github.com/congow/Orient/commit/57a5c33ebb02ba8c3d738c2abe1de1c27ba4e846),
meaning that if you dont want to lazy-load linked records (`*:-1`),
the ODM is able to read the entire result from OrientDB and
build linked records as PHP objects (or array of objects).

In the [example](https://github.com/congow/Orient/commit/57a5c33ebb02ba8c3d738c2abe1de1c27ba4e846#L12L74),
you see that `$post->comments`:

* is an array (which eventually contains objects)
* is not a `Proxy\Collection`, which would mean it's a collection of lazy-loaded records

by just using the correct fetchplan:

``` php
<?php

$post = $this->manager->find('27:0', '*:-1');

var_dump($post->getComments(); // an array of objects, no lazy-loading
```

## Repositories

We implemented the [repository pattern](https://github.com/congow/Orient/blob/beta-5/src/Congow/Orient/ODM/Repository.php) - as
Doctrine 2 does: you are now able to access
virtual collections and retrieve records
through them:

``` php
<?php

use Congow\Orient\ODM\Manager;

$manager    = new Manager(...);
$repository = $manager->getRepository('Users');

$user = $repository->find($id);
```

## Doctrine persistence

Since one of our aims is to be as compatible
as possible with Doctrine's ODMs, we integrated
the [*Persistence* interfaces from Doctrine 2](https://github.com/congow/Orient/issues/71):
most of the methods are not implemented yet (`throw new Exception()`),
as actual persistence should come in `beta-6`/`rc-1`, but
the good news is that when retrieving objects from the DB
you can still use the same APIs that the Doctrine ODMs
provide you.

## Integration tests

This release was mainly delayed because of
integration tests{% fn_ref 1 %}: we promised a fully-tested
hydration mechanisms (converting DB records in
POPOs) for `beta-5` and this has been, slowly,
accomplished.

[Repositories](https://github.com/congow/Orient/commit/37cfe0fdad7f0caba2b22cfdce1006ddacfc63e7),
[hydration](https://github.com/congow/Orient/commit/b3706dfb3470eb27e12c4944e398a5d911fe2598)
and [data types](https://github.com/congow/Orient/issues/68)
are now covered by integration tests.

## Refactoring proxies

The way we [generate proxies](https://github.com/nrk/Orient/commit/0bed0196f83c6048b971accbe2d80f3a8c81c31b) is one of the
most interesting parts of the library:
with this release we changed the way we
do it in order to provide
a **more flexible and straightforward
mechanism for doing lazy-loading**.

Usually when you retrieve a record in OrientDB
you won't have related records:

``` bash SELECT FROM Address LIMIT 1
{
  "result": [{
		"@type": "d", 
		"@rid": "#19:0", 
		"@version": 6, 
		"@class": "Address", 
		"type": "Residence", 
		"street": "Piazza Navona, 1", 
		"city": "#21:0", 
		"nick": "Luca2"
    }
  ]
}
```

as you see, by default OrientDB doesn't
retrieve the related record (`city`), but
provides a *pointer* to that record (the `RID`).

When you retrieve a record via the `Manager` class,
the ODM doesn't return you a [POPO](https://github.com/congow/Orient/blob/beta-5/test/Integration/Document/Address.php), but a [proxy class
that overrides the POPO](https://github.com/congow/Orient/blob/beta-5/test/proxies/Congow/Orient/Proxy/test/Integration/Document/Address.php), allowing lazy-loading.

Proxy classes, basically, just call parent methods,
and if the parent method has something to return:

* if the *returnable* is a string, an array, etc **or a POPO**, they return it
* if the returnable is an `AbstractProxy` object,
it means that there is a record/collection of records
that have to be loaded from OrientDB with an extra-query

``` php Code example to understand lazy-loading
<?php

# A proxy class is returned

namespace Congow\Orient\Proxy\test\Integration\Document;

class Address extends \test\Integration\Document\Address
{
      public function getCity() {
        $parent = parent::getCity();

        if (!is_null($parent)) {
            if ($parent instanceOf \Congow\Orient\ODM\Proxy\AbstractProxy) {
                return $parent();
            }

            return $parent;
        }
    }
    public function setCity($city) {
        $parent = parent::setCity($city);

        if (!is_null($parent)) {
            if ($parent instanceOf \Congow\Orient\ODM\Proxy\AbstractProxy) {
                return $parent();
            }

            return $parent;
        }
    }

}

# When calling $address->getCity(), we will actually
# call the __invoke() method of a Proxy object

namespace Congow\Orient\ODM;

use Congow\Orient\ODM\Mapper;
use Congow\Orient\ODM\Proxy\AbstractProxy;

class Proxy extends AbstractProxy
{
    protected $manager;
    protected $rid;
    protected $record;

    /**
     * Istantiates a new Proxy.
     *
     * @param Mapper $manager
     * @param string $rid
     */
    public function __construct(Manager $manager, $rid)
    {
        $this->manager = $manager;
        $this->rid = $rid;
    }

    /**
     * Returns the record loaded with the Mapper.
     *
     * @return object
     */
    public function __invoke()
    {
        if (!$this->record) {
            $this->record = $this->getManager()->find($this->getRid());
        }

        return $this->record;
    }
}
```

As you see, calling the `__invoke()` method
of a proxied object will make the manager do
an extra-query to retrieve the lazy-loaded record.

## Support of sessions in the HTTP client

[Daniele Alessandri](https://github.com/nrk) took his time to add [native support for cookies](https://github.com/congow/Orient/pull/118) in the
HTTP client which is used in the native HTTP binding: thanks
to this we can decide whether to re-use an existing session
while querying the DB.

## Simplified requirements

We have now removed [APC as a requirement](https://github.com/nrk/Orient/commit/bc8f94e7c07147aec1c0c4ed852b7b9d02f4a96c) for the library: since it
was an easy fix we thought it makes sense not to force everyone to have
APC installed everywhere{% fn_ref 2 %}.

## Contributions

I've been pretty busy over the last months, but
the efforts of the already-mentioned Daniele and
David have been [huge](https://github.com/congow/Orient/graphs/contributors?from=2012-03-31&to=2012-11-18&type=c)
to release `beta-5`: I virtually clap my hands
for them, as they are the main reason behind all
of this progress.

## Tests and CI

As always, green tests: the build is handled by
Travis-CI. Also that one [is green](https://secure.travis-ci.org/#!/congow/Orient).

## Doctrine and beta-6

David is already working on refactoring the
namespaces to ask the Doctrine team to
integrate the library into their organization:
as agreed months ago, there shouldn't be a big
problem in doing so.

As this will be **the first ODM for a GraphDB**,
everyone is pretty excited about it:

* we will get more support and contributions for the library itself
* it's the first GraphDB that goes into Doctrine and the PHP world - I mean, **properly**

After that, we will face the [biggest challenges](https://github.com/congow/Orient/issues?milestone=4&page=1&state=open) so far:

* decoupling ODM, HTTP binding and Query Builder into 3 separate libraries/repositories
* refactor a big portion of the codebase according to the feedbacks from the Doctrine community
* implement persistence (from POPOs to DB)

I'm pretty sure the next months will be
productive, intense and full of changes, but
I'd realy like to suggest you one thing before
leaving you: **use this library**.

Even though the ODM is not finished yet, **HTTP binding
and Query Builder are already at a stable stage**:
the first one is **already faster** than the [binary-protocol implementation](https://github.com/AntonTerekhov/OrientDB-PHP),
while the second one is a very convenient library to
help you **saving a lot of time** when writing OrientDB's
SQL+.

Again, their level of maturity is pretty high, and we
accept and review bugs/feature requests pretty fastly.

So, what? Now, there are **no more excuses**.

{% footnotes %}
  {% fn We have a test suite that runs "on paper", meaning that those are tests running based on the OrientDB documentation. Integration tests are done, instead, with a real OrientDB instance %}
  {% fn It is used to provide a basic caching layer for annotations %}
{% endfootnotes %}