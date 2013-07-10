---
layout: post
title: "Notificator, sending notifications through PHP in a clean and lightweight way"
date: 2013-07-11 01:20
comments: true
categories: [PHP, Open Source, FOSS, notifications, messaging, RabbitMQ, Symfony2, Github]
---

While implementing various pieces of our
[Service-Oriented Architecture](/why-we-choose-symfony2-over-any-other-php-framework/)
we, at [Namshi](http://en-ae.namshi.com),
realized that a central notification
service would have been very good in order
to abstract the way we notify our customers
and everyone in the company (ie. skype messages
when a task is due a certain date).

We initially implemented all of this
[inside a Symfony2 bundle](/configuring-a-symfony2-application-to-support-soa/),
but soon realized that we could
abstract and generalize our implementation
in order to extract it into a library for the public
domain, and that's how
[notificator](https://github.com/namshi/notificator)
was born.

<!-- more -->

## Aim of the library: a monolog-like implementation for notifications

The aim of this library is to provide a very
clean abstraction for a task, handling notifications,
that can be spread across multiple channels (for example
emails, skype messages, desktop notifications, ...):
by following this target, we soon realized that by merging
together 2 simple things, [Monolog](https://github.com/Seldaek/monolog)
and the concept of [event dispatching](http://en.wikipedia.org/wiki/Observer_pattern),
we could have easily reached our goal.

Honestly, it's true that you can achieve the same goal with
Monolog, but the problem, there, is that it's a library
specifically built for logging, thus, when your domain
deals with simple notifications, your code would really
be inexpressive.

Even though **Notificator is way simpler**, we took a lot
of inspiration from Monolog: for example, the concept of
handlers is a total steal ;-)

## Installation

The library is available via composer,
as you can see from its
[packagist page](https://packagist.org/packages/namshi/notificator).

Using semantic versioning, I recommend you
to pick a minor release (`1.0`, for example)
and stick to it in your `composer.json`:
what we try to do is that, if there is a BC break
in the API, we increase the minor version (`1.0.X` to `1.1.X`, for example).

At the end, you **should** require it like this:

```
"namshi/notificator": "1.0.*"
```

## Hello world! example

Just to give a very rough and simple example on how this
library works, let's see how you can trigger a notification
via **both** email (with PHP's `mail` function{% fn_ref 1 %})
and the `notify-send` utility available on ubuntu (I've already spoke
about it in [a previous post](/desktop-notifications-for-phpunit-tests-on-ubuntu/)).

First of all, we would need to create a *plain-old-php-class*
representing the notification, which implements 2 interfaces:

``` php
<?php

use Namshi\Notificator\Notification;
use Namshi\Notificator\NotificationInterface;

interface NotifySendNotificationInterface extends NotificationInterface
{
    public function getMessage();
}

interface EmailNotificationInterface extends NotificationInterface
{
    public function getAddress();
    public function getSubject();
    public function getBody();
}

class DoubleNotification extends Notification implements NotifySendNotificationInterface, EmailNotificationInterface
{
    protected $address;
    protected $body;
    protected $subject;

    public function __construct($address, $subject, $body, array $parameters = array())
    {
        parent::__construct($parameters);

        $this->address  = $address;
        $this->body     = $body;
        $this->subject  = $subject;
    }

    public function getAddress()
    {
        return $this->address;
    }

    public function getSubject()
    {
        return $this->subject;
    }

    public function getBody()
    {
        return $this->body;
    }

    public function getMessage()
    {
        return $this->getBody();
    }
}
```

At this point we need 2 notification handlers, which
will separately handle the notification:

``` php
<?php

use Namshi\Notificator\Notification\Handler\HandlerInterface;
use Namshi\Notificator\NotificationInterface;

class NotifySendNotificationHandler implements HandlerInterface
{
    public function shouldHandle(NotificationInterface $notification)
    {
        return $notification instanceOf NotifySendNotificationInterface;
    }

    public function handle(NotificationInterface $notification)
    {
        shell_exec(sprintf('notify-send "%s"', $notification->getMessage()));
    }
}

class EmailNotificationHandler implements HandlerInterface
{
    public function shouldHandle(NotificationInterface $notification)
    {
        return $notification instanceOf EmailNotificationInterface;
    }

    public function handle(NotificationInterface $notification)
    {
        mail($notification->getAddress(), $notification->getSubject(), $notification->getBody());
    }
}
```

We're basically there: with a bunch of code we can now trigger
a notification both via email and `notify-send`:

``` php
<?php

// create the manager and assign handlers to it
use Namshi\Notificator\Manager;

$manager = new Manager();
$manager->addHandler(new NotifySendNotificationHandler());
$manager->addHandler(new EmailNotificationHandler());

$notification = new DoubleNotification('alessandro.nadalin@gmail.com', 'Test email', 'Hello!');

//  trigger the notification
$manager->trigger($notification);
```

{% img right /images/notification-email.png %}

At this point, if you run this example{% fn_ref 2 %}, you should
see a notification popping up on your desktop and, in a few seconds,
you will also receive an email to the address you've given, with the subject
"Test email" and "Hello!" in the body.

By the way, if you want to see some examples on
how the library works, [check them out on github](https://github.com/namshi/notificator/tree/master/examples).

## Sending notifications via RabbitMQ

It is no news that we heavily rely on
[RabbitMQ in our SOA](http://odino.org/refactoring-your-architecture-go-for-soa/),
so it's pretty obvious that, to implement the notification service,
we send messages containing the notifications, that will
be intercepted by our notification service, which relies on
Notificator.

To do so, we take advantage of the great job done by
[Alvaro Videla](https://twitter.com/old_sound)
on RabbitMQ for PHP and Symfony2, through the
[PHP AMQP library](https://github.com/videlalvaro/php-amqplib)
and the [RabbitMQ bundle](https://github.com/videlalvaro/RabbitMqBundle).

If you are familiar with them, you know that in order to consume messages,
you have to declare your consumer as a callback of the actual, generic
rabbitmq consumer, through the `config.yml` file:

``` yaml app/config/config.yml
old_sound_rabbit_mq:
    consumers:
        notification:
            connection: default
            exchange_options: {name: 'notifications', type: direct}
            queue_options:    {name: 'notifications'}
            callback:         namshi.notification.consumer

services:
	namshi.notification.consumer:
	    class: Namshi\Notificator\Messaging\RabbitMQ\Symfony2\Consumer
	    arguments: [@namshi.notification.manager]
	namshi.notification.manager:
	    class: Namshi\Notificator\Manager
	    calls:
	      - [addhandler, [@namshi.notification.handler.notify_send] ]
	namshi.notification.handler.notify_send:
	    class: Namshi\Notificator\Notification\Handler\NotifySend
```

We already provide a [very basic consumer callback](https://github.com/namshi/notificator/blob/master/src/Namshi/Notificator/Messaging/RabbitMQ/Symfony2/Consumer.php)
to be used with the RabbitMQ bundle.

The main idea behind this is that the publisher serializes the notification
and sends it through RabbitMQ, while the consumer unserializes and
triggers it through the `Manager`. The publisher code would be very, very simple:

``` php
<?php

$publisher = $container->get('old_sound_rabbit_mq.notifications_producer');

$notification = new MySampleNotification("man, this comes from RabbitMQ and Symfony2!");

$publisher->publish(serialize($notification));
```

and to start consuming messages you would only need to
start the consumer:

```
php app/console rabbitmq:consumer -w notification
```

## FOSS

I've tried to write a pretty extensive
[README](https://github.com/namshi/notificator/) that you can use as a reference, on Github
(check the [tests](https://github.com/namshi/notificator/tree/master/tests), as well, to get an idea of the internals):
if you spot any typo or mistake, don't hesitate to
reach out and point it out.

This library is part of the efforts,
from [Namshi](https://github.com/namshi),
to be able to give back to the
OSS community as much as possible: you
are therefore strongly encouraged to open a PR
or express your opinion if you find that something
should be fixed or could be improved (there's a lot
of room for improvement, starting by implementing
many more [handlers](https://github.com/namshi/notificator/tree/master/src/Namshi/Notificator/Notification/Handler)).

{% footnotes %}
	{% fn Only used for its simplicity here, please do not use it in production, use stuff like SwiftMailer instead! %}
	{% fn I mostly took the example code from the README of the library on github, so forgive me if there are synthax errors or some typo. You can anyhow have a look at the examples (in the examples/ folder) to check some working code %}
{% endfootnotes %}