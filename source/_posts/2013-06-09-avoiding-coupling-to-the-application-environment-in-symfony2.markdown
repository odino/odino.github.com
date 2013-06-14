---
layout: post
title: "Avoiding coupling to the application environment in Symfony2"
date: 2013-06-09 10:52
comments: true
categories: [Symfony2, PHP]
published: false
---

A very nice thing that come out of a dependency injection container
is the ability to override service definitions: thanks
to this, in Symfony2 we can avoid writing environment-dependent
domain code.

<!-- more -->

[Richard Miller](http://richardmiller.co.uk/2013/05/28/symfony2-avoiding-coupling-applications-to-the-environment/),
engineer at SensioLabs UK, came out, a few days ago,
with an idea on how to decouple the application from the
environment, in order to avoid writing
environment specific code like:

``` php
<?php

class Mailer
{
	public function send()
	{
		if ($this->container->getParameter('kernel.environment') == 'prod') {
		    mail(...);
		}

		return true;
	}
}
```

In my opinion, there is still room for
improvement, as you can actually use the
`config_%ENV%.yml` files to achieve better
isolation:

``` bash config.yml
mailer:
	class: "Acme\Mailer"
```

``` php
<?php

namespace Acme;

class Mailer
{
	public function send()
	{
		mail(...);

		return true;
	}
}
```
Let's say that now, for testing purposes you
want to test the mailer in the `test`
environment:

``` bash config_test.yml
mailer:
	class: "Acme\Test\Mailer\Working"
```

``` php
<?php

namespace Acme\Test;

use Acme\Mailer as BaseMailer;

class Mailer extends BaseMailer
{
	public function send()
	{
		return true;
	}
}
```

Basically, these new mailer classes act as stub
for your tests:

``` php
<?php

namespace Acme\AcmeBundle\Tests\Controller;

use Liip\FunctionalTestBundle\Test\WebTestCase;

class SampleTest extends WebTestCase
{
    public function testAnEmailGetsSent()
    {
        $client                 = static::createClient();
        $client->request('POST', '/api/mail');
    }
}
```
