---
layout: post
title: "Increase mobile performances by implementing transparent redirects"
date: 2014-03-03 17:58
comments: true
categories: [web, performances, http, mobile]
---

Most of you are aware that one of the biggest problems while
developing mobile apps / websites, is the reduced bandwidth / connectivity
that the user has on his phone compared to traditional devices
connected to a solid WiFi or via cable.

How can you actually improve connectivity to the app? There are tricks to
improve performances, like **transparent redirects**.

<!-- more -->

## An heavy stack

The stack on which your web apps will run will be heavy, by definition:
HTTP wasn't built with performances in mind{% fn_ref 1 %}, and you might
want to add SSL, to provide your users with an additional security layer,
on top of that.

Now imagine your users requesting `GET /my-page` and you serving a redirect: 

```
HTTP/1.1 302 Moved temporarily
Host: example.org
Location: /my-new-page
```

Even though, semantically, this is a logic operation,
it doesnt work well with the demand of great performances, since the user will need to
make nother roundtrip connection to get the new resource

## Transparent redirects

What you can do, instead, is to serve a *transparent redirect* to the user, so that there is
no additional request to be made:

```
HTTP/1.1 200 Ok
Host: example.org
Transparent-Status-Code: 302 Moved temporarily
Transparent-Location-Location: /my-new-page

<html ...
```

In this way the client already has all the information it needs in
order to show the user the data he requested.

Even better: if you are serving contents from an API you can have your main
application handle the transparent redirect with the `history.pushState(...)`
API of `HTML5`.

## Current implemetation

At the moment you will have to be cautious with it, as current browsers (or, at least,
a few of them) treat non `2XX` status codes as errors, thing that becomes tricky when you
handle things with JS callbacks / promises:

```
http.get(..., onSuccess, onError)

// the browser will call onError if the response status code is
// different than 2XX
```

I remember banging our heads over our desks here at the [Namshi](https://www.namshi.com)
office, so we decided to use a very simple approach, using **custom headers** with a `200 Ok`:
if the response ends up in a redirect, we use 2 custom headers (`N-Status-Code` and `N-Location`),
intercept the response in our frontends and do our trick with `#pushState(...)`.

## Future considerations

It would be nice if, one day, the HTTP spec would be able to incorporate this
behavior natively, with a status code like `308 Transparent redirect`, so that browser will be able to
automatically update the state of the apps and the user wouldn't need to wait for another roundtrip
connection to see the data they have been requesting, no matter the location.

{% footnotes %}
	{% fn We're talking about  raw performances, scalability is another matter, which is implemented almost flawlessy in the protocol %}
{% endfootnotes %}