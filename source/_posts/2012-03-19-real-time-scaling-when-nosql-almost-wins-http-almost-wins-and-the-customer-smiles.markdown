---
layout: post
title: "Real-time scaling: when NoSQL almost wins, HTTP almost wins, and the customer smiles"
date: 2011-05-06 15:42
comments: true
categories: [esi, nosql, scaling]
alias: "/319/real-time-scaling-when-nosql-almost-wins-http-almost-wins-and-the-customer-smiles"
---

There's a common goal that NoSQL and ESI share together: consistency.

Since [the web is inconsistent](http://www.slideshare.net/odino/http-cache-pug-rome-03292011/2), we should be able to find some hacks to make it more consistent and satisfy both us, reducing bandwidth, traffic and CPU load, and the end-user, decreasing the latency of our services.
<!-- more -->

## Edge Side Includes

ESI is a specification written 10 years ago in order to let the reverse proxies being able to include *{insert media type here}* fragments in HTTP responses.

It's so useful because it let's you take advantage of HTTP's native caching specification without recurring to application caches for really dynamic pages.

An ESI tag is pretty straightforward:

``` xml
<html>
  <head>...</head>
  <body>
    ...
      <esi:include src="/footer.html" />
    ...
  </body>
</html>
```

So, as you see, caching directives for webpages' fragments are now a matter of the protocol ( HTTP, in most cases ) and not of the application ( Symfony, DotNetNuke, Joomla, WordPress, Drupal, Django, Django REST framework, Ruby, Sinatra, ... ).

This is so awesome because:

* it lets you scale when really dynamic data needs to be sent over the network
* you don't have to re-invent the wheel with your application's caching layer
* caching directives are a matter of the protocol, thus, if you'll change your application, caching configuration won't change

## NoSQL

The NoSQL movement is really old, but has been highlighted in the last 2/3 years.

At the italian NoSQLday I listened a talk about Redis and another one about SQL antipatterns which helped me contextualizing this DBMS: a few of them are out there in order to help you increase your performances without recurring to a caching mechanism, having the possibility to **really** show really real-time data.

Most of them are so fast, damn.

## A common goal

Since, as we see, a few players are pointing towards a more consistent web, we should assume that this is the way to drive tecnology through: organizations like Facebook have to need to scale to milions of users mantaining the appearance of a real-time service, and the more they reach their goals, the more our customers pretend to act like them.

In order to "*real-time scale*" you can use a technology born a decade ago or another one which is on everyone's lips since a couple years.

The choice is yours: tools are always tools, but the architecture's design is something we, only we, can manage.