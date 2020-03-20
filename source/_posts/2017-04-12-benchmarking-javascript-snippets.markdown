---
layout: post
title: "Benchmarking JavaScript snippets"
date: 2017-04-12 18:32
comments: true
categories: javascript, performance, benchmark
description: "How do you figure out if a particular snippet is faster than your existing code? Enter matcha."
---

A few days back I was playing around with
[lodash](https://lodash.com/) to figure out if
some of its functions would [add significant overhead](/beware-of-lodash-and-the-cost-of-abstractions/)
as opposed to their vanilla counterparts: in doing
so I discovered [matcha](https://github.com/logicalparadox/matcha),
an amazing tool for benchmarking JS code.

<!-- more -->

Matcha comes with a clear goal in mind: "no waste of time, show me the code", as
it's incredibly easy to setup and start benchmarking.

We first need to create
a benchmark file (say `index.js`) and start adding test suites; a suite simply
describes the *functionality* we want to benchmark, such as
creating a new object, handpicking properties, from a "larger" one:

``` js
let _ = require('lodash')

suite('picking properties from an object', function () {
  // ...
});
```

At this point, we can create a custom object that's going to be used by the
implementations we want to benchmark:

``` js
let _ = require('lodash')

suite('picking properties from an object', function () {
  let obj = {
    name: 'alex',
    age: 28,
    hair: 'enough',
    status: 'married',
    job: 'who really knows',
  }
});
```

and, still inside the suite, start adding our implementations:

``` js
let _ = require('lodash')

suite('picking properties from an object', function () {
  let obj = {
    name: 'alex',
    age: 28,
    hair: 'enough',
    status: 'married',
    job: 'who really knows',
  }

  bench('lodash _.pick', function() {
    return _.pick(obj, ['name', 'age'])
  });

  bench('vanilla', function() {
    return {
      name: obj.name,
      age: obj.age,
    }
  });
});
```

Assuming matcha is installed globally (`npm install -g matcha`) you can then
simply:

``` bash
$ matcha index.js

                      picking properties from an object
         651,233 op/s » lodash _.pick
      80,885,471 op/s » vanilla
```

As you see, matcha starts executing those functions repeatedly, for a few seconds,
and outputs how many executions it was able to do within that timeframe.

The matcha bin will autorun tests as soon as you place under a `./benchmarks`
folder, and you can customize the number of iterations to run the snippets
for:

``` js
suite('picking properties from an object', function () {
  set('iterations', 10000);

  // ...
})
```

Support for async benchmarks is provided with a `next` callback that you'll need to
call once the async operation is over:

``` js
bench('some async thingy with promises', function(next) {
  somePromise(someParams).then(next)
});

bench('some async thingy with goold old callbacks', function(next) {
  someFn(someParams, next)
});
```

Can it get any easier?