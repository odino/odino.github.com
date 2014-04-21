---
layout: post
title: "Use a custom HTTP status code for your apps' healthchecks"
date: 2014-04-21 10:20
comments: true
categories: [HTTP, architecture]
---

To have systems up & running is something, but to
have them healthy it's another story.

<!-- more -->

If you are looking to implement healthchecks in your
architecture beware of being a
bit too simplistic: you might configure, for example,
on of your frontend machines to check the status of the
backend ones every few seconds, so that
[nginx](http://wiki.nginx.org/HttpHealthcheckModule) or
[haproxy](http://haproxy.1wt.eu/download/1.3/doc/haproxy-en.txt)
can remove the backend if they find it unreliable / unhealthy.

Problem is, there might be tricky situations in which the
backend responds with a `200 Ok` even though it's not
working{% fn_ref 1 %}.

There are a lot of ways to avoid this, but the simplest one,
that takes you 2 minutes and works quite well, is to use a
custom HTTP status code for your healthcheck page - we use
`211 Healthy`.

For example, in node, we would do:

``` javascript Serving response with a custom HTTP status code in NodeJS 
res.writeHead(211);
res.write('OK');
res.end();
```

and then we would need to tell our backend that the only status
code that has to be considered healthy is `211`.

No more, no less.

{% footnotes %}
	{% fn For example, the backend's nginx can just respond with nginx's default welcome page, if your host is misconfigured %}
{% endfootnotes %}