---
layout: post
title: "When debugging doesn't suck: beautiful errors"
date: 2017-03-16 14:57
comments: true
categories: [debugging, errors, exception, logging]
description: "Debugging and analyzing logs can be a painful activity, especially if we don't raise the right kind of exceptions."
published: false
---

{% img right /images/stacktrace-java.png %}

Exceptions happen everyday: the bigger (and the more distributed) the system, the
higher the chances for things to go south.

Most of us already learned the lesson when we idealized architectures and they
bit us back in the form of a catastrophic downtime that could have been avoided,
maybe by just [adding a required timeout](/better-performance-the-case-for-timeouts/)
or keeping a few [best practices for distributed systems](/book-review-release-it-design-and-deploy-production-ready-software/)
in mind: we are now better architects, who understand that **failures are an option**
and we have to build resilient systems that embrace them and work towards mitigating
their impact.

There is one thing, though, that most of us (including me) still suck at: **throwing
beautiful errors**.

We have great infrastructures in place to log information and monitor our systems
where, in theory, everything is taken care of; then the day comes when disaster, in the form
of a nasty bug, strikes and we're left, clueless, trying to understand what's
going on with our software.

How many times, after fixing a bug, you find yourself saying
"*let's add some more logs though*"? If you've been as frustrated as I've been,
I'd recommend you to read on.

<!-- more -->

## Logging should be transparent to the app

`stdout`/`stderr` work alright most of the time, that's where your app should
log to in 99% of the cases: logging is generally part of the infrastructure,
not the single app, so there's virtually no reason to make the app aware of a
specific logging transport.

Most logging libraries support `std***` out of the box, so that you can, at a higher
level, collect those logs in a single place, without having to change 100 apps when
you decide to switch to a new log collector (ie. SumoLogic, ELK, Graylog).

Make the app unaware of who's receiving the logs, it's the best way to centralize
logging and make sure you're not trapped with one solution unless you change each
and every app in your architecture.

## Not too much, not too less

Nobody likes to ingest (and pay for) gigabytes of useless logs, especially when
you're trying to debug and all that pops in your monitoring console is:

```
Mar 17 17:53:35 app Received request for order #123
Mar 17 17:53:35 app Opening mysql connection
Mar 17 17:53:35 app Order #123 cannot be placed
Mar 17 17:53:35 app There was some problem with order #123
Mar 17 17:53:35 app Closing mysql connection (timeout)
Mar 17 17:53:35 app Error saving order #123: Connection timed out at mysql.go on line 111
Mar 17 17:53:35 app Unable to place order #123, responding to client with error code
Mar 17 17:53:35 app Sent code 500 to client for order #123
```

So, out of 6 messages we only care about 1 or 2 of them, the actual error
(`connection timed out`) and maybe the incoming request message (first one above):
most of those messages will not really add anything but clutter, and you're left
looking at logs that you eventually have to **filter out**.

A better strategy would probably be to log the error and provide some additional
info, in case the reader wants to understand a bit more about the error:

```
Mar 17 17:53:35 app Error saving order #123: Connection timed out at mysql.go on line 111 {
  timeout: 10000,
  httpStatus: 500,
  orderParams: ...
}
```

This should help keeping logs as informative as possible, but it exposes you to
a nasty problem, as you're only logging in case an error occurs. Supposing that
your app is an HTTP server, I'd strongly recommend to the request (very high-level,
no need for a lot of details) so that you know that the app is being hit:

```
Mar 17 17:53:35 app POST /orders
Mar 17 17:53:35 app Error saving order #123: Connection timed out at mysql.go on line 111 {
  timeout: 10000,
  httpStatus: 500,
  orderParams: ...
}
```

else, when a bunch of requests ends up throwing a `500` error and you don't see
logs in the console, you won't be able to tell if the problem is with the load
balancer in front of the app that's rejecting some requests or what. Add *cheap*
logs at an high level so that you don't have to make lots of assumption when
things go wrong, so that when you see this in the logs:

```
Mar 17 17:53:35 Server starting on port 8080...





```

you know the app is probably not receiving traffic at all.

## Cluster by identifiers

{% img right /images/aws-xray.png %}

It's a good idea to be able to tag logs so that you can cluster them later on,
especially if you have a multi-layered architecture: Amazon, for example, launched
[X-Ray](https://aws.amazon.com/xray/) to help in these exact scenarios.

Assign a request ID to each and every request coming to your load balancers, and
forward that ID to the inner levels of your architecture: this will help you
giving more context to errors.

For example, you might end up seeing that requests
that came through the load balancer and hit service A with a particular query string
parameter didn't eventually land on service B, thus you can now focus on
understanding why service A is holding on all of the requests with that specific
parameter.

## What went wrong?

* exp/desiderata

## How do I fix this?

* what to do

## Provide useful info

* context

## Don't log everything

## Collect crashes

## Conclusion

I've done quite some damage in the past, so this is more of a collection of
friendly advices from someone who banged his head against the wall several
times.

If you're curious about the infrastructure we use to handle monitoring and logging
at Namshi let me just give you a brief overview:

* most of our apps are running in containers and log to `stdout`
*

If you'd like to read more about logging, I'd recommend [this article](http://www.masterzen.fr/2013/01/13/the-10-commandments-of-logging/)
that helped me shape this post.
