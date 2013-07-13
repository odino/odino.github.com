---
layout: post
title: "AB testing in PHP with namshi/ab"
date: 2013-07-13 14:27
comments: true
categories: [testing, AB testing, FOSS, Namshi, PHP, Github, Open Source]
published: true
---

AB testing is a powerful tecnique that
lets you gather metrics about different
versions of a feature: it basically
consist into displaying a number of
different variations of it to your
users and tracking the results to see
which variation performed better.

{% img right /images/ab-testing.jpg %}

An example? In an e-commerce system,
you usually have an "Add to cart" button:
have you ever though about the impact that
single sentence has on your customers?
What would sound better, between "Add to cart"
and "Buy now", for example? Copywriters
away, you want **data** to tell you that!

This is why AB testing is important:
you serve different versions of something,
and track the results to improve the
experience users have while using your
application: for example, Google benchmarked
[40 different shades of blue](http://gigaom.com/2009/07/09/when-it-comes-to-links-color-matters/)
to find out how the rate of clickthrough
would be altered.

At [Namshi](http://en-ae.namshi.com) we
decided to ease AB testing by creating a
very simple library that would let you generate
and manage tests in a very easy and practical
way: that's how [Namshi/AB](https://github.com/namshi/ab)
was born.

<!--   more -->

## Installation

You can install the library via composer,
as it's available on [packagist](https://packagist.org/packages/namshi/ab).

Then include it, specifying a major and
minor version, in your `composer.json`:

```
"namshi/ab": "1.0.*"
```

## Creating and running tests

The library is very small, and it comes bundled with
2 classes, `Test` and `Container`: as you can probably
guess, the first is a representation of an AB test and
the 2nd serves as a convenient container for all of your
test instances.

Here's how you can create a test:

``` php
<?php

use Namshi\AB\Test;
use Namshi\AB\Container;

$cssTest = new Test('css', array(
	'default.css' 	=> 2,
	'new.css' 		=> 1,
));

$abContainer = new Container(array(
	$cssTest
));
```

At this point, for example, you can start
AB testing your website by changing the CSS
in the view:

``` php
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="<?php echo $abContainer['css']->getVariation(); ?>"  />
		...
		...
```

`getVariation()` will calculate the variation
(`default.css` or `new.css`) according to the
odds of each variation (66% for the first one, 
33% for the second one) and will return a string
representing the variation.

## Persisting the variations through an entire session

Of course, you want to display variations but be
consistent with each user, so that if a user gets
a variation, it will continue getting the same variation
throughout his entire session: to do so, just calculate
a random integer (seed), store it in session and pass it to
each test:

``` php
<?php

session_start();

if (!isset($_SESSION['seed_for_example_test'])) {
    $_SESSION['seed_for_example_test'] = mt_rand();
}

$test = new Test('example', array(
	'a' => 1,
	'b' => 1,
));

$test->setSeed($_SESSION['seed_for_example_test']);

// as long as the seed doesn't change
// getVariation() will always return the
// same variation
$test->getVariation();
```

Soon, you will realize that having a per-test seed
is **not efficient at all**, that's why you can create
a global seed and pass it to the container: from that
seed, the container will take care of generating a seed
for each test:

``` php
<?php

session_start();

if (!isset($_SESSION['seed'])) {
    $_SESSION['seed'] = mt_rand();
}

// pass the seed into the constructor
$abContainer = new Container(array(
    new Test('greet', array(
        'Hey dude!' => 1,
        'Welcome'   => 1,
    )),
    new Test('background-color', array(
        'yellow'    => 1,
        'white'     => 1,
    )),
), $_SESSION['seed']);

// or with a setter
$abContainer->setSeed($_SESSION['seed']);
```

## Disabling the tests

Sometimes you might want to disable tests
for different purposes, for example if
the user agent who is visiting the page is a bot:

``` php
<?php

$test = new Test('my_ab_test', array(
    'a' => 0,
    'b' => 1,
));

$test->disable();

$test->getVariation(); // will return 'a'!
```

Once you disable the test and run it,
it will always return the first variation,
no matter what its odds are, even if it's zero.

## An example

I would recommend you to have a look at the
[example provided](https://github.com/namshi/AB/tree/master/examples) under the `examples` directory:
it's pretty silly, but it gives you an idea of
how easy is to create and run AB tests with
this library.

{% img center /images/ab.png %}

If you look at the code, you will soon realize that
it's very simple:

``` php
<?php

require __DIR__ . '/../vendor/autoload.php';

use Namshi\AB\Test;
use Namshi\AB\Container;

session_start();

if (!isset($_SESSION['seed'])) {
    $_SESSION['seed'] = mt_rand();
}

$abt = new Container(array(
    new Test('greet', array(
        'Hey dude!' => 1,
        'Welcome'   => 1,
    )),
    new Test('background-color', array(
        'yellow'    => 1,
        'white'     => 1,
    )),
), $_SESSION['seed']);

?>

<html>
    <head>
        <style>
            * {
                background-color: <?php echo $abt['background-color']->getVariation(); ?>;
            }
        </style>
    </head>
    <body>
        <h1>
            <?php echo $abt['greet']->getVariation(); ?>
        </h1>
        
        <div>
            Your seed is <?php echo $_SESSION['seed']; ?>
        </div>
    </body>
</html>
```

Of course, never write an application like this ;-)
this serves just as an example.

## Additional features

We tried to extensively cover the available features of
the library in its [README](https://github.com/namshi/ab),
so I will just sum them up here:

* the container implements the `ArrayAccess` interface, so you can
retrieve tests like if they were stored into an array (`$abContainer['my_test']`)
* since AB tests are very useful only when you **track**
the results, we added a **tracking name** that you can specify
for each test: this is due to the fact that your test might be
called `add_to_cart_text` but in your tracking tool, you
have to reference the test with the tracking tool's ID, which
might be a very clueless string (ie. `test_id_4njktn4t4tjjnn4on`)
* you can also add an array of parameters to each test and retrieve
them later on: this is due to the fact that once you track the test's
result, you might want to send additional data together with the
tracking name, the variation and the result

## Why not choosing an existing library

Of course we checked out what the market was
offering, but weren't able to find out a very
good, generic-purpose, library in order to
generate AB tests:

* [jm/ab-bundle](https://packagist.org/packages/jm/ab-bundle)
is unfortunately coupled with Symfony2 and Twig, so
you can't really call it a stack-free library: even though
we **love** Symfony2, not all of our services run with
it and we don't want to **force a technology just to
have a functionality**
* [phpabtest](http://phpabtest.com/index) is a full-stack
service, meaning that it provides a library to register and
handle tests but also tracks stuff via Google Analytics; moreover,
[we didn't like the code that much](https://github.com/briancray/phpA-B/blob/master/phpab.php)

At the end of the day, `namshi/ab` is a **1 man-day effort**, so we
spiked for a bit and decided that it was worth it.

## Testing this library

We added a few PHPUnit tests, so you just have to:

```
cd /path/to/namshi/ab

phpunit
```

The funny thing is that we also added some test to check that
the library correctly [generates variations according to their odds](https://github.com/namshi/AB/blob/master/tests/Namshi/AB/Test/TestTest.php#L161).

## FOSS

The library is available on
[Github](https://github.com/namshi/AB): please let
[us](https://github.com/namshi) know if you
would like to see something different, have a suggestion
or whatsoever: even better than that, **feel free to open
a pull request** if we screwed up with anything!