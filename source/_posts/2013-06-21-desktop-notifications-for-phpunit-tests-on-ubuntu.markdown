---
layout: post
title: "Desktop notifications for PHPUnit tests on Ubuntu"
date: 2013-06-21 03:48
comments: true
categories: [PHPUnit, testing, linux, ubuntu, PHP]
---

{% img left /images/phpunit-notification-ko.png %}

As everyone knows, automated tests are great
since they let you test a system without the need
of proactively checking anything: you launch your suite
and you get a feedback; moreover, systems like Jenkins or Travis-CI allow you
to even forget about checking the status of
a build since they can do all of this work for you:
the problem, instead, happens when you need
to run the tests locally, as you always need to
check the shell to know whether the tests passed or not.

A solution would be to launch the tests and mind
your own business, instead of having to check the CLI
output, waiting for a notification that tells
use about the tests' result.

<!-- more -->

## Notifications to the rescue

A very simple program, written for Linux, can help
you with this task: it's `notify-send`.

Given that you have PHPUnit installed via composer
(so the binary is accessible at `./vendor/bin/phpunit`)
you can simply use a small shell function that can
sends notifications about the tests' results, that I
put on [Github](https://github.com/odino/phpunit-notifications).

## Installation

Clone the repository and add the shell function to your
shell profile{% fn_ref 2 %}:

```
cd wherever

git clone git@github.com:odino/phpunit-notifications.git

chmod +x phpunit-notifications/phpunit-notifications.sh

echo 'source wherever/phpunit-notifications/phpunit-notifications.sh' >> ~/.zshrc
```

## Usage

At this point you can open a new shell and run your tests with
the `phpunit` commmand:

```
cd ~/projects/my-project

phpunit

// or

phpunit -c config

// or

phpunit tests/My/Example/ClassTest.php
```

{% img left /images/phpunit-notification-ok.png %}

and see that as soon as the tests are over you will
see one of those usual notifications on the top right
of your screen, hopefully telling you that the automated
tests suite is greener than ever.

The `notify-send` utility is probably not available on
Macs, but I guess you can just replace it with `growlnotify`.

If you are interested into digging deeper into the topic,
I would suggest you to read a very nice article from
Giulio Di Donato which explains how to [run PHPUnit tests for Symfony2 as soon as any file in your filesystem changes, and get the same type of notifications](http://welcometothebundle.com/automate-test-and-code-inspection-in-php-with-guard-and-symfony2/):
even though I personally think this approach is a little
bit too extreme{% fn_ref 3 %}, it is anyhow interesting as
it pushes automation and time-management to their best limits.

{% footnotes %}
	{% fn Or, for example, to empty the tables of the right database after each test (there are different databases for each website) %}
	{% fn I am personally using ZSH: https://github.com/robbyrussell/oh-my-zsh %}
	{% fn If you modify 5 files and your test suite is 30secs long, woul will already have to wait 2 and a half minutes %}
{% endfootnotes %}
