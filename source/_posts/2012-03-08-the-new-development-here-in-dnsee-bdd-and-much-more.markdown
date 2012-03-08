---
layout: post
title: "The \"new\" development here in DNSEE: BDD and much more"
date: 2011-10-03 12:34
comments: true
categories: [BDD, DNSEE]
alias: "/386/the-new-development-here-in-dnsee-bdd-and-much-more"
---

It's been a couple months that we **renewed a few aspects of our experience**, as developers, here at DNSEE, introducing a few practices that common software factories ignore: we - and I - don't know if these practices will always be fine for our daily job but, as far as we saw, things are just working fine.
<!-- more -->

## Behaviour-driven development

{% img right /images/behat.logo.png %}

We introduced [Behat](http://behat.org/) in a pilot project, in order to ease the process of veryfing features delivered, which is done by our QA guy, [Giovanni](http://www.linkedin.com/in/villagiovanni).

Additionally, BDD lets developers and [product owners](http://www.mountaingoatsoftware.com/scrum/product-owner) speak an **ubiquitous language**, thus the PO can write the test-cases for the development team, in [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin) language:

``` bash Example of a Gherkin story
Feature: Some terse yet descriptive text of what is desired
   In order to realize a named business value
   As an explicit system actor
   I want to gain some beneficial outcome which furthers the goal
 
   Scenario: Some determinable business situation
     Given some precondition
       And some other precondition
      When some action by the actor
       And some other action
       And yet another action
      Then some testable outcome is achieved
       And something else we can check happens too
```

thus you - developer - are not always required to write a test for every feature in the project: this task is done by the PO, **helped by you** ( while experienced PO may not need your help, at all ).

## The scope of the tests

We usually develop projects with the RAD framework [symfony 1.4](http://www.symfony-project.org/), which comes bundled with *Lime*, a ( limited ) **unit and functional testing tool**: we are now testing features wanted by the stakeholders of the projects with Behat, and functionally testing those ones who require pretty **complex DOM checks**.

Unit tests cover almost every class which are dangerous not to test: apart from these classes, we also use **unit tests to test forms**, because a form can behave in different ways based on the input it receives: since you should tests those forms in a functional test, submitting several times the form and veryfing the expected output, functional tests become very slow ( a test-suite is slow, IMHO, when it lasts more than 10 minutes ): thus, we decided to unit test the forms ( in symfony 1.4, they all are objects, so easy to unit test ).

Unit testing forms means faster test-suites, since, in functional ones we only test the *happy path*, which is **submitting good values to the form and veryfing the expected successfull output** ( thanks [Jacopo Romei](http://www.agiledevelopment.it/) for suggesting it ).

{% img left /images/kit.jpg %}

## Capifony

We started using Capistrano through [Capifony](http://capifony.org/), the automatic-deployment utility written for symfony 1.4: at every commit the developer is responsible of generating the proper doctrine migrations and deploy ( deployment usually takes... one bash command ) with

``` bash Simple capifony usage
cap deploy deploy:migrate
```

Since we also wanted to ease the process of updating the issue tracker and BDD reports, we created a script that launches the test-suite ( BDD, functional, unit, integration tests ), deploys with Capifony and publishes the BDD reports on Alfresco, the platform we use for sharing documents: it's a dummy bash script, similar to this one.

## SCRUM

{% img right /images/scrum.jpg %}

It's not hidden, we are trying to use [SCRUM](http://en.wikipedia.org/wiki/Scrum_(development)) as a framework for our processes: I prefer XP, mainly because there's no *CrapMaster* and the whole team is connected ( I repeat it, [whole team](http://epf.eclipse.org/wikis/xp/xp/guidances/concepts/whole_team_7E4B7BE3.html) ) but things seem to work fine.

Our first ScrumMaster, [Andrew](http://it.linkedin.com/in/acceli), tought us the basics of the framework and helped us in becoming a SCRUM team; as he left, [Daniela](http://www.scrumalliance.org/profiles/130822-daniela-cecchinelli) started following the team as *product owner*, giving some hints to [David](http://www.davidfunaro.com/), which is trying to act as the new ScrumMaster, and the rest of the team. 

## Open Source

We are basically dedicating much more time to OS development: [Orient](https://github.com/congow/Orient) is just [one of the libraries sponsored by DNSEE](https://github.com/congow).

In the meantime, we are also continuing the effort of developing our CMF, [ConGoW](https://github.com/congow/congow), but things are going a bit slow and we are keeping it *inter nos* until we will have a usable version of the framework.

The effort of exposing ourselves to the OS world is paying off now: a few customers are coming asking for mainly-technical works, like refactoring an old-style architecture or re-writing their webservices.

If you find this point strange to mention, consider that DNSEE is a [leading agency](http://www.webranking.eu/Articles/Articles/2011/Eni--Best-in-online-communication-2010/) in communication and creativity, thus not born with a technical focus: what else do I need to say? [Alex](http://www.linkedin.com/in/alexlombardi), our CTO, has done a tremendous work.

## Conclusions

I'm pretty sure that lots of guys who read this blog are aware of this tecniques/processes, so this won't be a groundbreaking discovery: my intention is to share how we try to manufacture software in DNSEE and hear, from y'all, some other points of view.
