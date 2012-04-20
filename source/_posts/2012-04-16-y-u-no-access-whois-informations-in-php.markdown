---
layout: post
title: "Y U NO access WHOIS informations in PHP?"
date: 2012-04-16 00:38
comments: true
categories: [WHOIS, open source, Robowhois, PHP]
---

{% render_partial series/robowhois.markdown %}

In these days we finalized the last parts of the official
[PHP client for the Robowhois API](https://github.com/robowhois/robowhois-php)
, and here are the changes for the `0.9.0` version.
<!-- more -->

## Parts and properties API

As part of our job, we needed to implement the last
2 API endpoints provided by Robowhois, `properties`
and `parts`.

Everything is documented in the 
[README](https://github.com/robowhois/robowhois-php/blob/master/README.md)
but you can also follow the examples under the `sample/` directory:

``` php Using the properties API
<?php

use Robowhois\Robowhois;
use Robowhois\Exception;

require 'vendor/.composer/autoload.php';

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

try {
    $domain = $robowhois->whoisProperties('robowhois.com');
    
    echo $domain['properties']['created_on'] . "\n";
} catch (Exception $e) {
    echo "The following error occurred: " . $e->getMessage();
}
```

``` php Using the parts API
<?php

use Robowhois\Robowhois;
use Robowhois\Exception;

require 'vendor/.composer/autoload.php';

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

try {
    $domain = $robowhois->whoisParts('robowhois.com');

    echo $domain['parts'][0]['body'] . "\n";
} catch (Exception $e) {
    echo "The following error occurred: " . $e->getMessage();
}
```

## Magic objects, behaving like arrays

We implemented the `\ArrayObject` interface for the objects
returned by the API, which means that now you can access
the results of an API call just like an array:

``` php
<?php

$account = $robowhois->account();

// $account is an instance of Robowhois\Account
echo sprintf('You have %d API calls left', $account['credits_remaining']);
```

but, for those like us who like the OO synthax, we implemented
some magic to let you retrieve those values via getters, which
are built *on-the-fly* thanks to PHP's `__call()` method:

``` php
<?php

echo $account->getCreditsRemaining();
```

Getters are a camelized version of the array keys, and are
built thanks to the
[Doctrine Inflector](https://github.com/robowhois/robowhois-php/blob/master/composer.json#L28).

## Mapping the existing API

We renamed the methods accessing the API in order to 100% reflect
the ones exposed by the API, also used in the
[Ruby client](https://github.com/robowhois/robowhois-ruby): so now the
`Robowhois\Robowhois` object has:

* `->account()`
* `->whois()`
* `->whoisProperties()`
* `->whoisParts()`
* `->whoisRecord()`
* `->whoisAvailability()`

## Simplified exceptions

We initially added tons of exceptions but we eventually
decide to keep the only `Robowhois\Exception` class.

## Now?

Wanna retrieve WHOIS informations in PHP at a
[decent price](http://www.robowhois.com/pricing)?

Start consuming the Robowhois APIs, with PHP.
