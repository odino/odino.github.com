---
layout: post
title: "A CRUD with Symfony2 and Doctrine 2"
date: 2011-02-03 12:00
comments: true
categories: [Symfony2, Doctrine, PHP]
alias: "/279/a-crud-with-symfony2-and-doctrine-2"
---

A few weeks ago I've made an experiment with Symfony2 and Doctrine 2,
creating a simple, dummy and no-purpose blog CRUD, the [BlogBundle](https://github.com/odino/BlogBundle).
<!-- more -->

As far as you want get in touch with some Sf2 syntax or concepts you
should keep an eye on it ( it's a matter of a few minutes ): some API
**have changed or will change**, but the most I've written should be able to
explain how to do the basic stuff.

Just to redirect you to the proper resources, I would suggest you to look at:

* the [Controller](https://github.com/odino/BlogBundle/blob/master/Controller/PostController.php)
* the [Post](https://github.com/odino/BlogBundle/blob/master/Entity/Post.php) entity, mapped with Doctrine 2
* the [form](https://github.com/odino/BlogBundle/blob/master/Form/Post.php)
* the [routing](https://github.com/odino/BlogBundle/blob/master/Resources/config/routing.yml), that's definitely
[gonna change](https://groups.google.com/forum/#!topic/symfony-devs/XwmSUmPp2G4) in a few weeks ( I'm looking at you, ':' url parameters! )
* some [views](https://github.com/odino/BlogBundle/tree/master/Resources/views/Default)
( although I didn't used twig, my fault )

Hope this will help somebody, it's mostly for the sake of ease learning some
initial concepts.
