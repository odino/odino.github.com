---
layout: post
title: "Why Joomla sucks, why the Joomla platform sucks even harder and how We can fix this"
date: 2011-07-18 12:00
comments: true
categories: [PHP]
alias: "/367/why-joomla-sucks-why-the-joomla-platform-sucks-even-harder-and-how-we-can-fix-this"
---

I started using Joomla! in 2007 and then I massively focused my old company technology know-how on it when version 1.5 came out.

In 2009 I abandoned it because I had so much pain in the *** trying to fit this product to customers' needs and, other big reason, because I lost enthusiasm on developing on such this kind of platform.
<!-- more -->

Seriously, no fun at all after a few months I worked with it.

Seriously, I wrote a few extensions I'm not proud of. **At all**.

So, as you might understand, I need to reveal a big disclaimer before digging into this post: it's been a while I don't use Joomla! in production and I didn't even used the 1.6 version, which had some cool features the 1.5 series lacked of.

But I always followed the project, as an external watcher, in order to understand where it was going, its aims, its gotchas and so on.

I love the idea behind this CMS, but I hate how it is implemented and the way the entire project is handled.

That's why, in the title of my post, I put a couple *sucks*: since I don't want to bitch around offending a good product with a great community, I'll analyze the motivations that led me to think Joomla! sucks hard and I could not use it for my projects, those I made with my former company ( and it was my company ) and those we are manufacturing in [DNSEE](http://www.dnsee.com/).

##All the way with Django

I was fascinated by a talk entitled "[Why Django sucks, and how We can fix it](http://www.scribd.com/doc/37113340/Why-Django-Sucks-and-How-we-Can-Fix-it)", because it had a purpose: highlighting the bad and the evil of the framework providing some proposals to fix them.

So I will take inspiration from that talk so you will read about:

* things that suck in Joomla!
* why they suck
* how to fix them

##Joomla!

