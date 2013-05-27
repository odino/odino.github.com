---
layout: post
title: "Why our business choose Symfony2 over any other PHP framework"
date: 2013-05-27 22:16
comments: true
published: true
categories: [Symfony2, Namshi, PHP, Doctrine2, testing, framework, SOA]
---

Everyone knows that I am a big fan of the
Symfony2 ecosystem, and going SOA with
this framework was a very trivial decision
for us at [Namshi](http://en-ae.namshi.com);
all in all, besides personal preferences,
there is a plethora of reasons to choose
this framework among the others available
in PHP, so I am going to list the most
important factors that influenced our
decision.

Believe it or not, all of the following
factors matter **first for the business**,
then for the developers.

<!-- more -->

## Testing

{% img right /images/behat.png %}

We are firm believers in automated test practices,
and providing a layer that integrates very easily
with testing tools (such as Behat or PHPUnit) is a
must for us.

Symfony2 is a testing-prone framework because:

* it is well decoupled, so *unit testing* becomes very easy
since you can mock objects, isolate classes and inject stub
dependencies very easily
* it provides a first layer for functional testing (with PHPUnit):
being an HTTP-centric framework, it provides a [base class](http://symfony.com/doc/2.0/book/testing.html#your-first-functional-test)
that lets you simulate HTTP requests and examine the output; needless
to say, these kind of tests are way faster than the ones that you
would write with tools like Selenium, since they don't have the
overhead of testing with an actual browser
* there is a [Behat extension](http://extensions.behat.org/symfony2/)
that lets you integrate the framework with this behavioral testing tool

At the end, you can see how Symfony2 and the ecosystem around it
provide the proper toolset to run **unit**, **functional** and
**behavioral** tests.
If you do care about testing, this is already a
huge point: we can't afford our developers to **waste**
a huge portion of their time doing manual testing, and
we don't want to increase overhead to build a
manual QA team; since we are a technology startup,
we should take advantage of technology to automate
expensive tasks that harm the business, like
manual testing{% fn_ref 1 %}.

## Debugging

I kind of had so much fun when, while still working
with symfony 1.4, I saw people developing with
frameworks like Yii or Zend Framework 1,
beating their heads on their desks tying to
understand which view to modify, var_dumping
SQL queries to output them and so on:
symfony 1.4 already had a very powerful
debug toolbar that would present all of these
informations in order to ease debugging.

Symfony2 goes beyond what we had before,
providing a way more powerful, extensible
toolbar and an integrated profiler.

{% img right /images/symfony2-profiler.png %}

Database inspection will let you realize
how many queries you are running and see the
SQL of all of them, with a nice overview of the
time they take, while the profiler itself
includes informations about every step
of the application: for example, with Joomla,
can you tell this easily how long it took to
render a particular view and how much memory
was used to execute a controller's action?

Now, imagine each of your developers
(let's say you have a team of 6),
spending 1 hour (very conservative estimate)
out of 40 (a working week) trying to obtain
informations that debugging tools natively give you:
it's almost a day per week; multiply that day for 52
weeks in a year and you will end up loosing
one of your developers for two moths.

We **all** honestly can't afford to let a guy
leave the company for 2 months for free, so why
would we keep using counterproductive tools?

## Doctrine 2

It is no news that we, at Namshi,
[are working with a Service-Oriented Architecture](/refactoring-your-architecture-go-for-soa/),
and we are highly benefiting from the easy
integration that Symfony2 provides for
Doctrine.

One of the rules of thumb of designing
SOAs is that you can provide access to the
same data source to different services:
in simple terms, instead of talking via
webservices or messaging queues, services
can simply access the data stored *somewhere*
by other ones.

{% img left /images/doctrine-cli.png %}

Well, Doctrine 2 is the cherry on top of the
cake to access that *somewhere*: natively
providing support for multiple DB connections
and object-relational mappings, you can safely
use this tool, within Symfony2, to handle read
and writes to different databases without
polluting the domain model of each of the services
that take advantage of Doctrine; in addition to this,
I should enumerate the huge list of good things that
working with a data mapper like Doctrine 2 brings
on the table.

On another note, sharing the data model among different services
helps you overcoming though situations
where webservices or messaging queues are not
enough: think about a service which, due to
an update, needs to modify half a milion records
that "belong" to another service; of course,
istantly having 500k messages in a queue implies
a long, very long time to process them, while
a webservice might not be fully ok with sending
a huge payload over the HTTP protocol - and,
moreover, how do you start testing this feature,
when your developers need to send a lot of MB
through their browser? It is painful, believe me.

At this point, the ability of directly accessing
different DBs come out as a swiss-army knife, as
you can directly execute the 500k updates, in
batch, from the original service.

## Deployments

Symfony2 has an *out of the box*
[integration with Capistrano](http://capifony.org/),
the most popular automated 
deployment tool in the market.

This means that you should forget about
wasting time, money and energy to develop
your own in-house solution to automate
deployments or, even worse, rely on
manual procedure, which are prone to
errors where it hurts the most, on the
"live server".

## DIC

Let's say that you, for example, are
using [Graylog2](http://graylog2.org/)
to handle logs in your application:
while you are developing locally, you
won't have a graylog2 server to connect to,
since it might be that you want to keep
your machine a bit cleaner and you might
find more useful to read local logs
from a file in the filesystem, or directly
output them to the browser.

In Symfony2, thanks to the [dependency-injection container](http://symfony.com/doc/master/book/service_container.html),
you can define the logger as a service:

``` bash config.yml
logger:
    class: 'Monolog\Logger'
    arguments:
        name:           "applicationName-%kernel.environment%"
    calls:
        - [ pushHandler, [ @monolog_handler.graylog ] ]  
monolog_handler.graylog:
    class: 'Monolog\Handler\GelfHandler'
    arguments:
        publisher: @gelf.message_publisher
        level:     200
```

and, for development environments, you
can simply override the configuration in
the `config_dev.yml` file:

``` bash config_dev.yml
monolog_handler.graylog:
    class: 'Monolog\Handler\StreamHandler'
    arguments:
      stream: "php://stdout"
```

This will allow you to output errors that
would normally go to graylog2 directly to
the developer's browser, easing debugging
when you can afford to display errors in
the browser - thing that is not possible
who's viewing your application is a
potential customer.

Apart from all the technicalities involved
in using a DIC, I would like to focus on
one point: again, simplicity and speed to implement a
solution to a problem (having different log
handlers depending on the application's environment,
in this case) are a winning factor for your
development team, which is translated in **more
productivity for your company**.

## Bundles

When we kickstarted our first Symfony2-based
service in our architecture, we decided to meld
together 2 applications that support our CRM
and ERP systems: being inside Symfony2, these
layers are **fully isolated** in separate bundles,
giving us the ability of phisically decoupling them
in 2 installations in a matter of minutes.

Bundles are probably one of the most powerful
concepts of Symfony2, since they are
micro-applications inside your main application:
being able to totally separate logics from different
domains helps you in keeping a clean separation
of concerns and autonomously develop every single
feature of your domain.

## Declarative code

Consider the following snippet, written using the
[Symfony2 Finder component](http://symfony.com/doc/master/components/finder.html):

``` php
<?php

use Symfony\Component\Finder\Finder;
use Zend_Service_Amazon_S3 as Amazon_S3;

$s3 = new Amazon_S3($key, $secret);
$s3->registerStreamWrapper("s3");

$finder = new Finder();
$finder->name('photos*')->size('< 100K')->date('since 1 hour ago');

foreach ($finder->in('s3://bucket-name') as $file) {
    print $file->getFilename();
}
```

After your **first** look at this code, you already know
what it is doing: now imagine that your team of developers
need to, instead, try to understand how the Drupal
framework works.

Taken from [Drupal's source code](https://github.com/drupal/drupal/blob/7.x/modules/comment/comment.admin.inc#L271):

``` php
<?php

/**
 * Process comment_confirm_delete form submissions.
 */
function comment_confirm_delete_submit($form, &$form_state) {
  $comment = $form['#comment'];
  // Delete the comment and its replies.
  comment_delete($comment->cid);
  drupal_set_message(t('The comment and all its replies have been deleted.'));
  watchdog('content', 'Deleted comment @cid and its replies.', array('@cid' => $comment->cid));
  // Clear the cache so an anonymous user sees that his comment was deleted.
  cache_clear_all();

  $form_state['redirect'] = "node/$comment->nid";
}
```

I'm far from saying that Drupal sucks, but some
questions rise into my mind:

* why do I have a `$form` and a separate `$form_state`?
* what is `watchdog()` doing? Is it used for
logging? Or to display flash messages?
* what is a `cid`? And what about the `nid`?
* why should I clear my entire application's
cache to notify a user of a change?

See, you don't want your developers to have to go
through an entire application to understand what
a piece of code does.

## Best practices

Symfony2 is a framework made to take advantage
of clean and clear tested patterns as well as
tools to improve the final developer's
productivity: imagine your team, working
six months on this framework; how much would
they learn? How many structural changes 
would they be able to do on your application without
introducing regressions?

{% img right /images/best-practice.jpg %}

For startups, by the way, a huge plus comes from
the fact that being highly decoupled, Symfony2 helps
when you want to drastically replace a piece of software,
or an adapter, with another one: for example,
thanks to the dependency-injection container,
you would be able to replace application services
with others that have the same API, but a different
implementation.

It is clear enough that Symfony2 provides the
flexibility you need to reach a very short
*time to market* and increases your developers'
awareness and efficiency by giving them the
guidance and the tools they need to care about
the domain of your services and not about how
many bugs they would introduce by changing an
untested piece of code.

## All in all...is it Symfony2?

A very simple question that you should ask
yourself at the end of this reading is:
but, all in all, is this all thanks to
Symfony2 or its surrounding environment?

It is its surrounding environment, which
was born thanks to the framework itself:
when Symfony2 was released, no other framework
had the same level of quality that the open source
product from SensioLabs could offer;
a natural effect of this was that the
majority of well-known open source 
PHP developers got amused by this framework
and embraced its way.

Basically, Symfony2 is a framework chosen by
the community, thus it can take advantage of
all the efforts of the OS developers around it:
from automated deployment tools to fully integrated
ORMs, from testing frameworks to tutorials
and best practices, through native, advanced
debugging tools, Symfony2 is, as of today the most
complete framework available in the PHP ecosystem
when you take in consideration learning curve,
integrations, stability and performances (don't forget
that one of [top 100 website in the Alexa rank](http://highscalability.com/blog/2012/4/2/youporn-targeting-200-million-views-a-day-and-beyond.html)
is powered by Symfony2{% fn_ref 2 %}).

Can other frameworks do all of this?

For the benefit of your **business**, this
is the main question that you should ask
yourself.

{% footnotes %}
	{% fn But - drumroll - since we are an e-commerce company, we always need to ensure that some critical parts of the system, like checkouts, are tested by a human reenacting our customers' behavior. So yes, for a few, business-critical things, we really *want* to do manual tests. %}
	{% fn Even though I am sorry for using *that* website as an example, it is a very useful use-case when you consider its technical stack. %}
{% endfootnotes %}