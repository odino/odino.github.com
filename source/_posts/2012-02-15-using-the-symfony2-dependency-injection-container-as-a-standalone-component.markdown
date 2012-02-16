---
layout: post
title: "Using the Symfony2 DIC as a standalone component"
date: 2012-02-15 20:06
comments: true
categories: [Symfony2, PHP]
---

{% render_partial series/symfony-components.markdown %}

The [Symfony2 components](https://github.com/symfony/symfony/tree/master/src/Symfony/Component) are powerful libraries that you can easily integrate in your own code: in this article we will se how to integrate the [dependency injection container](https://github.com/symfony/DependencyInjection#readme) in a *framework-free* PHP small library.
<!-- more -->

## Premise

have you ever heard about the [QOTD protocol](http://en.wikipedia.org/wiki/QOTD){% fn_ref 1 %}?

It's a [standard](http://www.ietf.org/rfc/std/std23.txt) protocol, defined in
[RFC-0865](http://tools.ietf.org/html/rfc865), for a dummy client/server interaction that allows
a server to listen on port 17 and emit a quote in ASCII text whenever a connection
is opened by a client.

To give you an example, try this from the command line{% fn_ref 1 %}:

``` 
telnet alpha.mike-r.com 17
```

{% blockquote George Bernard Shaw http://alpha.mike-r.com alpha.mike-r.com %}
First love is only a little foolishness and a lot of curiosity, no 
really self-respecting woman would take advantage of it.
{% endblockquote %}

So today we are going to see how to implement a QOTD script in PHP, using Symfony2's
DIC: the mini-library that we are going to write is dummy and really easy, so you won't
get lost following its flow; I won't use any autoloader - apart for the DIC stuff - so 
the code will exactly look like the ancient PHP, the one you daily need to refactor.

## QOTD scripts

We have 3 scripts that compose our small library; the first one is the entry point:

``` php index.php
<?php

require 'QOTD.php';

$qotd = new QOTD();
echo $qotd->enchantUs() . "\n";
```

and then the QOTD class:

``` php Quotes Of The Day generator class
<?php

class QOTD
{
  protected $wtfMode;
  protected $quotes = array(
      "michael jordan" => array(
          "Always turn a negative situation into a positive situation",
          "I can accept failure, everyone fails at something. But I can't accept not trying"
      ),
      "Mahatma Gandhi"  => array(
          "A coward is incapable of exhibiting love; it is the prerogative of the brave"
      ),
  );
  
  public function __construct($wtfMode = false)
  {
      $this->wtfMode = $wtfMode;
  }
  
  public function enchantUs()
  {
      $authorQuotes = $this->quotes[array_rand($this->quotes)];

      if ($this->wtfMode === true && is_int(time(true)/2)) {
        return "WTFed!!!";
      }
      
      return $authorQuotes[array_rand($authorQuotes)];
  }
}
```

As you see, the implementation is trivial: we have an array of `$quotes` and in the `enchantUs()`
method we extract a random quote from that array: note that there is a boolean parameter
- in the constructor - which enables or disables the `WTF mode`; when the mode is active, if

``` php 
<?php

is_int(time(true)/2)
```

is true the QOTD class will output `WTFed!!!` instead of the usual quote from `$quotes`.

Let's say that we also want to creare a class for Michael Jordan's quotes:

``` php Michael Jordan quotes
<?php

class JordanQOTD extends QOTD
{
  protected $quotes = array(
      "michael jordan" => array(
          "Always turn a negative situation into a positive situation",
          "I can accept failure, everyone fails at something. But I can't accept not trying"
      ),
  );
}
```

which basically restricts the `$quotes` to MJ's ones{% fn_ref 3 %}.

If we want to change the class used to output quotes, we just need to edit the `index.php`:

``` php index.php
<?php

require 'QOTD.php';
require 'JordanQOTD.php';

$qotd = new JordanQOTD();
echo $qotd->enchantUs() . "\n";
```

## Enter Symfony2 Dependency Injection Container

The boss just told us that we'll need to implement some more *modes* and lots of
person-specific quote classes, with some other logic to decide which QOTD class
to use and so on: your first decision is to try to parametrize the configuration
of the QOTD "service", using a DIC ; although the problem and its design are quite
simple, it would be a good choice to have a single, central point to manage
services used in your code and their configuration.

First of all, create a `composer.json` file in the root of your project, to manage
the dependency to the DIC:

``` bash composer.json
{
    "require": {
        "php": ">=5.3.2",
        "symfony/dependency-injection": "2.0.10"
    }
}
```

then download Composer and install the DIC:

``` 
wget http://getcomposer.org/composer.phar

php composer.phar install
```

Now you can edit the `index.php` to add some configuration:

``` php index.php
<?php

require __DIR__ . '/vendor/.composer/autoload.php';
require 'QOTD.php';
require 'JordanQOTD.php';
require 'container.php';

echo $container->get('QOTD')->enchantUs() . "\n";
```

The `container.php` uses the Symfony2 DIC to register a `QOTD` service with
a `QOTD.mode` argument:

``` php configuration of the container
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'QOTD');
$container->setParameter('QOTD.mode', false);
```

For example, we can modify the configuration to enable the WTF mode:

``` php enabling WTF mode
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'QOTD');
$container->setParameter('QOTD.mode', true);
```

or to change the service class, to only output MJ's quotes:

``` php changing the service class
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'JordanQOTD');
$container->setParameter('QOTD.mode', false);
```

As you might understand, with a DIC it's possible to drastically **change the
behaviour of your application** editing a configuration file, with a bunch of
additional lines of code into your own application; another great thing is that
you can also use different "languages" to configure the DIC, for example YAML.

To do so, add the required dependency to composer:

``` bash composer.json
{
    "require": {
        "php": ">=5.3.2",
        "symfony/dependency-injection": "2.0.10",
        "symfony/config": "2.0.10",
        "symfony/yaml": "2.0.10"
    }
}
```

``` 
php composer.phar update
```

then edit the `container.php`:

``` php
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\YamlFileLoader;
use Symfony\Component\Config\FileLocator;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.mode%')
          ->addArgument('%mode%');

$loader = new YamlFileLoader($container, new FileLocator(__DIR__));
$loader->load('container.yml');
```

and then configure the DIC creating a `container.yml`:

``` 
services:
  QOTD:
    class: QOTD
    arguments:
      mode: true
```

[INI](http://en.wikipedia.org/wiki/INI_file) is another - not documented in
[Symfony2's docs](http://symfony.com/doc/current/book/service_container.html) - option:

``` php
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\IniFileLoader;
use Symfony\Component\Config\FileLocator;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%qotd.mode%');

$loader = new IniFileLoader($container, new FileLocator(__DIR__));
$loader->load('container.ini');
```

``` ini
[parameters]
  qotd.class = "QOTD"
  qotd.mode = 1
```

There you go: with a few lines you have a completely working instance of the
Symfony2 dependency injection container: organizing dependencies and services'
instantiation becomes very easy with this kind of layer and, since its
implementation is trivial, I recommend you to gain familiarity with this
component.

{% footnotes %}
  {% fn Quote Of The Day %}
  {% fn alpha-mike is the only known public service that implements QOTD protocol %}
  {% fn This is not an optimal design for resolving such this kind of thing, but we'll use it as it's fairly simple to understand %}
{% endfootnotes %}
