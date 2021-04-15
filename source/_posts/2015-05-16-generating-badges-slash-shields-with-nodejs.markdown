---
layout: post
title: "Generating badges / shields with NodeJS"
date: 2015-05-16 19:05
comments: true
categories: [nodejs, shields.io, svg]
description: How can you generate badges (like the 'build status' ones) through Node? Let's find out!
---

In the last post, I wrote a simple example
to be able to generate SVGs through [RaphaelJS](http://raphaeljs.com/)
on the server.

{% img right https://img.shields.io/travis/joyent/node.svg %}
{% img right https://img.shields.io/github/downloads/atom/atom/latest/total.svg %}

Now I would like to showcase how to accomplish
a similar task - generating [badges](http://shields.io/) - again with
a simple NodeJS server.

<!-- more -->

## The approach

Shields are made of 3 main parts, a text on the **left**,
a text on the **right** and the background **color** of the
latter.

That said, it's pretty clear we will want to receive those
parameters in the HTTP request to the server and generate
an SVG accordingly: we will simply use a base template
and generate the image on the fly.

For the templating part we will use [swig](http://paularmstrong.github.io/swig/),
and to simplify the process of extracting request
parameters we will simply rely on the evergreen express.

## Show me the code!

First, let's create a package json so that we can
`npm install`  the required dependencies:

```
{
  "name": "nodejs-badges",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "MIT",
  "dependencies": {
    "express": "^4.12.3",
    "swig": "^1.4.2"
  }
}
```

Now, down to the "real" code : let's start by simply creating a
brand new express app that receives requests at
`/badge/:left/:right/:color` and renders an SVG
template:

``` javascript
var express = require('express')
var app = express()
var swig = require('swig')
var path = require('path')

app.get('/badge/:left/:right/:color', function (req, res) {
  var badge = swig.renderFile(path.join(__dirname, 'badge.svg'), req.params);

  res.writeHead(200, {"Content-Type": "image/svg+xml"})
  res.write(badge);
  res.end();
});

var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Badge generator listening at http://%s:%s', host, port);
});
```

At this point, we will need to create the SVG template,
and we will take inspiration from [shields.io's one](https://raw.githubusercontent.com/badges/shields/ecde9bb3d09cd8600882448275459b0de6e7e247/templates/plastic-template.svg),
which is quite battle-tested:

``` html
{% raw %}
{% set leftWidth = left.length * 10 %}
{% set rightWidth = right.length * 12.5 %}
{% set totalWidth = leftWidth + rightWidth - 10 %}
{% endraw %}
<svg xmlns="http://www.w3.org/2000/svg" width="{% raw %}{{ totalWidth }}{% endraw %}" height="18">
  <linearGradient id="smooth" x2="0" y2="100%">
    <stop offset="0"  stop-color="#fff" stop-opacity=".7"/>
    <stop offset=".1" stop-color="#aaa" stop-opacity=".1"/>
    <stop offset=".9" stop-color="#000" stop-opacity=".3"/>
    <stop offset="1"  stop-color="#000" stop-opacity=".5"/>
  </linearGradient>

  <mask id="round">
    <rect width="{% raw %}{{ totalWidth }}{% endraw %}" height="18" rx="4" fill="#fff"/>
  </mask>

  <g mask="url(#round)">
    <rect width="{% raw %}{{ leftWidth }}{% endraw %}" height="18" fill="#555"/>
    <rect x="{% raw %}{{ leftWidth }}{% endraw %}" width="{% raw %}{{ rightWidth }}{% endraw %}" height="18" fill="{% raw %}{{ color }}{% endraw %}"/>
    <rect width="{% raw %}{{ totalWidth }}{% endraw %}" height="18" fill="url(#smooth)"/>
  </g>

  <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="12">
    <text x="{% raw %}{{ leftWidth /2+1 }}{% endraw %}" y="14" fill="#010101" fill-opacity=".3">{% raw %}{{ left }}{% endraw %}</text>
    <text x="{% raw %}{{ leftWidth /2+1 }}{% endraw %}" y="13">{% raw %}{{ left }}{% endraw %}</text>
    <text x="{% raw %}{{ leftWidth + rightWidth /2.5-1 }}{% endraw %}" y="14" fill="#010101" fill-opacity=".3">{% raw %}{{ right }}{% endraw %}</text>
    <text x="{% raw %}{{ leftWidth + rightWidth /2.5-1 }}{% endraw %}" y="13">{% raw %}{{ right }}{% endraw %}</text>
  </g>
</svg>
```

At this point we're set; we can just run `node index.js` and
hit `localhost:3000/my%20 badge/is%20great/green` to see
the generated badge appear:

{% img center /images/generated-badge.png %}

## MOAR!

Keeping in mind that you have to URLescape special characters,
you can now play around with many different combinations:

* `http://localhost:3000/badge/code/bad/red` is a very simple badge
* `http://localhost:3000/badge/code/bad/%23cc0033` shows that you
can also specify colors in the traditional [hex notation](http://en.wikipedia.org/wiki/Hexadecimal)

and so on and so fort: you can definitely feel free to
customize the code to add some more variables, tweak the
template and make small adjustments.

All in all, now I guess you see how [these shields](http://shields.io/)
are generated :)

## For the lazy ones...

Since I wanted to have a working example that people could
run, rather than simply copypasting code from this post around,
I created a simple github repo for [nodejs-badges](https://github.com/odino/nodejs-badges)
so that you can play around with more ease.