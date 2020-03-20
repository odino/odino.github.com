---
layout: post
title: "The simplest template engine for NodeJS"
date: 2018-03-23 17:59
comments: true
categories: [nodejs, javascript, lodash, template engines]
description: "Let's take advantage of one of lodash's best-kept secrets and use the simplest template engine for Node."
---

This is the story of how I decided to dump [nunjucks](https://mozilla.github.io/nunjucks/) and use the best
templating engine hack in the world.

...with one line of code.

<!-- more -->

## Background

Node does not seem to have a [clear-cut winner](https://github.com/tj/consolidate.js/#supported-template-engines) when it comes to template engines --
for the longest time, I banked on nunjucks but I've been wondering if there's
something *simpler* to take care of templating in small apps.
I'm not really bashing nunjucks here, I'm simply wondering if anything else can
get the job done without too much fuss.

## Mounting the hack

Armed with an [express](https://expressjs.com/), a couple
routes, 2 database queries and more documentation in the README than LoCs, I
started writing the following:

``` js
app.get("/my-view", async (req, res) => {
  res.send(render("my-view", {data: await db.getData()}))
})

function render(view, ctx = {}) {
  return fs.readFileSync(`./views/${view}.html`) // WTF do I do with ctx?
}
```

That's amazing, I just called a file reader a "template engine"!

Knowing that rendering a file from the filesystem doesn't cut it (we need to pass and interpret variables etc etc), I then looked
to find the most straighforward template engine on the planet and realized [lodash](https://lodash.com/docs/4.17.5)
has a built-in [_.template](https://lodash.com/docs/4.17.5#template) method:

``` js
var compiled = _.template('hello ${ user }!');
compiled({ 'user': 'tommy' });
// => 'hello tommy!'
```

Just what I needed -- the syntax is not the jinja one but it mirrors
template strings, so I can't complain too much.

Let's put everything together:

``` js
app.get("/my-view", async (req, res) => {
  res.send(render("my-view", {data: await db.getData()}))
})

function render(view, ctx = {}) {
  return _.template(fs.readFileSync(`./views/${view}.html`))(ctx)
}
```

Sure, we don't call `res.render`, but the difference is very minimal
(`.render(tpl, ctx)` vs `.send(render(tpl, ctx))`).

**Done. No more. That's it.**

## Lessons learned

**I can be a pretty good liar**: I didn't build a template engine, I simply took advantage
of lodash' own minimalist `.template` method.

At the same time, though, I love
the fact that I'm using a library I anyhow require 99% of the times I'm working in node
and I don't need extra dependencies. It definitely can't do everything nunjucks
does, but, when all you need is rendering a couple templates from your application,
this approach works well enough.

And to those who are going to tell me what `fs.readFileSync` is bad I say: *well, it depends*.

Do you need to render hundreds of templates per second? Then sure, `readFileSync`
isn't the most optimized way of doing things. But in a low-traffic, internal app,
this just fits the bill.

Adios!