---
layout: post
title: "On monoliths, service-oriented architectures and microservices"
date: 2015-02-20 19:48
comments: true
categories: [web architectures, soa, microservices, architecture]
published: true
description: In the last few years web architectures have been evolving pretty fast, and the result is that now we have a few approaches to pick between when building your next software architecture
---

In the last few years web architectures have
been evolving pretty fast, and the result is
that now we have a few approaches to pick
between when building your next software
architecture.

<!-- more -->

## Monoliths

{% img right /images/monolith.png %}

Monolithic architectures are the ones
running on a single application layer
that tends to bundle together all the functionalities
needed by the architecture.

At the architectural level, this is the
simplest form of architecture simply
because it doesn't involve
as many actors as other architectural
styles.

If we, for example, want to build a web
architecture with a monolithic approach,
we would start developing the frontend of it and
make it access data directly rather than
giving it an abstraction layer such as an API.

Most setups, nowadays, run through a monolithic
approach as, for small/mid sized architectures,
it runs pretty well and keeps complexity quite
low: the **problems tend to come when the
architecture needs to scale up feature-wise**;
modules are extensively dependent to each other,
the code becomes hard to refactor as
it involves touching the whole monolith (think,
for example, of doing an extensive refactoring on
the `HttpRequest` class, which would impact
every single request to every single functionality
of the architecture).

I personally recommend monoliths for projects with
a **very small and "easy" scope**, where you don't
need too much abstraction and won't likely have
to maintain or evolve the codebase year after
year.

## Semi-monoliths

{% img left /images/semi-monoliths.png %}

These are a bit tricky: I consider semi-monliths
decoupled architecture that actually really on
**smaller, but still large, monoliths**.

This actually means that you think of, for example
for performance reasons, decoupling your frontend
from your backend but end up building 2 (or maybe
even 3) large applications that turn into monoliths
on their own.

I find semi-monoliths **quite harmful** as they are,
in my opinion, **a wrong step in the right direction**:
you believe decoupling works well but do
just a bit of it, ending up with the same problems
you'd have with monoliths, just on a bigger stage.

In complex architectures it's usually much easier
to keep each piece simple but small, whereas semi-monoliths
end up solving just the surface of a problem (ie. performance
bottlenecks) but then leave you with the complexity
of each mini-monolith.

I personally see very few scenarios in which
semi-monoliths are a very good choice: my rule of thumb
is that **if the scope of the architecture is small
you can use a (small) app, else be wild and use
a service for each functionality**, without limiting
yourself to the frontend vs backend thingy.

## SOA

{% img right /images/lego-soa.png %}

SOAs (Service-Oriented Architectures) are a way
to "properly" evolve from semi-monoliths to a more
diversified architecture.

SOAs usually incorporate functions into small/mid-sized
applications (more on this later), **a lot of them**: you try to
keep the complexity of each app / functionality very low
and make them communicate over a set APIs (being them
HTTP APIs, asynchronous messaging and so on);
the services do multiple things all of which are
limited to the scope of a single functionality,
for example customer management.

I like to describe SOAs as{% fn_ref 1 %}:

> A software design based on discrete software components,
> "services", that collectively provide the functionalities
> of the larger software architecture

A clear disadvantage of SOAs is that it might
be overkill: I still remember my first advice
about SOAs at the CakeFest in San Francisco 2
years ago, "[avoid SOA](http://www.slideshare.net/odino/tips-and-tricks-for-your-service-oriented-architecture-cakefest-2013-in-san-francisco/50)".

If you don't need to separate functionalities of
your architecture, simply don't do it: tipically
SOAs are reserved to complex products and systems
that cannot be summed up in a briefing; I clearly
remember, back at the time when I was working in
an agency, that none of our projects was really
suitable for full blown SOAs because the scope was
so limited that there would be no reason to introduce
complexity (at the architectural level).

