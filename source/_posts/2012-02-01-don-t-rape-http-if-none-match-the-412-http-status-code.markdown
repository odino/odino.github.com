---
layout: post
title: "Don't rape HTTP: If-(None-)Match & the 412 HTTP status code"
date: 2011-03-06 00:08
comments: true
categories: [HTTP, cache]
alias: "/292/don-t-rape-http-if-none-match-the-412-http-status-code"
---

HTTP has a problem: it gets raped everyday.

Seriously, **every single day**.
<!-- more -->

That's because we don't leverage the power of our architectures using the simple tools and mechanisms that HTTP gave us **since the late 80s**.

## A bit about the Etag

The `Etag` header is, generally, a string that represents our resource in the HTTP headers.

It's, banally, a code which identifies our resource, eventually used to check if the resource the client has ( in cache or wherever ) corresponds to the server's one.

Roughly speaking, if I request the resource `Alessandro Nadalin` to a website now and in 2012, the response `Etag` will surely be different, at least because of the age of Alessandro.

## If-Match

`If-Match` it's a **preconditional HTTP header**.

That means that the server should verify a precondition before completing the request's processing mechanism and giving a response.

In this case, when you send an `If-Match` header, usually containing the `Etag` of the resource representation you want to manipulate, the server compares the one you sent with the one of the current resource: if they match, the whole request can be processed.

Consider this request (with a YAML body):

```
PUT /people/alessandro-nadalin HTTP/1.1 
If-Match: yuf8ew98ehf9h9h
Host: italianpeople.com

person:
  name:     Alessandro
  surname: Nadalin
  company: DNSEE
```

If the `Etag` of the resource `/people/alessandro-nadalin` is the same of the server's one, the PUT updates the user.

But if they don't match, the server responds with a `412 Precondition Failed` status code, which means that the resource is out of date.

Like SVN, for God's sake!

## If-None-Match, here comes the cache

`If-None-Match` acts in the reverse way: it's still a preconditional header, but it tells the server to process a whole response only if the `Etag` ( again, contained in the `If-None-Match` header ) is different from the one sent by the client.

Why this?

Because it let's you save bandwidth and CPU: you don't always have to generate a whole response if the `Etag` matches, but how?

Let's see a request similar to the one above:

```
GET /people/alessandro-nadalin HTTP/1.1 
If-None-Match: yuf8ew98ehf9h9h
Host: italianpeople.com
```

If the `Etag` don't match, the server should recalculate the whole response and send it again to the client, but when they match it should only send back a `304 Not Modified` status code.

The `304` status code tells the client to use the resource it has in cache, because it hasn't changed.
