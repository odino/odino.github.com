---
layout: post
title: "Enter SfCcTesting: Symfony 1.X Client-Crawler Testing"
date: 2012-01-26 11:51
comments: true
categories: [symfony, testing, PHPUnit, PHP]
---

Earlier today I introduced why and how we initially integrated the [Symfony2
testing mechanism into symfony 1.X](/functional-testing-symfony-1-dot-4-with-phpunit-the-symfony2-way/)
: in order to make this piece of software as clean and evolvable as possible
I just isolated it and made a small repo on Github.
<!-- more -->

## SfCcTesting

[SfCcTesting](https://github.com/odino/SfCcTesting) - **Symfony 1.X
Client-Crawler Testing** - is a small library (2 classes
and a configuration file) which lets you write functional tests, in symfony 1.X,
*a là Symfony2*.

if you take a look at the [repository's README](https://github.com/odino/SfCcTesting/blob/master/README.md)
you will find the basic instructions to start writing your tests: keep in mind
that - although it's usable on *old-school* symfony projects (svn etc) - you
should install it with Git and manage dependencies and updates with 
[Composer](/managing-php-dependencies-with-composer/).

``` php A PHPUnit functional test for symfony 1.X written thanks to SfCcTesting
<?php

use odino\SfCcTesting\WebTestCase;

class HomepageTest extends WebTestCase
{  
  public function testHelloWorld()
  {    
    $client = $this->createClient();
    $crawler = $client->get('/');
    
    $this->assertEquals("Hello world", $crawler->filter('h1')->text());
  }
  
  protected function getApplication()
  {
    return 'frontend';
  }
  
  protected function bootstrapSymfony($app)
  {
    include(dirname(__FILE__).'/../../test/bootstrap/functional.php');
  }
}
```

Each test needs to implement 2 protected methods, `getApplication()` and
`bootstrapSymfony()`.

The `getApplication` method defines the application to bootstrap symfony for,
and should be defined in an `ApplicationWebTestCase` class, like in the following
example:

``` php A base class for testing the backend
<?php

use odino\SfCcTesting\WebTestCase;

class BackendWebTestCase extends WebTestCase
{    
  protected function getApplication()
  {
    return 'backend';
  }
  
  protected function bootstrapSymfony($app)
  {
    include(dirname(__FILE__).'/../../test/bootstrap/functional.php');
  }
}
```

so your test files become leaner:

``` php
<?php

class HomepageTest extends BackendWebTestCase
{  
  public function testHelloWorld()
  {    
    $client = $this->createClient();
    $crawler = $client->get('/');
    
    $this->assertEquals("Hello world", $crawler->filter('h1')->text());
  }
}
```

The `bootstrapSymfony()` method, instead, includes the **bootstrap for the symfony
application in the test environment**; you are **allowed to redefine the location
of the bootstrap** in order not to force you to follow a unique directory
structure convention.

The `bootstrapSymfony()` method should be placed in a `BaseWebTestCase` of
our test suite:

``` php A base class for boostrapping the symfony testing environment
<?php

use odino\SfCcTesting\WebTestCase;

class BaseWebTestCase extends WebTestCase
{      
  protected function bootstrapSymfony($app)
  {
    include(dirname(__FILE__).'/../../test/bootstrap/functional.php');
  }
}
```

so your different `ApplicationWebTestCase` can share the same bootstrap file:

``` php
<?php

use odino\SfCcTesting\WebTestCase;

class BackendWebTestCase extends BaseWebTestCase
{    
  protected function getApplication()
  {
    return 'backend';
  }
}
```

``` php
<?php

use odino\SfCcTesting\WebTestCase;

class FrontendWebTestCase extends BaseWebTestCase
{    
  protected function getApplication()
  {
    return 'frontend';
  }
}
```

That's all folks: with just a bunch of lines of code you are able
to functionally test a symfony 1.X application with the Symfony2
DomCrawler.

[Feel free to rant](https://github.com/odino/SfCcTesting/issues) and, if you want,
you can already rely on this small library via
[Packagist](http://packagist.org/packages/odino/SfCcTesting).