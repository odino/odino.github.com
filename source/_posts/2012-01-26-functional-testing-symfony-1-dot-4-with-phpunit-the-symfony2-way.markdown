---
layout: post
title: "Functional testing symfony 1.X with PHPUnit: the Symfony2 way"
date: 2012-01-26 00:45
comments: true
categories: [PHP, symfony, PHPUnit]
---

In the process of starting a brand new project here at
[DNSEE](http://www.dnsee.com), me and my colleague
[Matteo](http://www.linkedin.com/in/matteobiagetti) decided
- in order to make the whole team aware of how to test
Symfony2 applications with [PHPUnit](http://www.phpunit.de)
- to port the Symfony2 functional testing mechanism into
this project, which will be developed with symfony
1.X{% fn_ref 1 %}.
<!-- more -->

## Background

[Lime](http://trac.symfony-project.org/wiki/LimeTestingFramework)
- as you may know - is the officially-supported testing
"framework": it was specifically built to be used inside
symfony 1.X applications and introduced lots of developers
to the whole idea of testing in PHP.

It's a lightweight and simple implementation of a testing
framework, with poor support for mock objects, test doubles,
data providers and test isolation, but it does its job.

Since [Symfony2](http://www.symfony.com) decided to move to
PHPUnit - a **serious** and more robust testing framework -
suddenly all symfony developers needed to learn PHPUnit in order
to test the new applications: this - at least - didn't
happened to me, because I heavily faced PHPUnit developing
[Orient](http://github.com/congow/Orient), with lots of
WTFs - mainly *my* fault.

So, starting this new project, I asked the team if they would
agree on using PHPUnit to functionally test this new symfony 1.4
application, for 2 main reasons:

* **learn PHPUnit**, since the 3 developers involved in the project
have worked for 10|4|0 months on PHPUnit ever
* **get prepared for the big move**, since Symfony2 uses an analogous testing
mechanism

## The Symfony2 way

In Symfony2 you basically instantiate your application with a fake
client and make requests to it; at each request the application
produces a response and a crawler lets you
[test the output](http://symfony.com/doc/2.0/book/testing.html#working-with-the-test-client):

``` php A functional test for Symfony2
<?php

namespace Acme\DemoBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class FooControllerTest extends WebTestCase
{
    public function testIndex()
    {
        $client = static::createClient();

        $crawler = $client->request('GET', '/homepage');

        $this->assertEquals("Welcome!", $crawler->filter('h1#page-title')->text());
    }
}
``` 

So, as you see, PHPUnit is used to make assertions
on the response body{% fn_ref 2 %}.

## The basic idea

So, to backport the mechanism illustrated in the previous
chapter to symfony 1.X, we should **rely on a
DOM crawler and a browser**, capable of making HTTP requests
and parse subquent responses' bodies.

Fortunately, symfony 1.X's functional testing mechanism already
relies on an [internal browser](http://www.symfony-project.org/api/1_4/sfBrowser)
, able to bootstrap the application and make fake HTTP
requests{% fn_ref 3 %}, so we only need to integrate this browser
into a PHPUnit test and parse responses with a crawler: since
Symfony2 is a well-decoupled set of libraries we will use its
[DomCrawler](https://github.com/symfony/DomCrawler) component.

## Implementation

First of all import the required libraries into your
symfony project; using SVN, we updated the `lib/vendor`
directory:

``` bash
mkdir -p lib/vendor/Symfony/Component
svn add lib/vendor/Symfony
svn pe svn:externals lib/vendor/Symfony/Component
```

the content of the `externals` property will be:

``` bash
DomCrawler https://svn.github.com/symfony/DomCrawler.git
CssSelector https://svn.github.com/symfony/CssSelector.git
```

We are downloading the CssSelector component in order to use
CSS selectors within the crawler: if you don't want to use it you'll
need to write XPath queries to access the DOM nodes.

Save the `externals` file and commit, then update the
`lib/vendor/Symfony` directory in order to phisically
download the dependencies.

To finish the setup of the environment, create a `phpunit.xml.dist`
file in the root of the symfony project:

``` xml
<?xml version="1.0" encoding="UTF-8"?>

<phpunit backupGlobals="true"
         bootstrap="test/bootstrap/autoload.php"
         backupStaticAttributes="false"
         colors="true"
         convertErrorsToExceptions="true"
         convertNoticesToExceptions="true"
         convertWarningsToExceptions="true"
         forceCoversAnnotation="false"
         mapTestClassNameToCoveredClassName="false"
         processIsolation="false"
         stopOnError="false"
         stopOnFailure="false"
         stopOnIncomplete="false"
         stopOnSkipped="false"
         syntaxCheck="false"
         testSuiteLoaderClass="PHPUnit_Runner_StandardTestSuiteLoader"
         strict="false"
         verbose="false">

    <testsuites>
      <testsuite name="Main tests">
          <directory >test/phpunit</directory>
      </testsuite>
    </testsuites>

    <filter>
      <blacklist>
        <directory suffix=".php">test</directory>
        <directory suffix=".php">src</directory>
      </blacklist>
    </filter>
</phpunit>
```

and the `test/bootstrap/autoloader.php` file, used by PHPUnit
for -guess it - autoloading classes:

``` php The autoloader taken from Composer
<?php

namespace Composer\Autoload; class ClassLoader { private $prefixes = array(); private $fallbackDirs = array(); public function getPrefixes() { return $this->prefixes; } public function getFallbackDirs() { return $this->fallbackDirs; } public function add($prefix, $paths) { if (!$prefix) { $this->fallbackDirs = (array) $paths; return; } if (isset($this->prefixes[$prefix])) { $this->prefixes[$prefix] = array_merge( $this->prefixes[$prefix], (array) $paths ); } else { $this->prefixes[$prefix] = (array) $paths; } } public function register($prepend = false) { spl_autoload_register(array($this, 'loadClass'), true, $prepend); } public function loadClass($class) { if ($file = $this->findFile($class)) { require $file; return true; } } public function findFile($class) { if ('\\' == $class[0]) { $class = substr($class, 1); } if (false !== $pos = strrpos($class, '\\')) { $classPath = DIRECTORY_SEPARATOR . str_replace('\\', DIRECTORY_SEPARATOR, substr($class, 0, $pos)); $className = substr($class, $pos + 1); } else { $classPath = null; $className = $class; } $classPath .= DIRECTORY_SEPARATOR . str_replace('_', DIRECTORY_SEPARATOR, $className) . '.php'; foreach ($this->prefixes as $prefix => $dirs) { foreach ($dirs as $dir) { if (0 === strpos($class, $prefix)) { if (file_exists($dir . $classPath)) { return $dir . $classPath; } } } } foreach ($this->fallbackDirs as $dir) { if (file_exists($dir . $classPath)) { return $dir . $classPath; } } } } 
 
$__composer_autoload_init = function() {
    $loader = new \Composer\Autoload\ClassLoader();

    $map = array(
    'Symfony\\Component\\DomCrawler' => __DIR__ . '/../../lib/vendor/',
    'Symfony\\Component\\CssSelector' => __DIR__ . '/../../lib/vendor/',
    );

    foreach ($map as $namespace => $path) {
        $loader->add($namespace, $path);
    }

    $loader->register();

    return $loader;
};

return $__composer_autoload_init();
```

At this point the environment is ready, and you can start writing
your Symfony2's correspondent `WebTestCase` class{% fn_ref 4 %}:

``` php lib/test/sfWebTestCase.class.php
<?php

abstract class sfWebTestCase extends PHPUnit_Framework_TestCase
{
  protected function createClient()
  {
    $app = $this->getApplication();
    include(dirname(__FILE__).'/../../test/bootstrap/functional.php');

    return new sfPHPUnitBrowser();
  }
  
  abstract protected function getApplication();
}
```

So we've created a base class for every functional test we'll write.

It consist in:

* a `createClient()` method which instantiates a new browser based on
some configuration
* an abstract method that each functional test need to implement in order
to setup the right application in the `createClient()` method
(frontent, backend, whatever...)

The browser that we are using is `sfPHPUnitBrowser`, instance of a
non-existing class, so let's create it:

``` php lib/test/sfPHPUnitBrowser.class.php
<?php

use Symfony\Component\DomCrawler\Crawler;

class sfPHPUnitBrowser extends sfBrowser
{
  public function call($uri, $method = 'get', $parameters = array(), $changeStack = true)
  {
    $browser = parent::call($uri, $method, $parameters, $changeStack);
    $crawler = new Crawler();
    $crawler->add($browser->getResponse()->getContent());
    
    return $crawler;
  }
}
```

This class extends the usual `sfBrowser` one adding a simple functionality:
when a request is made, it does not return itself but an instance of a
`Crawler` object.

This will let you do:

``` php
<?php

$crawler = $client->get('/home');

$this->assertCount(X, $crawler->filter('CSS selector here'));
$this->assertTrue($crawler->filter('html:contains(h1)'));
``` 

If you didn't mistyped anything you should be able to
create your first test:

``` php test/phpunit/HomepageTest.php
<?php

include(__DIR__ . "/../../lib/test/sfWebTestCase.class.php");

use Symfony\Component\DomCrawler\Crawler;

class HomepageTest extends sfWebTestCase
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
}
```

Next, create a route for your homepage and render
some dummy template:

``` html The template we are going to test
<h1>Hello world</h1>
```

Now you can run the test with the usual `phpunit` command:

{% img center /images/phpunit.symfony.png %}

The greatest benefit of this approach is that you can **use
PHPUnit's pure functionalities to test symfony 1.X
applications** without re-inventing the wheel: what we saw
was the test of some output but bare in mind that, extending
`sfBrowser`, our `$client` object is able to access the request
and the user session too.

## Why not re-using existing integrations?

Obviously, **before** writing any line of code, we took a look
at existing PHPUnit's integrations into symfony 1.X.

There are - basically - 2 plugins:

* [sfPHPUnit2Plugin](http://www.symfony-project.org/plugins/sfPHPUnit2Plugin),
which seemed useless being a PHPUnit wrapper for lime
* [sfPHPUnitPlugin](http://www.symfony-project.org/plugins/sfPhpunitPlugin),
which uses PHPUnit + Selenium, but we really don't want to depend on
a selenium instance to run our tests

{% footnotes %} 
  {% fn We are actually developing a few projects with Symfony2, mostly landing pages and small data-driven CRUD applications, due to the lack of comprehensive documentation about Symfony2, but I will flame about it in another post %}
  {% fn This is not entirely true: PHPUnit is mainly used for testing the response, but inside a test-case you can access the user's session, cookies and so on, therefore you can assert against lots of objects and use-cases %}
  {% fn You can also use a real HTTP client to make requests to your application and test the output, but this approach is strongly discouraged because of dramatically-low performances %}
  {% fn The WebTestCase is a base class for every functional test (in Symfony2), like PHPUnit_Framework_TestCase for canonical unit tests %}
{% endfootnotes %}
