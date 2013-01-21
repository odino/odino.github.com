---
layout: post
title: "Starting to play with the Doctrine OrientDB ODM"
date: 2013-01-20 23:00
comments: true
categories: [Doctrine, OrientDB, orientdb-odm]
published: false
---

Since I am actively playing around with it, I
wanted to share some snippets to use the
[Doctrine OrientDB ODM](https://github.com/doctrine/orientdb-odm)
in your PHP applications.

<!-- more -->

## Prelude

In the last few weeks I've started working,
for fun **and** profit, to a personal project,
nothing really exciting as of now.

The thing is, since I wanted to get back on some
cool piece of software, I decided to go for
OrientDB for the persistence and a
mini-framework *a-la* Symfony2 as foundation for the
PHP application - I actually considered NodeJS first,
but I need a prototype in 2 months so...

Point being, I'd like to share with you my basic
approach to the OrientDB ODM.

## The container

Given I've been inspired to Symfony2,
instantiating the main ODM classes
happens in the DIC:

``` yml container.yml
services:
  orientdb.binding.parameters:
    class: Doctrine\OrientDB\Binding\BindingParameters
    arguments:
      host:     127.0.0.1
      port:     2480
      username: admin
      password: admin
      database: DBNAME
  orientdb.binding:
    class: Doctrine\OrientDB\Binding\HttpBinding
    arguments:
      parameters: @orientdb.binding.parameters
  odm:
    class: Doctrine\ODM\OrientDB\Manager
    arguments:
      mapper: @odm.mapper
      binding: @orientdb.binding
  odm.mapper:
    class: Doctrine\ODM\OrientDB\Mapper
    arguments:
      documentProxyDirectory: %base-dir%/tmp/
      annotationReader: @odm.annotation-reader
    calls:
      - [setDocumentDirectories, [ %base-dir%/src/PROJECT/Entity/ : "PROJECT\Entity" ] ]
  odm.annotation-reader:
    class: Doctrine\ODM\OrientDB\Mapper\Annotations\Reader
    arguments:
      cacheReader: @cache.array
  cache.array:
    class: Doctrine\Common\Cache\ArrayCache    

parameters:
  base-dir: /Users/odino/Sites/PROJECT
```

As you see, you need:

* the `Manager`, which requires a `Mapper` and a connection to
OrientDB through a binding class implementing the
`Doctrine\OrientDB\Binding\BindingInterface`
* the `Mapper`, which requires a directory where it can write
proxy classes (for lazy loading), and an annotation reader
(this is not required, I'll explain it later), plus a source
directory to locate entities
* the `HttpBinding`, used by the `Manager`, that does raw
queries to the OrientDB server
* the `Annotations\Reader`
* a cache implementing the interface `Doctrine\Common\Cache\Cache`:
in dev environments it is needed since `ApcCache` is the default
one, and you would need to flush APC every time you change an
annotation in your entities (we will probably change it and put
`ArrayCache` by default, so that you will need to tweak the live
environment, not the dev one)

## Autoloading

The autoloading is straightforward, thanks to the `PSR-0`; the
only thing that you should keep in mind is that you will need
to specify a separate autoloader for proxy classes, since they can
be generated wherever you want (ideally, in a temporary folder,
since they should be removed every time you deploy):

```php autoload.php
<?php

require_once __DIR__.'/../vendor/symfony/symfony/src/Symfony/Component/ClassLoader/UniversalClassLoader.php';

use Symfony\Component\ClassLoader\UniversalClassLoader;

$loader = new UniversalClassLoader();

$loader->registerNamespaces(array(
    'Symfony'                       => __DIR__.'/../vendor/symfony/symfony/src',
    'Doctrine\Common'               => __DIR__.'/../vendor/doctrine/common/lib',
    'Doctrine\OrientDB'             => __DIR__.'/../vendor/doctrine/orientdb-odm/src',
    'Doctrine\ODM\OrientDB'         => __DIR__.'/../vendor/doctrine/orientdb-odm/src',
    'Doctrine\OrientDB\Proxy'       => __DIR__.'/../tmp',
));

$loader->register();
```

You should set the autoloader for `Doctrine\OrientDB\Proxy`
accordingly to the argument `documentProxyDirectory` of the
`odm.mapper` service.

## Entities

Following what we specified in the `container.yml`,
entities should be located in
`%base-dir%/src/PROJECT/Entity/` and follow the namespace
`PROJECT\Entity`:

```php 
<?php

namespace PROJECT\Entity;

use Doctrine\ODM\OrientDB\Mapper\Annotations as ODM;

/**
* @ODM\Document(class="user")
*/
class User
{    
    /**
     * @ODM\Property(name="@rid", type="string")
     */
    protected $rid;
    
    /**
     * @ODM\Property(type="string")
     */
    protected $email;
    
    /**
     * @ODM\Property(type="string", notnull="false")
     */
    protected $nick;
    
    /**
     * @ODM\Property(type="linklist")
     */
    protected $addresses;
    
    /**
     * Returns the nickname of the user, or his email if he has no nick set.
     * 
     * @return string
     */
    public function getNick()
    {
        return $this->nick ?: $this->getEmail();
    }
    
    public function setNick($nick)
    {
        $this->nick = $nick;
    }
    
    public function getEmail()
    {
        return $this->email;
    }
    
    public function setEmail($email)
    {
        $this->email = $email;
    }

    public function getAddresses()
    {
        return $this->addresses;
    }
    
    public function setAddresses($adresses)
    {
        $this->addresses = $addresses;
    }
    
    public function getRid()
    {
        return $this->rid;
    }
    
    public function setRid($rid)
    {
        $this->rid = $rid;
    }
}
```

As you see, mapping an entity is pretty easy:
the first annotation is at class level, to define
which OrientDB classes are mapped by the entity,
then for every property that you want to be 
persisted / hydrated, you define another annotation and
public getters / setters; if you want the property to be
public, you dont need getters / setters.

The property-level annotation has 3 parameters:

* **type**: defines the type of the property in OrientDB
( `boolean`, `link`, `linklist`, `string`, `integer`, etc )
* **name**: the name of the attribute in the OrientDB class
(you might have a PHP property called `$createdAt` and in OrientDB
you call it `created_at`)
* **notnull**: defines whether the property can be `null` or not{% fn_ref 1 %}

## What about controllers?

You can access the ODM from within
controllers of your application by
just using the container:

``` php PROJECT/Controller/User.php
<?php

namespace PROJECT\Controller;

use Project\Entity\User;

class UserController
{
	public function somethingAction()
	{
		$user 		= new User();
		$manager    = $this->getService('odm');

		$manager->...
	}
}
```

## Repositories

At this point, after boostrapping the environment and creating your first entity,
you might want to play with the repository in your controllers, to
manipulate and retrieve collections:

``` php PROJECT/Controller/User.php
<?php 

$manager    	= $this->getService('odm');
$userRepository = $manager->getRepository('PROJECT\Entity\User')
```

then, with the repository, you can start retrieving objects:

``` php Using the repository
<?php

// find all users
$userRepository->findAll();

// find one user given its RID
$userRepository->find($rid);

// find all users with the nick "overlord"
$userRepository->findByNick("overlord");

// find the user with the nick "TheOnlyOverlord"
$userRepository->findOneByNick("TheOnlyOverlord");

// find jack's wife
$jack  = $userRepository->findOneByName("Jack");
$wifey = $userRepository->findOneBySpouse($jack); // spouse is an attribute of type "link"
```

and it's not over, since you can, of course, add
**custom repository classes**.

Custom repositories must be located in the entity's folder
and follow the naming convention `EntitytheymapRepository`:
for our `User` entity, we would need to create a `UserRepository`
class in `%base-dir%/src/PROJECT/Entity/`:

``` php PROJECT\Entity\UserRepository
<?php

namespace PROJECT\Entity;

use Doctrine\ODM\OrientDB\Repository;

class UserRepository extends Repository
{
    /**
     * Retrieves a random user.
     * 
     * @return \PROJECT\Entity\User
     */
    public function findRandomUser()
    {
        return array_rand($this->findAll());
    }
}
```

so then you can call your new methods over repositories:

``` php Using custom repositories
<?php

$manager->getRepository('PROJECT\Entity\User')->findRandomUser();
```

## Can I haz raw queries?

Entities and repositories are good, but what about
adding some `SQL+`{% fn_ref 2 %} to the mix?

That's very easy, thanks to the **query builder**
that's packed with the ODM:

``` php Example queries
<?php

use Doctrine\OrientDB\Query\Query;

// instantiate a query object
$query = new Query();

// simple SELECT
$query->from(array('user'))->where('nick = ?', $nick);

// throwing some spice into the mix
$query->orWhere('attribute = ?', $attribute)
	  ->orWhere('(this IS NULL OR that IS NOT NULL)')
	  ->limit(10)
	  ->orderBy(...);

// SELECTing a single record
$query->from(array($rid));

// SELECTing two records
$query->from(array($rid1, $rid2));
```

When you manipulate the `$query` object you are basically
creating an SQL query with an object-oriented fluent interface;
to eventually execute the query, just pass the object to
the `Manager`:

``` php Executing a query
<?php

$query = new Query();
$query->from(array('user'))->where('gender = ?', "male");

$males = $manager->execute($query);
```

## Point being, how do you save data?

Since persistence is not already handled by the `Manager`,
you will need to use raw queries for now:

``` php Saving data
<?php

$user = array(
  'name' => 'Jack'
);

$query = new Query();
$query->insert()->into('user')->fields(array_keys($user))->values($user);

$manager->execute($query);
```

## From the trenches

We've been very active since a couple months,
and we've actually been able to roll out some major
bugfixes and improvements (more than 10 in the last
few weeks):

* repositories [filtering by multiple criterias](https://github.com/doctrine/orientdb-odm/issues/138)
* [custom repository](https://github.com/doctrine/orientdb-odm/issues/139) classes
* added ability to [map timestamps](https://github.com/doctrine/orientdb-odm/issues/141) as DateTime objects
* unable to [update attributes if they are a collection](https://github.com/doctrine/orientdb-odm/issues/144)
* support for [INSERTing collections](https://github.com/doctrine/orientdb-odm/commit/cbd9c3250d1fd6fc7ec1f39566b91d1f0e1531f2)
* proxy classes dont [import signatures](https://github.com/doctrine/orientdb-odm/issues/147)
* `findBy*` and `findOneBy*` ["magic" methods](https://github.com/doctrine/orientdb-odm/issues/149)
* [fetchplans in `find*`](https://github.com/doctrine/orientdb-odm/issues/150) methods of repositories
* following `SQL+`, added [`REBUILD INDEX` command](https://github.com/doctrine/orientdb-odm/issues/99)

I would not advise you to install one of the old tags,
or even the last one, which brings the namespace
changes for the incubation in the Doctrine
organization, but to install it directly from master
via composer:

``` json
"doctrine/orientdb-odm": "dev-master",
```

as we are constantly doing bugfixes and so on
(I would day you would get an update - at least -
every week).

That is it, now **start playing around!**

{% footnotes %}
	{% fn Be aware that if you are retrieving a property which is NULL in the DB and you don't declare it as NULLable, an exception will be thrown (and there is an issue to improve the exception message https://github.com/doctrine/orientdb-odm/issues/152) %}
	{% fn OrientDB's QL is called SQL+, as it looks like SQL but has some major improvements, as it's very developer-friendly %}
{% endfootnotes %}