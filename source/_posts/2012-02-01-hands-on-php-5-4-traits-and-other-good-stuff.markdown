---
layout: post
title: "Hands on PHP 5.4: traits and other good stuff"
date: 2011-07-25 14:03
comments: true
categories: [php]
alias: "/373/hands-on-php-5-4-traits-and-other-good-stuff"
---

Yesterday I had the opportunity to spend a few minutes on PHP 5.4 and its new features.
<!-- more -->

With [David](http://www.davidfunaro.com/), we just set a [Back|Track 4](http://en.wikipedia.org/wiki/BackTrack) VM on his Mac and downloaded the tar.gz of **PHP 5.4 aplha 2**.

To install it without running tests and loosing too much time:

```
./configure
make && make install
```

So, ready to go!

## Forget about multiple inheritance, enter reuse

A lot of people don't like multiple inheritance because of the fact that a lot of stuff can be done doing proper OO design: nothing to say about that.

{% img left /images/Coke-Can-Mini-Car-59607.jpg %}

Although traits are also about multiple inheritance, their domain is more complex, as they usually deal with code reuse.

Consider, for example, this situation: from a `Car` we derive `StandardCar` and `MiniCar`, then we need to give cars a brand, which cannot be a simple attribute, because the brand deals with generating a car's serial ID or - completely invented concept - deciding the minimum age the driver should have to drive it.

``` php
<?php

class Car 
{
  protected $manufacturer = NULL;

  public function getSerialId()
  { 
    return rand(0, 999);
  } 
 
  public function allowsDriversOver() 
  { 
    return 18; 
  } 
} 

class StandardCar extends Car 
{
} 

class MiniCar extends Car 
{ 
  public function allowsDriversOver() 
  { 
    return 16; 
  } 
}
```

So, let's say BMW is the only vendor which does not follows a standard in generating serial IDs and does not let people under 21 to drive its cars: enter `BmwCar` and `BmwMiniCar`.

``` php
<?php

class BmwCar extends StandardCar 
{ 
  public function getSerialId()
  {
    return parent::getSerialId() . "-bmw";
  }

  // same for allowsDriversOver()
} 

class BmwMiniCar extends MiniCar 
{
  public function getSerialId()
  {
    return parent::getSerialId() . "-bmw";
  }

  // same for allowDriversOver()
}
```

This leads to duplications that we can avoid with traits:

``` php
<?php

class BmwCar extends StandardCar 
{ 
  use BmwManufactured; 
} 

class BmwMiniCar extends MiniCar 
{
  use BmwManufactured; 
}

trait BmwManufactured
{
  public function getSerialId()
  {
    return parent::getSerialId() . "-bmw";
  }
} 
```

What I am personally missing is a `is_with()`/`contains`/whatsoever operator which checks if an object is an instance of a class implementing a certain trait, something like:

```
<?php

$car->contains(BmwManufactured);
```

We looked for it, but could not find a solution: you can see that we introduced an `->isA($manufacturer)` method in order to solve this. Completely inefficient logic: as far as I know this kind of operator will be implemented in the next releases of the PHP 5.4 development package, definitely a good thing.

## Other good stuff

What a good thing the built-in webserver:

```
php -S localhost:8124
```

which launches a webserver responding to the current directory: it will be really efficient when you are developing some standalone scripts in the need to be reached via HTTP.

I also - obviously - loved array deferencing:

``` php
<?php

$a = array(
  'logger' => function () {
    echo 'loggin really serious stuff';
  }
);

$a['logger']() ;
```

which is awesome if you want to associatively store - for example - lambas in an array.

You can see the full list of our crappy [PHP 5.4 experiments](https://gist.github.com/1102671) on this gist.