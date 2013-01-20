---
layout: post
title: "Starting to play with the Doctrine OrientDB ODM"
date: 2013-01-19 11:50
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

require __DIR__.'/../vendor/swiftmailer/swiftmailer/lib/swift_required.php';
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
( boolean, link, linklist, string, integer, etc )
* **name**: the name of the attribute in the OrientDB class
(you might have a PHP property called `$createdAt` and in OrientDB
you call it `created_at`)
* **notnull**: defines whether the property can be `null` or not

## Repositories

## What about controllers?

## Can I haz raw queries?

## Point being, how do you save data?

## From the trenches