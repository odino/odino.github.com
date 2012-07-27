---
layout: post
title: "Using Monolog for PHP error reporting on New Relic"
date: 2012-07-27 08:00
comments: true
categories: [PHP, Monolog, New Relic, log management]
---

I **do** really like [New Relic](http://newrelic.com/), a real-time
error reporting solution available for many
platforms, so a few days ago I decided to
integrate it with [Monolog](https://github.com/Seldaek/monolog/), the other
main logging tool that we use here at
Rocket.

<!-- more -->

The idea behind it is very simple: since
New Relic is not always available on
development platforms, you first verify
that the PHP extension is loaded, then,
if it is, log a report on New Relic:
if the extension is not available, another
logging handler will act as a fallback.

To reach our goal we will simply need the
New Relic PHP extension, Monolog and the
Symfony2 [dependency injection container](http://symfony.com/doc/current/book/service_container.html).

## Catching the error and reporting it

Let's start with a real world example, you
have a controller action that receives some
`POST` data and throws an exception whenever
the input data is missing some values{% fn_ref 1 %}.

``` php A simple action
<?php 

namespace Application\Webservice;

use Application\MVC\Controller as BaseController;
use Application\Webservice\Exception;

class Controller extends BaseController
{
	public function updateDatabaseData(array $data)
	{
		try {
			$this->validateData($data);

			// ...
		} catch (Exception $e) {
			$this->container->get('logger.new-relic')->error($e->getMessage(), $data);
		}
	}
}
```

So, at this point, we just need to define the `logger.new-relic`
service in the DIC configuration file:

``` yml The DIC configuration file
services:
  logger.new-relic:
    class: "Monolog\\Logger"
    arguments:
      name: "new-relic"
    calls:
      - [ pushHandler, [@log.handler.new-relic] ]
  log.handler.new-relic:
    class:  "\\Application\\Log\\Handler\\NewRelic"
    calls:
      - [ setFallbackHandler, [@log.handler.standard] ]
  log.handler.standard:
    class:  "Monolog\\Handler\\StreamHandler"
    arguments:
      stream: "/tmp/error-log.txt"
```

As you see we define a Monolog logger designed
specifically for New Relic (`logger.new-relic`)
and an handler that will try to log everything
on the remote NR server: this handler also has a
fallback handler, if the New Relic PHP extension is
not available, which is configurable directly
within the YAML file (`log.handler.error`).

## The log handler

The New Relic handler is **really**
straightforward:

``` php The New Relic log handler
<?php

/**
 * Class used to log on New Relic.
 */

namespace Application\Log\Handler;

use Monolog\Handler\AbstractProcessingHandler;
use Monolog\Handler;

class NewRelic extends AbstractProcessingHandler
{        
    protected $fallbackHandler;
    
    /**
     * Logs a $record on New Relic, providing additional parameters from the
     * record's context.
     * If the New Relic extension is not available and a fallback handler is
     * provided, it will simply log the error with a fallback.
     * 
     * @param array $record 
     */
    protected function write(array $record)
    {
        if (extension_loaded('newrelic')) {
            newrelic_notice_error($record['message']);
            
            foreach ($record['context'] as $key => $parameter) {
                newrelic_add_custom_parameter($key, $parameter);
            }
        } elseif ($this->fallbackHandler instanceOf AbstractProcessingHandler) {
            $this->fallbackHandler->write($record);
        }
    }
    
    /**
     * Sets the fallback handler to be used to log informations if the New Relic
     * extension is not available.
     *
     * @param Monolog\Handler\AbstractProcessingHandler $handler 
     */
    public function setFallbackHandler(AbstractProcessingHandler $handler)
    {
        $this->fallbackHandler = $handler;
    }
}
```

So, the code is pretty simple: we implement the `write` method
of `AbstractProcessingHandler` in our `New Relic` class,
using New Relic's low level functions to notice the
error and add some more informations about the
context surrounding the exception: the fallback
handler will take stage only if the New Relic
extension isn't loaded.

## Log systems and analysis

Simple but pretty useful: if you use either
New Relic or Monolog I strongly recommend you
to integrate into your log management system
the missing tool since:

* New Relic serves as a nice reporting tool,
giving you an overview of the amount of
errors logged over some time, letting you
define tresholds for error reporting and
grouping errors to measure the impact a code
change can have on your applications{% fn_ref 2 %}
* Monolog gives you a great abstraction and
log handlers, which can very easily ease
your job in taking the right action for
different types of errors{% fn_ref 3 %}
(as you saw, with the DIC it's pure joy to
instantiate and use different handlers based
on a configuration file)

At Rocket Turkey & MENA we really care about logs:
being a product-based company, **a bug in our
system is a bug on our core business**, so we need
to easily be able to spot problems.

So far, using Monolog and New Relic as both standalone and combined
products has been a very good choice, since with
New Relic with have a pretty overview about
error reporting, while Monolog gives us the
ability to easily debug problems in our
integrations, since solving problems with all
the data we track with it it's really easier,
and if we need to change logs' format or add new data
to the logs because we notice that it would speed
up troubleshooting and log analysis, making
the change is relatively easy, since it's a
really well OOP-written library.

{% footnotes %}
  {% fn Bare in mind that I will be very brief in my examples, so you won't learn how to bootstrap the DIC here, for example %}
  {% fn I say applications since, as you may know, in New Relic you can handle multiple machines to be registered as different applications (like frontend/backend/mail server/cron slave/gateway) %}
  {% fn In fact,whenever an email is not delivered by your email sever, it's not a problem, but when you start seeing that the amount of mails that are not delivered are too much, you may consider to use a critical handler, specifically designed to send an SMS/email to some contacts %}
{% endfootnotes %}
