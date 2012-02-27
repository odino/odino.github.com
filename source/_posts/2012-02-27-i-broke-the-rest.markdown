---
layout: post
title: "I broke the REST"
date: 2011-03-6 11:09
comments: true
categories: [REST]
---

I've made a few mistakes with this plugin, called [sfRestWebServicePlugin](http://www.symfony-project.org/plugins/sfRestWebServicePlugin).
<!-- more -->

## Time to regret

Cool thing, I've been cited as its author in the Symfony Live conference in Paris and, before seeing some people ranting here, I just want to make clear one concept: its aim is not to be your way to write a RESTful webservice.

Also, at the time I wrote it, I made a few mistakes in the implementations, which desn't make it really a software respecting the RESTful constraints.

## I've been young

What I hate about it?

* it does authorization, not authentication
* I use the word state instead of method, pretty nosense
* it isn't designed to facilitate your job with the hypermedia constraint (HATEOAS)
* it uses a general feedback when an error occurs

These are just a few points.

Since I don't want to evolve it, nor fix it, pretend to use it understanding this kind of limitations.

## HATEOAS can't be generalized

Since the hypermedia constraint of REST is a domain-specific-workflow dependant concept, just forget about any magic plugin that tells it can generate a RESTful version of your service: it just can't be.

Any kind of plugin can help you design a RESTful interface for your service, not build it from scratch to the end.