As you might know, Joomla! is a fork of a procedural crap called [Mambo](http://www.mamboserver.com/), an *en-vogue* CMS during the old fashion age of **PHP 4**, when men were living in caves and, if you were a woman, your job was picking up berries from the woods near to your own cave, while your man was out, hunting mammoths.

At that time, PHP solutions were not properly engineered and a lot of concepts, like [SoC](http://en.wikipedia.org/wiki/Separation_of_concerns), [IoC](http://en.wikipedia.org/wiki/Inversion_of_control), [OOP](http://en.wikipedia.org/wiki/Object-oriented_programming) [*insert every kind of goodness we have nowaday here*] were missing.

So we had **Joomla! 1.0**, a political fork of Mambo ( and the DevTeam had the right reasons to fork it ) which was, basically, Mambo with a different name.

In 2008 we had **Joomla! 1.5**, an almost-completely rewritten version of the CMS, with a new framework, still supporting some legacy stuff but better engineered, althought still crappy.

##Joomla! 1.5 and 1.6: what a mess!

If we consider Joomla! 1.5/6 we agree on the fact that it's not properly engineered or, better, not as engineered as its community claims it is.

First of all you notice that there is no decent abstraction layer for the DB: only 2 PDOs are supported, [Mysql and Mysqli](http://joomlacode.org/svn/joomla/development/releases/1.5/libraries/joomla/database/database/), so you can basically just install Joomla! with MySQL.

Looking at the tests of the framework, you can see that in the version 1.5 the [code coverage of the framework was very weak](http://joomlacode.org/svn/joomla/development/releases/1.5/tests/unit/suite/), while in 1.6 they [improved it](http://joomlacode.org/svn/joomla/development/trunk/tests/unit/): the ugly thing is that ots of "unit" test are not that *unit*](http://joomlacode.org/svn/joomla/development/trunk/tests/unit/suite/libraries/joomla/form/JFormDataHelper.php).

You can also find other masterpieces of the software right around: for example [helpers which handle models' responsabilities](http://joomlacode.org/svn/joomla/development/trunk/components/com_content/helpers/query.php). Not even MVC.

Again, **not even MVC**.

And then, again, no decent abstraction on the core components of a framework/cms, like HTTP requests ( [$_SERVER is so 2003](http://joomlacode.org/svn/joomla/development/trunk/components/com_content/controller.php) ).

##The golden age which started from the 1.6 series

Now we have Joomla! 1.6 and will have a newer version of Joomla! every six months ( like Ubuntu ): the DevTeam decided to separate the framework from the actual CMS, so they invented the Joomla! platform, because, you know, it's nice to have a clear separation between the foundation of your product and the product itself.

But the question is not "**Why** did they do this?", because I fully agree with that decision: the real question is **How?**.

And here comes the hard part.

## The Joomla! Platform

If you look at the [Joomla! Platform](https://github.com/joomla/joomla-platform) on GitHub you will see a few things that I still can't believe they could be included in a "framework".

No namespaces, no standardization of the [autoloading](https://github.com/joomla/joomla-platform/blob/master/libraries/loader.php) through the [PSR0](http://groups.google.com/group/php-standards/web/psr-0-final-proposal)...

And other stuff that I want to spend a few lines on:

* [Factory](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/factory.php) is really a good design pattern, but you should couple it with DI and, if needed a DI container
* Do we really need such this kind of code in every file? `defined('JPATH_PLATFORM') or die;`
* [static methods are everywhere](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/access/access.php) and, oh my, there are even methods that [spend a few lines in order to inspect if they live in a static context or not](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/database/table.php#L924)
* lack of abstraction is well expressed when [a Table object ( DB-related ) throws a generic exception](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/database/table.php#L963): how the hell a coder can extend this code implementing fault-tolerance?
* [methods embarrassing themselves](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/document/document.php#L196)
* dependency injection [heavily ignored](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/session/session.php#L446)
* [useless pieces of code](https://github.com/joomla/joomla-platform/blob/master/libraries/joomla/form/form.php) already written - better - by Zend Framework and Symfony

Besides all of this, why do we need **just another framework**?

It is obvious that if we consider the evolution from Mambo to Joomla! 1.6 the road has been cool and long, mostly succesfull ( for **Joomla!, the brand** ) but the product had to face a tremendous slow down of the development process, internal quality and so on.

Internal quality is the biggest problem I'm considering now, because it's the quality of a software which makes the software itself evolve faster/slower, without/with pain in the ass. 

The quality of Joomla! CMS and the platform is not that good and the biggest problem is that we should not expect something well-engineered from people stucked on the old PHP world.

And stucked to some idiotic ideas like [re-inventing the software is really cool, because other's sw is crap](http://people.joomla.org/groups/viewdiscussion/634-a-framework-i-mean-a-real-framework.html?groupid=630). 

If you take a look at the points I highlight in my post on people.joomla.org you'll notice that:

* people think Joomla! is the coolest software on the planet, and the Joomla! community can make great things
* after I point out some problems, people recognizes that there is something evil in this way of managing a software
* after that, the excuse is to bring feelings into the battlefield:

{% blockquote %}
I could go through the rest of what you've mentioned, but I don't think that it is helpfull.
Mainly because I'm most likely wrong, but will defend all this to the blood because I'm emotionally attached to it. ;-)
{% endblockquote %}

Seriously, guys?

## Steal... I mean, reuse, or fork if you need to!

So after saying really ugly things on this wonderful CMS and its community, it's time to throw a solution, the solution I recommend, into this post: **stealing code**.

Take a look at [Symfony](http://www.symfony.com/): it all started before 2007 ( so before Joomla! 1.5 ), when Fabien Potencier decided to fork the Mojavi{% fn_ref 1 %} framework1 and expand it integrating a few other libraries, like some parts of the Zend Framework, Prado and so on. 

Since Fabien isn't stupid, he took the best from a few projects to deliver one of the first real RAD frameworks for PHP, and after doing that, he took inspiration from Spring to re-engineer "his" framework and deliver Symfony2 ( which is in RC4 now ): also Symfony2 likes to steal code; for example, the logging aspect is handled with [Monolog](https://github.com/Seldaek/monolog).

Not only code, that's obvious: Symfony2 has also stolen a 10 years old specification, the [ESI](http://www.w3.org/TR/esi-lang) language one, in order to spare development time and teach people that HTTP cache is almost **total**.

But as you probably know, I'm not really talking about stealing actual things, but rather about taking inspiration about good ideas and re-using great products to speed up our development process and deliver better software.

**Look, try, re-use**: that should be the motto for the Joomla! core team.

{% footnotes %}
  {% fn David Zuelke started developing Agavi from the same - more or less - point %}
{% endfootnotes %}
