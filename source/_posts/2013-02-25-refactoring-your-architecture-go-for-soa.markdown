---
layout: post
title: "Refactoring your architecture understanding SOA"
date: 2013-03-23 17:35
comments: true
categories: [soa, architecture, rabbitmq, messaging]
published: true
---

It is no news that I work for [a company](http://en-ae.namshi.com)
supported by [a mothership](http://www.rocket-internet.de)
that helps most of his affiliates with know-how
and basic tools.

But to aim expansion, one needs to go beyond those
shared layers and start customizing his
products and services, and in terms of software development
nothing can help you more than
[service-oriented architectures](http://en.wikipedia.org/wiki/Service-oriented_architecture),
or *SOA*.

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
incorporated as standalone services.

Usually, opportunities for new services pop up
when it's time to **introduce a new functionality**
or the cost of fixing / implementation of a 
change request are too high: for example, if you
want to add the ability to send SMSes from your website,
a good service would be one which just deals with
the receiving an input event, assembling a message
and contacting the *real* SMS provider via webservice
in order to dispatch the message; another good example is
**identity**: if you are struggling with different userbases
that need to be in sync, a good solution would be to
centralize identities and provide a service which does,
at least, authentication.

## Data

Another tipical question is how to manage and organize
data when you have a de-centralized architecture.

In SOA terms, usually data is shared among the
services but this doesnt mean that each service can't
have its own data-layer: it is often seen a very old
fashioned RDBMS shared across all the services and
some of them using a less traditional solution, like
a NoSQL DB; this is mainly done to achieve better
performances and different data-retrieval patterns

Think about legacy applications that have a model which can be
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

One typical aspect, in SOA terms, is seeking answers
to our questions (read getting *responses* for our *requests*),
a problem which we can overcame with a simple solution:
when a service **needs** another one, we talk about APIs.

For example, your frontend might offer authentication, while
the Identity manager is a service providing identities to
multiple layers of your architecture: when the frontend needs
to authenticate a user, it will directly rely on the
Identity service, asking him to authenticate the user with the
credentials he or she submitted to the frontend.

APIs can be traditionally categorized into [a few types](http://nordsc.com/ext/classification_of_http_based_apis.html):

* mess: "messy" API don't follow structured rules (it cab be *plain-old XML over HTTP*
or a replication of DB writes and reads in JSON format); they can
be **very useful** when you need to kickstart a new, small and simple
API
* HTTP API: services that semantically expose their domain model
in terms of resources, embracing the HTTP specification
* [REST](/hypermedia-services-beyond-rest-architectures/): hypermedia services
* SOAP: services using strict interfaces between clients and servers,
following the SOAP spec

No matter what, you will always find yourself dealing with APIs
if you decided to go for SOA: it is the simplest way to
provide **data-exchange mechanisms to layers that don't fully
know each other's domain**.

## Services listen

Another **very common** scenario, is when services "listen",
waiting for notifications sent across by other components of
the architecture: you are probably already thinking about
messaging queues and message notifications, and you are right.

A event-driven process can be achieved when we have tools
such as [RabbitMQ](http://www.rabbitmq.com/) helping in gathering
and dispatching notifications to various parts of the architecture:
with Rabbit, a service can dispatch a message to a queue
and another one (or **ones**), through a daemon, consumes the message.

Thinking about what I mentioned earlier, an SMS-dispatching mechanism
could fit in this context really well: think about SMSes that are sent
once the user completes certain actions on your frontend (by gaining credits,
placing an order on your e-commerce or so on); once the user
completes an action, a notification will be sent out and
whoever needs to listen to that message will catch
and process it.

## So far so good

In our fast and new journey towards integrating services into
our architecture, we are finding ourselves pretty well: it is
no news that we are using RabbitMQ and [Symfony2](http://symfony.com)
for our new, isolated services, and that we already identified
a few services that can run on their own, decoupled context.

Thinking in SOA terms, by the way, brings out a new set of problems, like
thinking in terms of architecture, and not of application: you
don't deploy a new version of your application, you **update a part
of the architecture**; your system is decoupled, from the code to the
processes you use to handle them. And what about the complications in the 
development environments? And which monitoring tool should I use to
understand that all the components are working alltogether? And...

There's room for generic problems that everyone faced and that we will
face as well, and I think it will be very interesting to share our
approach and the vision we had in our own context.