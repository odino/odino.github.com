---
layout: post
title: "Application-level caching: fight the right battle "
date: 2011-11-22 15:01
comments: true
categories: [cache, architecture]
alias: "/392/application-level-caching-fight-the-right-battle"
---

I always receive a funny question, that I want to answer right here, right now, with the usual reply I give to people asking it to me:

> Why do you hate application-level caches?

First of all, I don't.

And here's explained why I don't hate AL caches and why I do really hate how developers integrate caching in their applications.
<!-- more -->

## What should we cache

There are a few aspects of our architecture/application that usually need caching-capabilities to improve performances, and I will analyze each one of them in order to understand whether they fit well in an application cache or not.

To summarize them, here's a brief list:

* finding file on the filesystem
* metadata
* routing
* configuration
* non-native data providers
* output fragments

## Finding files

An AL cache is really good for finding files on the filesystem: autoloaders are pretty smart ( for example, in PHP, we have the [PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md) standard ) so they basically know a set of conventions and calculate the path to a required file: well, the process of calculating that path is really unnecessary when going live on production, because the core of our application is rarely meant to be moved/changed.

``` php autoloading.php
<?php

array(
  'Symfony\Component\Finder\Finder' => __DIR__ .'/src/Symfony/Component/Finder/Finder.php',
  ...
  ...
); 
```

Flushing the autoloading cache at every deploy is the solution for those rare scenarios.

## Reading metadata

When you need to specify metadata on objects, a good solution is recurring to annotations:

``` php
<?php

class Dog
{
  /**
   *  @validation(int)
   */
  protected $age;
}
```

but reading that data can be expensive, since you always need to parse and introspect an entity.

Doctrine2, the infamous PHP ORM, uses [caching](https://github.com/doctrine/common/tree/master/lib/Doctrine/Common/Cache) exactly to solve the issue of always reading metadata from objects.

## Routing

We usually compile YML/XML files for routing ( 'cause they are way easier to read/write ), which means that at every request we parse the URI, parse the routing file and find a match between them.

Reading the routing can be annoying, so we can easily compile down a PHP file with routing rules from the original routing file.

## Can I haz natives?

As you might understand, a good solution is to cache when we need to face formats which are different from our language: so, for example, from configuration files we can compile - in PHP - arrays, or stuff like that.

Symfony2, for example, add the ability of [compiling down the whole dependency injection container](http://www.slideshare.net/fabpot/dependency-injection-in-php-5354/100) from different formats to plain PHP.

## Bad smells, here they come

So you may wonder why I hate application caches, and **here it comes the tornado**.

We are basically used to think that **caching the output** is just good, and we have those CMSes like Joomla! or Drupal doing that.

Think about how many things you are loosing re-implementing an output caching layer inside your application: your application needs to do the storage of cached files, it needs to calculate dates and evaluate if an HTML fragment have expired or not, it needs to be hit for 2 identical requests and then, the most disturbing thing, you need to add a layer on top of your application.

Adding new layers is bad, because as you add them, you potentially introduce bugs, coupling and limitations to your software: **the more code you write, the more bugs happen**.

Output caching should be done with the HTTP cache, which works at the protocol level: you don't have to add any layer to your application ( you only need a good framework ), and whether to cache or not a resource is demanded to the client's browser or to the reverse proxy.

In the HTTP cache, you can serve the same response to 1 milion clients just with a stupid reverse proxy; you can serve the same response after identical requests, to a single client, without even making the subsequent requests traverse the internet.

Custom output caches are not capable of doing 1% of what the HTTP cache has proven to be able to do.

Application-level output caches are an antipattern, get over it.