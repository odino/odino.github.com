---
layout: post
title: "Concise async / await in ExpressJS"
date: 2017-10-04 17:36
comments: true
categories: [javascript, expressjs, async, await, oss, open source]
description: "How can you use async / await in express? express-async-await to the rescue!"
---

[Async / await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function) is one of the biggest revolutions (*read: one of the sweetest
syntactical sugars*) that has come to JavaScript over the past few months,
and has personally helped me appreciate the language a lot more.

At [work](http://tech.namshi.io), we rely quite a lot on [ExpressJS](https://expressjs.com/) to build small services deployed in our
architecture and, as you can imagine, have converted a whole bunch of them to
async / await over time.

One interesting problem, though, has been converting express routes to use
async functions: my personal solution has been to write [express-async-await](https://github.com/odino/express-async-await),
and I want to share the reasons and ideas behind the library in this post.

<!-- more -->

## A typical express scenario

Before we understand the problem, I want to clarify the scenario we're looking
at -- a simple app with a few routes and an error handler to *catch'em all*:

``` js
app.get('/users', function(req, res, next){
  db.getUsers().then(function(users) => {
    res.json(users)
  }).catch(next)
})

app.get('/users/:id', function(req, res, next){
  db.getUser(req.params.id).then(function(users) => {
    res.json(users)
  }).catch(next)
})

app.use(function(err, req, res, next) {
  console.error(err)
  res.status(500).json({message: 'an error occurred'})
})
```

As you see, we simply have a couple routes which use some promise-based service
(we could even use callbacks, I'm using promises here just for the sake...)
and an error handler that intercepts any error and returns a "standard" response
should anything fail in the routes.

Can we do better?

## The problem with async functions

Lauded for its simplicity and readability, async / await can help us make the
code a bit more elegant:

``` js
app.get('/users', async function(req, res, next){
  try {
    res.json(await db.getUsers())
  } catch(err) {
    next(err)
  }
})

app.get('/users/:id', async function(req, res, next){
  try {
    res.json(await db.getUser(req.params.id))
  } catch(err) {
    next(err)
  }
})

app.use(function(err, req, res, next) {
  console.error(err)
  res.status(500).json({message: 'an error occurred'})
})
```

Now, you probably see where I'm headed: each and every route we add needs to have
some boilerplate to catch errors and forward them to the error handler, and that's
where my OCD kicked in -- there needs to be a better way of doing this.

## Solution 1: the wrapper

Turns out that the solution is quite simple, you can just create a wrapper that catches
the error and calls `next`:

``` js
const asyncMiddleware = fn =>
  (req, res, next) => {
    Promise.resolve(fn(req, res, next))
      .catch(next);
  };

app.get('/users', asyncMiddleware(async function(req, res, next){
  res.json(await db.getUsers())
}))

app.get('/users/:id', asyncMiddleware(async function(req, res, next){
  res.json(await db.getUser(req.params.id))
}))

app.use(function(err, req, res, next) {
  console.error(err)
  res.status(500).json({message: 'an error occurred'})
})
```

Much better, right? Well, at least I think so: now our routes are one-liners that
defer to a service and error handling is out of the picture, as it's taken care by
the `asyncMiddleware` function (here's a [good article on the topic](https://medium.com/@Abazhenov/using-async-await-in-express-with-node-8-b8af872c0016)).

The biggest drawback, in my opinion, is that the routes are now looking less
"pure" than they should: they're all wrapped in this `asyncMiddleware` which looks
kind of awkward. What if we were able to "hide" this implementation detail from
our code?

## Solution 2: express-async-await

That's where [express-async-await](https://github.com/odino/express-async-await)
kicks in: it's a tiny library I wrote to be able to monkey-patch your express app
so that you don't need to wrap each and every route:

``` js
require('express-async-await')(app)

app.get('/users', async function(req, res, next){
  res.json(await db.getUsers())
})

app.get('/users/:id', async function(req, res, next){
  res.json(await db.getUser(req.params.id))
})

app.use(function(err, req, res, next) {
  console.error(err)
  res.status(500).json({message: 'an error occurred'})
})
```

...and that's it! The library takes care of monkey-patching express' [HTTP methods](https://github.com/odino/express-async-await/blob/7e86c2b1ba58e95613c5d38c1b641c8eca6b35d4/index.js#L4) (like `app.get`, `app.post`, etc)
and [automatically wrap them](https://github.com/odino/express-async-await/blob/7e86c2b1ba58e95613c5d38c1b641c8eca6b35d4/index.js#L8-L16) with the `asyncMiddleware` we've seen earlier on.

Biggest drawback? Well, some are really against monkey-patching (for good reasons) but,
when used with caution, I think it can be a really effective way to enhance a library
that's missing an interesting feature{% fn_ref 1 %}.

{% footnotes %}
  {% fn By the way, my bet is that within a year express is going to support this "natively" %}
{% endfootnotes %}
