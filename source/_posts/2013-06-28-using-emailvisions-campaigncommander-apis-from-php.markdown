---
layout: post
title: "Using Emailvision's CampaignCommander APIs from PHP"
date: 2013-06-28 18:38
comments: true
categories: [php, email, open source]
---

{% img right /images/emailvision-template.png %}

This weekend I finally had the chance to
work a couple hours on the `namshi/emailvision`
library, which lets you integrate CampaignCommander
as (email) notification solution in your
PHP projects.

I already had a proof-of-concept of this library since weeks,
and it was already pushed to Github, but since I had no
valid API account to do some integration tests, I
could not really "publicize" it.

Right now I refactored the library and added a couple integration
tests which are working flawlessy, so, in this post, I'm
going to show you how easy it is to send emails with
Emailvision's solution directly from PHP.

<!-- more -->

## Installation

As usual with the latest libraries built for PHP,
the installation can simply be done with composer,
as the library itself is available over
[packagist](https://packagist.org/packages/namshi/emailvision):

``` bash composer.json
"namshi/emailvision": "dev-master"
```

then you simply have to run a `php composer.phar update` and
you can start utilizing it in your codebase (the namespace is
`Namshi\Emailvision`, as this library has been built in the
context of our company, [namshi.com](http://en-ae.namshi.com)).

As of today, the latest stable release is `1.0.0`, which is the
one we recommend to run in production - keep an eye on packagist
if we come up with changes, but I bet it won't change that much
in the near future, as emailvision's API is pretty simple.

## Usage

After you configure transactional email templates in the
CampaignCommander web interface, you just need to keep in mind
(and in your code) the unique identifier and the security tag
of the template; the rest is very straightforward:

``` php
<?php

use Namshi\Emailvision\Client;

$config = array(
    'random'            => 'UNIQUE_IDENTIFIER',
    'encrypt'           => 'SECURITY_TAG',
    'senddate'          => new \DateTime(),
    'uidkey'            => 'EMAIL',
    'stype'             => 'NOTHING',
);

$emailvisionClient = new Client($config);
$emailvisionClient->sendEmail("someone@gmail.com");
```

The nice thing here is that Emailvision lets you schedule
emails, so you can just play with the `senddate` parameter
and set it to the future - just be aware that it needs to
be a `DateTime` instance:

``` php
<?php

use Namshi\Emailvision\Client;

$date = new \DateTime('2025-01-01 12:45:00');

$config = array(
    'random'            => 'UNIQUE_IDENTIFIER',
    'encrypt'           => 'SECURITY_TAG',
    'senddate'          =>  $date,
    'uidkey'            => 'EMAIL',
    'stype'             => 'NOTHING',
);

$emailvisionClient = new Client($config);
$emailvisionClient->sendEmail("someone@gmail.com");
```

This code will tell CampaignCommander to trigger
the email on the 1st of January 2025, at 12:45.

## Dynamic content in your emails

If we would stop here, the library would be pretty
useless, since the power of transactional emails
is to be able to serve dynamic content: in fact, the API
allows you to pass as much variables as you want
that can be configured and used in the email templates
you've created in emailvision's web interface.

To do so, once you call the `sendEmail` method of the
client, just pass an array of variables (strings) as second
argument:

``` php
<?php

$emailvisionClient->sendEmail("someone@gmail.com", array(
	'name' => 'Alex!',
));
```

and then you will start receiving personalized emails:

{% img center /images/emailvision-received.png %}

## Running the tests

Of course, we've added some unit and **integration**
tests which let us refactor the library and add
functionalities to it without regressions; to run
the test suite, just use `phpunit`:

``` bash
cd /path/to/namshi/emailvision

phpunit
```

You will notice that even though the tests should contain
some actual HTTP calls, they are very fast: this is because,
unless you provide some real credentials for emailvision,
integration tests aren't run by default.

To run them, you will have to create a new dummy email template
on CampaignCommander and store the credentials you get
after saving it and the email address that is going to
receive the test emails in a file named `emailvision.config`
in your system's temporary folder (you can get it by
running `php -r "echo sys_get_temp_dir();"`):

``` php /tmp/emailvision.config
<?php

$encrypt 	= 'email_template_security_tag';
$random 	= 'email_template_unique_id';
$email 	= 'your.address@gmail.com';
```

Enjoy!