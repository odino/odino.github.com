---
layout: post
title: "A PHP library to retrieve WHOIS informations"
date: 2012-02-03 03:40
comments: true
categories: [PHP, open source]
---

{% render_partial series/robowhois.markdown %}

In this days me and my friend [David](http://davidfunaro.com) are renewing our committment
to *open source*: our next project is going to be an **SDK for a
WHOIS webservice**.
<!-- more -->

{% img right /images/robodomain.png %}

Last week we got in touch with Simone, the mind behind [Robodomain](http://robodomain.com),
a startup delivering a really useful product, which lets you

{% blockquote Robodomain http://robodomain.com Official website %}
Keep track of all your domains in one place.
Check domain status, log transactions, orders and payments, store notes and enjoy our network tools.
{% endblockquote %}

To be able to develop its own software (in Ruby) he started writing a [Gem](http://www.ruby-whois.org/)
and then realized that this kind of stuff could be useful to other people too: he decided to
open a public API - you only need to pay a bunch of bucks to use it - and launch a new, free,
universal WHOIS service that everyone can enjoy.

We are taking the stage in order to develop the official **PHP SDK** for the webservice, so
- along with the development of [Orient](http://github.com/congow/Orient) - you'll read here
about this new library in the next weeks.

We have just kickstarted the project, designed the first interfaces, implemented a bunch of
methods and tested them: if you are courious enough you can spot them over the internet, but
I won't link and share what we developed until our next DevMeeting, in which we will do the
majority of the work. 

However I want you to enjoy a preview of what you will be able to do with it (just some explanatory LOCs):

``` php This is definitely NOT gonna be the code you'll be using, just an example of how things work now
<?php

use Robowhois\Robowhois;
use Robowhois\Http\Client;
use Buzz\Browser;

$robowhois = new Robowhois($apiKey, new Client(new Browser()));

if ($robowhois->isAvailable("google.com")) {
  echo "Hey man, go register google.com, seems that it's free!";
} else {
  $whois = $robodomain->whoisProperties('google.com');

  echo "Man, you'll need to wait until " . $whois->expiresAt()->format('Y-m-d H:i:s');
  // $whois->expiresAt() returns a \DateTime object
}

```

As far as we've already done, this SDK uses Symfony2's [HttpFoundation](https://github.com/symfony/HttpFoundation)
and [Buzz](https://github.com/kriswallsmith/Buzz) to properly handle
communication with the webservice through the HTTP protocol: we are open to any suggestion, so
if you know a very good HTTP client that could replace Buzz{% fn_ref 1 %} we would be very
glad to evaluate it.

The standard bootstrap of the library will be also using Symfony2's [dependency injection
container](https://github.com/symfony/DependencyInjection). 

{% footnotes %}
  {% fn Not Zend\Http\Client %}
{% endfootnotes %}
