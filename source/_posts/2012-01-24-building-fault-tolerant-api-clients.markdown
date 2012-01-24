---
published: false
layout: post
title: "Building fault-tolerant API clients"
date: 2012-01-24 12:19
comments: true
categories: [API]
---

{% img right /images/broken.chain.jpg %}

One of the crucial aspects in consuming a webservice is **fault tolerance**, the ability
to [handle application/network/unpredictable errors](http://en.wikipedia.org/wiki/Fault-tolerant_system)
and provide **graceful degradation** to the software's flow.
<!-- more -->

By default, developers tend to like extensive documentation that gets outdated in a moment,
since they think they are protected against integration errors thanks to the fact that **the
parts involved in the integration share the same knowledge about the messaging interface**.

This is a good approach, since we share a common interface and agree on that kind of contract,
but what if we need to change the interface due to an evolution of the domain?

I mean, think at the simplest example ever - an API for some store's products:

``` bash GET /products/12
{
  "name":   "Darth Vader's puppet"
  "price":  "12"
}
```

is it clear that if the seller needs to implement multi-currency payments ( evolution of the
domain ) some clients will break:

``` bash Implementation of multi-currency: a JSON attribute becomes an array
{
  "name":  "Darth Vader's puppet",
  "price":  {
    "EUR":   12,
    "USD":   18
  }
}
```

## Rely on established meanings

## Getting the right representation

## Semantically parsing resources

## Fragmentation

## Changing URLs

{% blockquote Paul Prescod http://www.prescod.net/rest/importance_of_uris.html A World without references %}
[A world without HATEOAS is]
like a database without foreign keys,
like CORBA without object IDs,
like COM without interface pointers.
{% endblockquote %}

## Proxy caching

First of all you need 
