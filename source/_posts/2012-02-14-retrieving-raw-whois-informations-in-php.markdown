---
layout: post
title: "Retrieving raw WHOIS informations in PHP"
date: 2012-02-14 00:58
comments: true
categories: [robowhois, php, whois]
---

{% render_partial series/robowhois.markdown %}

After something more than a week I'm back here with a first implementation of
the PHP library I was [talking earlier](/a-php-library-to-retrieve-whois-informations/)
to retrieve WHOIS informations with PHP.
<!-- more -->

In the first meeting I had with [David](http://davidfunaro.com) we just setup the
environment (Composer, PHPUnit and so on) and today we've release the
[first tag](https://github.com/robowhois/robowhois-php-client/tree/0.7.0)
- 0.7.0 - of [Robowhois PHP client](https://github.com/robowhois/robowhois-php-client),
a PHP library to consume [Robowhois](http://robowhois.com) APIs.

## Installation

The library is assembled with [Composer](/managing-php-dependencies-with-composer/),
so you only need to follow the canonical steps in order to download the
required dependencies and use it in your own codebase

``` bash Installing the Robowhois PHP client from the command line
git clone git@github.com:robowhois/robowhois-php-client.git

wget http://getcomposer.org/composer.phar

php composer.phar install
``` 

then you can autoload everything through the auto-generated autoloader
provided by Composer:

``` php
<?php

require 'vendor/.composer/autoload.php';
```

## Retrieving raw WHOIS responses

By now we have implemented the most simple API exposed, the `whois:index`
one, which returns the raw WHOIS informations associated to a domain.

You can take a look at the example at `sample/index.php` or try it live:

``` php
php sample/index.php
```

bare in mind that you'll need to sign for a free API key up at Robowhois
website (as far as I remember, they provide 500 free request, but the annual
fee for unlimited requests is **very cheap**).

You can also be a bit more creative than the example above:

``` php 
<?php

use Robowhois\Robowhois;
use Robowhois\Exception;

require 'vendor/.composer/autoload.php';

$robowhois = new Robowhois('INSERT-YOUR-API-KEY-HERE');

try {
    // same as $robowhois->whoisIndex(...)->getContent()
    echo $robowhois->whoisIndex('robowhois.com');
} catch (Exception\Http\Request\Unauthorized $e) {
    echo "WTF did you used a pirated API key?!?!?!";
}
} catch (Exception\Http\Response\NotFound $e) {
    echo "OMG 404 happened :-|";
}
} catch (Exception\Http\Response\ServerError $e) {
    echo "Server too drunk to fulfill the request";
}
...
```

## Next release

In the next meeting - probably next monday - we will implement the `account` API,
used to retrieve informations about the client's account - useful for knowing how many 
remaining HTTP requests you have, the `whois:availability` API, to check whether a
domain is available or not, and the `whois:record` API, identical to the one we
already implemented, but returning a JSON response.

Then... take a look at the [issue tracker](https://github.com/robowhois/robowhois-php-client/issues)
to stay updated about the state of the project: in the next 3 weeks we should
be able to go out with a stable client for y'all.