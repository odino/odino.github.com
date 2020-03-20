---
layout: post
title: "Promises 101 - A practical example"
date: 2015-07-17 13:38
comments: true
categories: [promises, design patterns, javascript]
published: false
---

If you've been into JavaScript over the past few years,
you've definitely heard of [promises](https://en.wikipedia.org/wiki/Futures_and_promises),
a great way of taming the [callback hell](http://callbackhell.com/)
and live a better life against the async.

<!-- more -->

As crazy as it sounds, primarily-sync [languages like
PHP now have implementations of promises as well](https://github.com/reactphp/promise)
since it seems like this new kid on the block (which
actually is [as old as I am](https://en.wikipedia.org/wiki/Futures_and_promises#History))
solves the problem quite well; from code that looks like
this:

``` javascript
doSomething(a, b, function(){
  // ...
  // ...
  doSomethingElse(b, c, function(){
    // ...
    // ...
    andSomethingSimilar(c, d, function(){
      // ...
      // ...
      lastButNotLeast(d);
    });
  })
});
```

you would produce this kind of beauty:

``` javascript
doSomething(a, b)
  .then(doSomethingElse)
  .then(andSomethingSimilar)
  .then(lastButNotLeast)
```

Getting a grasp of how to use promises isn't kind of a big deal,
but today I'd like to write a fairly simple implementation of a
promise library to get a better understanding of how they work
under the hood.

## Notable implementations

...

## A note on performances

Same as facade,