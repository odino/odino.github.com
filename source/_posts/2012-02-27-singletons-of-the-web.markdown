---
layout: post
title: "Singletons of the web"
date: 2011-03-21 11:14
comments: true
categories: [REST]
alias: "/307/singletons-of-the-web"
---

A few hours ago I was reading [a post from a member of the CI community](http://philsturgeon.co.uk/blog/2011/03/video-set-up-a-rest-api-with-codeigniter), which was explaining how to set up a REST api ( omitting the most important part, the [hypermedia constraint](http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven\) ).
<!-- more -->

I argued with the author that what he was showing wasn't a RESTful interface, and at the beginning he was surprised by the importance I gave to hypermedia:

{% blockquote %}
I have never seen the point of jamming links into the response, that is what documentation is for.
[...] As for HATEOAS? I don't see the point. I'd be interested to see some examples of it being useful [...]
{% endblockquote %}

that leaded to my response:

{% blockquote %}
To just make an example... without using hypermedia relations you need your client to make assumptions about resource location ( such information can be retrieved on your documentation, for instance ).
When you change the implementation ( for example, URI schemas ), your client is broken: driving application's state by hypermedia means that clients are loosly coupled with your service and consume it without any assumption.
My point was mainly against URI schemas as far as we are intending them nowadays: the resource which the consumer is relating to during the service's consumption.
{% endblockquote %}

Although [URI schemas are generally awesome](http://www.odino.org/304/rest-better-common-pitfalls), because it's easy to start consuming an application implementing a widely-known point of access, they've gained too much power in our interfaces; and like [singletons](http://blogs.msdn.com/b/scottdensmore/archive/2004/05/25/140827.aspx) ( and [statics](http://kore-nordmann.de/blog/0103_static_considered_harmful.html) ), we become slaves of this power.

We don't want coupling inside our code, so why would we like to have **tight coupling inside our architecture**?
