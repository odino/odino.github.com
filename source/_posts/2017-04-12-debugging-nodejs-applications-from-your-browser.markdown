---
layout: post
title: "Debugging NodeJS applications from your browser"
date: 2017-04-12 17:31
comments: true
categories: [devtools, debugging, javascript, nodejs]
description: "The best debugger for NodeJS? The Chrome DevTools!"
---

{% img right /images/chrome-node-debug.png %}

If you've worked with Node long enough, chances are you probably grew fed up with the lack
of *plug-and-play* benchmarking and profiling tools in its ecosystem: well, at
least for debugging, say no more!

One of the most overlooked features that landed in Node over
the past year is [enhanced debuggability](https://github.com/nodejs/node/pull/6792)
which, coupled with Chrome's DevTools, makes it extremely easy
to debug and profile server-side JavaScript: it comes with full support of the
*usual suspects* such as **breakpoints** and **CPU profiles**, and it's
extremely easy to setup -- no external dependency, no overhead, just Chrome.

<!-- more -->

The trick is very simple, as you just need to launch your node scrips with the
`--inspect` flag!

Say you have an HTTP server up & running on port 8080:

``` js index.js
require('http').createServer((req, res) => {
    console.log('Hello')
    res.write('Oh my ')
    res.end('gosh!')
}).listen(8080)
```

you simply need to start it with `node --inspect index.js` and head to the URL
pointed out by the command line, something like:

``` bash
/tmp ᐅ node --inspect index.js
Debugger listening on port 9229.
Warning: This is an experimental feature and could change at any time.
To start debugging, open the following URL in Chrome:
    chrome-devtools://devtools/bundled/inspector.html?experiments=true&v8only=true&ws=127.0.0.1:9229/737e256b-8640-4331-a145-27a119ba43c8
```

Needless to say, if you want to pick a specific port, you just need to tweak
the *inspect* option with something like `--inspect=4000`{% fn_ref 1 %}.

See you next time!

{% footnotes %}
  {% fn At Namshi, most of us develop on remote machines (EC2 in Mumbai) and we only expose a handful of ports from those machines, so we run our debuggers on more "common" ports such as 8090 %}
{% endfootnotes %}