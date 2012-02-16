---
published: false
layout: post
title: "Using the Symfony2 Dependency Injection Container as a standalone component"
date: 2012-02-15 20:06
comments: true
categories: [Symfony2, PHP]
---

``` bash composer.json
{
    "require": {
        "php": ">=5.3.2",
        "symfony/dependency-injection": "2.0.10"
    }
}
```

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

``` php index.php
<?php

require __DIR__ . '/vendor/.composer/autoload.php';
require 'QOTD.php';
require 'JordanQOTD.php';
require 'container.php';

echo $container->get('QOTD')->enchantUs() . "\n";
```

``` php configuration of the container
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'QOTD');
$container->setParameter('QOTD.mode', false);
```


``` php enabling WTF mode
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'QOTD');
$container->setParameter('QOTD.mode', true);
```

``` php changing the service class
<?php

use Symfony\Component\DependencyInjection\ContainerBuilder;

$container = new ContainerBuilder();
$container->register('QOTD', '%qotd.class%')
          ->addArgument('%QOTD.mode%');

$container->setParameter('qotd.class', 'JordanQOTD');
$container->setParameter('QOTD.mode', false);
```
