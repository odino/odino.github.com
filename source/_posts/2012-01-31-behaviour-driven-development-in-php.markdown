---
layout: post
title: "Behaviour-driven development in PHP"
date: 2011-08-27 23:32
comments: true
categories: [php, bdd, agile]
alias: "/378/behaviour-driven-development-in-php"
---

[BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development) is an established practice which goes beyond test-driven development, assuming we are working on a agile-prone environment and our requirements are expressed as user stories or something similar: although this requirement is not mandatory, **BDD's power is leveraged by using stories**.
<!-- more -->

It basically assumes that instead of focusing on tests, we should start our development process writing down [a story that a parser can translate into a test](http://docs.behat.org/quick_intro.html) (a customer cares about features, not tests) a programmer can implement in order to verify that our software respects that story.

## Why BDD?

It's a pretty unconvenient question :)

Do you know why TDD is extremely powerful? If not, go check it on the web; if so, add to TDD the ability of **writing tests in a ubiquitous language**, letting the team share tests, user-stories and acceptance criteria without the pain of translating an actual story in a functional test that, for example, a customer could never understand.

## Getting started

I was introduced to BDD by [Roberto Bettazzoni](http://www.linkedin.com/pub/roberto-bettazzoni/2/12b/614) at the italian agile day 2010, during a dummy-proof session in which [cucumber](http://cukes.info/) was used.

Although you can use Cucumber in your PHP projects (the implementation of the tests, however, should be written in Ruby), Behat is an excellent project which brings native BDD in PHP.

You can - and I recommend it -  [install it via PEAR](http://pear.behat.org/): just make sure you have all the required dependencies by running a simple

```
behat
```

after the installation: we had our daily WTF last week because [Mink](http://mink.behat.org/), a browser-emulator abstraction layer required by Behat, wasn't properly installed.

## The integration with symfony 1.4

From [our POV](http://www.dnsee.com/), we use Behat in a pilot project written in symfony: you only need to install [sfBehatPlugin](http://www.symfony-project.org/plugins/sfBehatPlugin) and configure the `behat.yml` file you find under `/config`:

``` yml
// behat.yml default config
default:
  paths: 
    features: %%BEHAT_CONFIG_PATH%%/../test/features/frontend
  context: 
    parameters:
      base_url: ~
```

and then you can run

```
behat
```

from the root of your symfony project: no tests, so let's write something!

In symfony, behat's tests are located under `/test/features`, and are a `.feature` file, looking like:

```
Feature: US-1
  As anonymous
  I want to open the homepage
  in order to know WTF this site is about

Scenario: anonymous user reaches the site's homepage, viewing it without errors
   Given I am on "homepage"
    Then I should see "This website is about crap" in the "body" element
     And The page loads correctly 
```

So, let's examine it:

* this "code" should be located in the `/test/features/homepageOk.feature` file
* the `Feature` element defines the story you are working on (write it as it appears in your backlog)
* every `Scenario` block identifies possible declinations for your story (user logs in with good credentials, user tries to log in with incorrect credentials and so on)
* the sentences inside every scenario are the actual testers which are parsed by behat and **translated in actual PHP code**


## Translated in actual PHP code?

Yes, because you have a `FeatureContext` class in which you define some methods that are your tests' implementations: BDD frameworks usually parse your scenarios' lines generating the code you need to implement.

Behat, for example, stores all its testers in the `FeatureContext` class, and when you write a new scenario, if Behat doesn't know its syntax, it outputs something like:

{% img center /images/behat.png %}

so you only need to *copy&paste* the method in your `FeatureContext` and implement the method with your logic.

Obviously, BDD frameworks have a set of predefined testers: you can see Behat's ones with

```
behat --definitions
```

you will see testers like `I should see [...]` which tests if the given text lies in the response.

## Producing ubiquitous documentation

The cool thing is that, when you run your BDD test suite, you can export it in a fancy way, making it readable for every project's stakeholder:

```
behat --out heyGuysReadThis.html --format html
```

obtaining something like:

{% img center /images/behat-report.png %}

## I won't be exhaustive, so what's next?

No focus on how to use (*deeply* use) Behat here: it will be a matter of another post.

Then we will see how to use [capifony](http://capifony.org/) to automatically deploy your symfony applications and produce acceptance criteria tests that will be used by your QA guys in order to test your brand new deployment.