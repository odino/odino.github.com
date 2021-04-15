---
layout: post
title: "Checking a domain's availability with PHP"
date: 2012-03-20 09:49
comments: true
categories: [robowhois, whois, php]
---

{% render_partial series/robowhois.markdown %}

It's been a while I don't blog about the
[Robowhois PHP client](https://github.com/robowhois/robowhois-php) that I'm developing
together with [David](http://davidfunaro.com) so, since we recently released
the `0.8.0` version I want to share with you what you can do with it now.
<!-- more -->

## Checking a domain's availability

The [availability API](http://docs.robowhois.com/api/whois/) is probably the
greatest feature of the [Robowhois](http://www.robowhois.com/) webservice,
letting you check for a domain's availability with a simple, uniform HTTP
request.

``` php Checking if google.com is available
<?php

use Robowhois\Robowhois;

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

if ($robowhois->isAvailable('google.com')) {
  echo "pretty nice dream, uhm?";
}
```

The opposite thing is achieved using the `->isRegistered()` method.

You can also retrieve an array as returned from the webservice, by doing:

``` php 
<?php

use Robowhois\Robowhois;

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

if ($availability = $robowhois->whoisAvailability('google.com')) {
  echo $availability['available'];
  echo $availability['registered'];
  echo $availability['daystamp'];
}
```

## Retrieve informations about your account

A *must-have*, since you should always check how many remaining credits
you have, the `account` API lets you retrieve some of your personal data
from your Robowhois.com account:

``` php Calculating how many left credits you have
<?php

use Robowhois\Robowhois;

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

try {
    $credits = $robowhois->whoisAccount()->getCreditsRemaining();

		if ($credits > 100) {
				echo "No problem fella!";
    } else {
				echo "Time to go shopping looking for new API calls, uhm?";
    }
} catch (Exception $e) {
    echo "The following error occurred: " . $e->getMessage();
}
```

## Minor things

We also polished some code, refactored stuff and added some tests (unit and
integration ones).

For instance, when using the `record` API, you can retrieve the daystamp of the
response as `DateTime` object:

``` php retrieving the daystamp as an object or a string
<?php

use Robowhois\Robowhois;

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

if ($whois = $robowhois->whoisRecord('google.com')) {
  // returns a DateTime object
  echo $whois->getDaystamp();

  // formats the DateTime
  echo $whois->getDaystamp()->format('Y-m-d');

  // returns a string
  echo $whois->getDaystamp(true);
}
```

You can download the [latest tag](https://github.com/robowhois/robowhois-php/tree/0.8.0)
of the library (currently `0.8.0`) and start using it: the [README](https://github.com/robowhois/robowhois-php/blob/master/README.md)
exhaustively explains what you can do with this small client, and some
[samples](https://github.com/robowhois/robowhois-php/tree/master/sample)
are provided under the `sample` directory.