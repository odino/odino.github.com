---
layout: post
title: "Refresh your JavaScript configurations with freshen-up"
date: 2015-02-20 16:24
comments: true
categories: [nodejs, javascript, open source, oss]
published: true
description: A handy utility to make sure you can refresh configurations in background
---

Today I wrote a simple (silly, I'd say) library
that I had in mind since a while to refresh
configuration values for JS apps.

<!-- more -->

The library is called `freshen-up` and it comes
from some internal discussions we had at [Namshi](http://tech.namshi.com/)
on how to refresh some content we load once a
NodeJS app boots.

I was discussing various approaches with [Lucio](https://ae.linkedin.com/in/unlucio)
and, even if we don't need to employ anything
like this at the moment, I decided to give it a
shot to see how simple it would have been to write down
something that would do that.

Turns out there are a few different approaches to
do this:

* send a [signal](http://en.wikipedia.org/wiki/Unix_signal) to the app
and have it reload the configuration: this will work
nicely but you need someone else to send the signal
to the app, so it might be that when you're bootstrapping
this system you don't want / need too many actors around;
though my overall sense is that this is the most elegant
approach
* have the application listen to a message queue
and publish a message everytime you need to reload
the cache: I feel this is overkill and I am not a big
fan of making the application aware of a system like
RabbitMQ just for this, I feel it kind of breaks
responsibilities / it's a bit "too much"
* have the application reload the cache at a certain
interval: a very simple approach and probably the least
"precise" of the options, but feels legit enough when
you don't want to complicate things

I then decided to give a try to the third approach and
released [freshen-up](https://github.com/odino/node-freshen-up);
it's usage is pretty straightforward:

``` javascript
var freshenUp = require('freshen-up');

function loadConfigurationFromTheDatabase() {
  // ...do stuff...
};

var config = freshenUp(loadConfigurationFromTheDatabase);

config.get().someValue; // will be something

// after some time...

config.get().someValue; // will be something else
```

The library will refresh the configuration, by default,
every 50ms, though you can override this:

```
// Refreshing the configuration every 1s
var config = freshenUp(loadConfigurationFromTheDatabase, 1000);

config.get().someValue; // will be "something"

// after 500ms
config.get().someValue; // will still be "something"

// after 1s
config.get().someValue; // will be "something else"
```

`freshen-up` is basically just a [nice wrapper](https://github.com/odino/node-freshen-up/blob/2f9a3ab2ad2dd5529fff9cd1f3137983746e91ec/index.js#L11-L19) over the
JavaScript's global [setInterval](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers.setInterval)
function, so nothing really fancy here.

By the way, you can also use `freshen-up` to do other
things like running checks every N seconds:

``` javascript
function checkIfInternetIsDown() {
  require('dns').resolve('www.google.com', function(err) {
    if (err) {
      doSomethingDude(err);
    }
  });
};

freshenUp(checkIfInternetIsDown, 1000);
```

That's basically it: I added a couple tests just in case,
though I still think there are better ways to do
[cache invalidation](http://martinfowler.com/bliki/TwoHardThings.html).