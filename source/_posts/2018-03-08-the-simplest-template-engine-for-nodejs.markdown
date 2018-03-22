---
layout: post
title: "The simplest template engine for NodeJS"
date: 2018-03-08 14:35
comments: true
categories: [NodeJS, JavaScript, lodash, template engines]
published: false
description: "Let's take advantage of one of lodash's best-kept secrets and use the simplest template engine for Node."
---

This is the story of how I decided to dump [nunjucks](https://mozilla.github.io/nunjucks/) and build the best
templating engine in the world in just...   ...one line of code.

<!-- more -->

## Background

Node does not seem to have a [clear-cut winner](https://github.com/tj/consolidate.js/#supported-template-engines) when it comes to template engines --
For the longest time, I banked on nunjucks but, lately, I feel that while developing microservices
nunjucks is "*too much*" -- so I began to look for minimalist alternatives.

## Mounting the hack

Armed with an [express](https://expressjs.com/) app that consists of a couple
routes, 2 database queries and more documentation in the README than LoCs, I
started writing this abomination:

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
template strings, so I can't complain much about it.

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

## Lesson learned

Well, this "experience" thaught me a few things -- first and foremost, **I can be
a pretty good liar**: .

Quite a few lessons I learned with this master hack:

* I can be a good liar:
*
* minimal  elegant
