---
layout: post
title: "Using Selenium and Symfony2 to help your frontend developers coding without risks"
date: 2013-03-10 11:39
comments: true
categories: [testing, Behat, webdriver, Symfony2, selenium]
---

Since testing is one of those practices
that many consider *boring* (unless a major
catastrophe happens), you should help people
is easing their job while testing.

Today I am going to show the approach that
we just kickstarted, at Namshi, in order to
help designers and developers testing
frontend changes in a more automated, thus
easier, way.

<!-- more -->

Thanks to the [NamshiVoyeurBundle](https://github.com/namshi/NamshiVoyeurBundle),
it is really easy to start increasing
the efficiency of your testing department,
even if coders do not want to write
automated tests.

The bundle, that you can use **inside a Symfony2
application**, is actually very small and can be
extrapolated to be integrated in other frameworks
(like ZF2 or Cake).

The idea is very simple: you take some screenshots
of a website, deploy a new version, take another set of
screenshots (at the same URLs) and then compare
them, generating an image diff.

After you install the `NamshiVoyeurBundle` (via composer),
it is really easy to start taking screenshots;
you just have to configure a few services
and some parameters:

```yml Configuring the bundle
parameters:      
    namshi_voyeur:
      browsers:
        - firefox
        - safari
        - chrome
      urls:
        homepage:     "/"
        new-arrivals: "new-products"
        women:        "women-shoes"
      shots_dir: "/Users/you/Downloads/screenshots"
      base_url:       "http://en-ae.namshi.com/"

services:
    safari:
        class:  Behat\Mink\Driver\Selenium2Driver
        calls:
          - [start]
        arguments:
          browser: safari
    firefox:
        class:  Behat\Mink\Driver\Selenium2Driver
        calls:
          - [start]
    chrome:
        class:  Behat\Mink\Driver\Selenium2Driver
        calls:
          - [start]
        arguments:
          browser: chrome
```

This configuration basically tells Voyeur that
you will be taking screenshots of three URLs:

* `http://en-ae.namshi.com/`
* `http://en-ae.namshi.com/new-products`
* `http://en-ae.namshi.com/women-shoes`

with safari, firefox and google chrome.

To run the Voyeur, use the `cli`:

```bash
php app/console namshi:voyeur
```

Screenshots will be saved at `/Users/you/Downloads/screenshots`.

At this point, after you deployed a new version of the code,
run the Voyeur again, and you will be reay to generate the
diffs between the screenshots:

```bash
php app/console namshi:voyeur:diff /Users/you/Downloads/screenshots/firefox/2013/03/10/1200 /Users/you/Downloads/screenshots/firefox/2013/03/10/1205
```

Diffs will be generated at `/Users/you/Downloads/screenshots/firefox/2013/03/10/1205/diff`.

That's it: now you can start having a look at what changed and
ask your developers to do the same, even on their local
machine, before committing any changes.