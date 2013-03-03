---
layout: post
title: "Refactoring your architecture understanding SOA"
date: 2013-02-25 22:20
comments: true
categories: [SOA, architecture]
published: false
---

It is no news that I work for [a company](http://en-ae.namshi.com)
supported by [a mothership](http://www.rocket-internet.de)
that helps most of his affiliates with know-how
and basic tools.

But to aim expansion one needs to go beyond those
shared layers and start customizing his
products and services, and in terms of software development
nothing can help you more than
[service-oriented architectures](http://en.wikipedia.org/wiki/Service-oriented_architecture),
or SOA.

<!-- more -->

So, what's the goal of this post? Basically
providing our view on how we are going to
shift from our current architecture, which
is already a composite, to a more powerful
layer of services.

## Identifying the service

One of the first steps in order to dig
into the implementation is to actually identity
a first bunch of functionalities that should be
incorporated as a standalone service.



quali sono i servizi

## Data

Another tipical question is how to manage and organize
data when you have a de-centralized architecture.

In SOA terms, usually data is shared among the
services but this doesnt mean that each service can't
have its own data-layer: it is often seen a very old
fashioned RDBMS shared across all the services and
some of them using a less traditional solution, like
a NoSQL DB; this is mainly done to achieve better
performances and different data patterns

Think about applications that have a model which can be
extensively customized by the end user, that usually
implement the [EAV pattern](http://en.wikipedia.org/wiki/Entity%E2%80%93attribute%E2%80%93value_model),
getting stuck into **performance bottlenecks**, while
a document-db like MongoDB or CouchDB would
perfectly solve the issue.

If you are running, for example, an e-commerce system,
you may want to have transactions and identities in a
solid and robust system like MSSQL, while your
frontend can actually run with MongoDB: once the user
purchases a product, via webservice you store it into
MSSQL.

## Services need

http api

## Services notify

rabbitmq

## So far so good

symfony2