On the other end, I'd recommend to buy into several services
as soon as you realize that there is too much
complexity in the architecture: you will definitely
understand when this happens because you have clearly
defined boundaries between software components, you
start to realize that one piece of the architecture
shouldn't bring down the rest of it if a deployment
goes wrong and so on. In other terms, **you'll feel it**.

SOAs usually give you a good flexibility but, as said, come
at a cost: even though each piece has its own life,
evolves independently, doesn't impact the others
very much and it's simples, **the architecture itself
becomes more complex**.

One thing to clarify about SOAs is that, nowadays,
the term has lost its appeal due to the fact that
it [might mean too many things](http://martinfowler.com/bliki/ServiceOrientedAmbiguity.html):
SOA is a very general term and it's hard to pinpoint
what it actually represents, though, in recent years,
it seems that we all agreed that a very good way to
do SOA is through microservices.

## Microservices

{% img right /images/ants-microservices.png %}

And here we are with [microservices](http://martinfowler.com/articles/microservices.html).
What do microservice-based architectures actually are?

I could say a lot of things but, to simplify, I will
pick my own definition:

> microservice-based architectures are the ones
> that mimic SOAs with very small, [unix-inspired](http://en.wikipedia.org/wiki/Unix_philosophy) services,
> which do one thing and do it well

What does that actually mean? Shrink those services,
make them as small and indipendent as possible and
create a hell lot of them; the only difference I see
between traditional SOAs and microservices is that
the latter clearly states that the size of a
service should be minimal, else it needs to be split
in multiple services. In other words, **microservices
are an implementation of SOA**.

As we've seen with traditional SOAs, microservices bring
a lot of complexity at the architectural level as there
are even more, tiny actors involved, but the practical
advantage is that they are all isolated, indipendent
and only communicate through simple interfaces (any
kind of API).

This piece sums my thoughts up quite well:

{% blockquote Martin Fowler on microservices http://martinfowler.com/articles/microservices.html %}
[microservices are] one form of SOA,
perhaps service orientation done right
{% endblockquote %}

I am a fan of simplicity and good abstraction, which
means that you should have clear, neat boundaries and
APIs between your services but also should not forget
of avoiding bloating or shrinking them too much, else you end
up overengineering in both cases.

Using microservices also requires quite of a shift in terms
of mindset as there are a lot of things that change
in your development lifecycle: things need to be simple,
well documented, smooth and easy to run; imagine the next
guy coming to your team that, to fix a bug, has to learn
how to run 6 (micro)services together...hell! That is why
you need to figure a solution out to allow fast development
cycles and simplicity to run, deploy and evolve{% fn_ref 2 %} those
small services.

So yes, microservices add complexity at the architectural
level (where you'd likely be happy to have it) with the
advantage of outrageously **simplifying each software
component**, which makes it simple, for anyone, to get used
to the architecture day after day, feature after feature,
service after service.

## So what?

I hope this clarifies some terminology and decisions
you might wanna take when building your next (big or
small) project; there will always be a lot of external
factors, like timeline or resources, to keep in
consideration but I believe it's very important to know
about your options.

Since we are talking about web architectures, I'd like
to leave you with a pearl on [AOL](http://www.aol.com/)
from [highscalabilty](http://highscalability.com/blog/2014/2/17/how-the-aolcom-architecture-evolved-to-99999-availability-8.html):

{% blockquote Dave Hagler, Systems Architect at AOL %}
The architecture for AOL.com is in it’s 5th generation.

It has essentially been rebuilt from scratch 5 times over two decades.

The current architecture was designed
6 years ago. Pieces have been upgraded and new componentshave been added along the way, but the overall design remains largely intact.

The code, tools, development and deployment processes are highly tuned over 6 years of continual improvement, making the AOL.com architecture battle tested and very stable.
{% endblockquote %}

Have fun with your next architecture folks!

{% footnotes %}
  {% fn I'm not sure if this definition is purely mine or if I read it somewhere -- pardon my lack of memory! %}
  {% fn This last point, evolving, is taking care by the architectural style itself. Small, indipendent services are easy to evolve by definition, as they are not complex %}
{% endfootnotes %}