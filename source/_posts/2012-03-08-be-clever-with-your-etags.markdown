---
layout: post
title: "Be clever with your Etags"
date: 2012-03-08 15:21
comments: true
categories: [HTTP]
alias: "/300/be-clever-with-your-etags"
---

I [wrote about Etags](http://www.odino.org/292/don-t-rape-http-if-none-match-the-412-http-status-code) some days ago, stating that:

> The Etag header is, generally, a string that represents our resource in the HTTP headers.

Well, although the definition is pretty simple and good, I should be more clear about etags.
<!-- more -->

Sending etags over the network is a way to reduce bandwidth and load on your service, implementing a part of the HTTP cache specificationl: but you should really **generate clever etags**.

If you need to talk with the DB to generate the tag, you're basically making your server work just a bit lesser than doing everything wthout HTTP cache, because you only save in generating the response.

A cool way to save more would be to save the query used to retrieve the resource:

{% blockquote Subbu Allamaraju http://www.subbu.org/blog/2007/08/http-caching-for-dynamic-data HTTP caching for dynamic data %}
Since this is a key that uniquely identifies the resource, this header could be generated based on the query used to fetch the data and generate the resource.
{% endblockquote %}

But be aware of using **only this strategy**: if you update you resource, that etag will always **send a** `304` **to your consumer**.

That's why the HTTP specification gives us the possibility to mix caching strategies, with validation and expiration.

Mixing them, you'll be able to save bandwith and computational resources giving your consumer more consistent data.

P.S. Yes, the web is inconsistent. **Get over it**.
