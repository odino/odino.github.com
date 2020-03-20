---
layout: post
title: "NoSQL day: from enthusiasm to consciousness"
date: 2011-03-26 15:11
comments: true
categories: [nosql]
alias: "/313/nosql-day-from-enthusiasm-to-consciousness"
---
<!-- more -->
{% img center /images/nosqldaylogo.jpg %}

The [NoSQL day](http://www.nosqlday.it/) has been an amazing 1-day/1-track conference held in Brescia, Italy, yesterday.

I went there because in [DNSEE](http://www.dnsee.com/) we are facing huge problems with the design of a software in which we thought MySQL would fit without many matters: so, given that non-relational databases are getting very popular, me and [David](http://www.davidfunaro.com/) decided we should attend this event.

##What we had, have, will have and how we use them

The event starts with the keynote of Gabriele Lana, which briefly explains the history of the DB as we know it.

Luca Bonmasser continues explaining (No)SQL antipatterns: the session was great, because it highlighted tons of use-cases which we solve with the relational model but don't need it; we basically add to a complex and heavy-constrained system data that should not belong to that domain, like messaging queues or configuration parameters.

Then it comes The Net Planet ( a firm represented by [Flavio Percoco](http://www.linkedin.com/pub/flavio-percoco-premoli/b/61/457) and Alberto Paro ), which introduces MongoDB to the crowd, coupled with [ElasticSearch](http://www.elasticsearch.org/), a system built to solve research issues.

I didn't enjoyed it so much because they didn't dig into Mongo but mainly explained the common infrastructure they use on their products/systems.

## Technologic contextualization

[Antirez](http://twitter.com/#!/antirez), creator of [Redis](http://redis.io/), had an amazing talk about his product and the NoSQL panorama: he was really capable to enjoy the crowd and contextualize NoSQL solutions' use cases.

I really appreciated that he specified the limitations of Redis and other non-relational databases: as far as Redis is concerned, he told us that the cases where it fits really well are **caching**, **messaging queues** and **fast computations** ( like intersections between datasets ).

We also had the opportunity to talk with him at lunch: a very cool personality :)

{% img right /images/nosqlday-antirez.jpg %}

Just after lunch, Gabriele Lana had his 2nd talk, soooo technical, about his 2-years long experience with MongoDB, explaining to the attendees a few tricks and howtos when dealing with this product.

It was a pity that we were in heavy digestion... ;-)

## OrientDB

{% img left /images/nosqlday-garulli.jpg %}

[Luca Garulli](http://zion-city.blogspot.com/) introduced to the conference [OrientDB](http://www.orientechnologies.com/), a **fast and scalable graphdb** for the masses, written in Java with 2 interfaces, binary and HTTP.

Although I knew Orient ( and I will [know it better](https://github.com/odino/Orient) ), it was great to listen the creator of this cool product explaining all the features that would probably solve a lot of the problems I mentioned at the beginning of this post.

## What did the NoSQL day gave us?

The consciousness about this technology: buzzwords are often abused, and time after time every technology is marked as **definitive**, because the **one size fits all rule** hasn't penetrated in software engineering yet.

So this kind of events are the glue between a technology and its proper usage, because they introduce you to a new world as well as they boost your productivity.

## Next big thing

We will have our first **Node.js conference in Italy** in september and I can't wait for it: so... Thanks and kudos to [WebDeBs](http://www.webdebs.org/), the organizers of the "for real" conferences!