---
layout: post
title: "iMacro: JavaScript loops with variables"
date: 2010-12-01 02:03
comments: true
categories: [JavaScript]
alias: "/256/imacro-javascript-loops-with-variables"
---

[iMacro](https://addons.mozilla.org/en-US/firefox/addon/3863/) is a cool firefox plugin able to record and play macros on the browser.
<!-- more -->

{% img right /images/imacro.png %}

It can be used as a [functional testing](http://c2.com/cgi/wiki?FunctionalTest) tool, like [Selenium](http://seleniumhq.org/) ( although Selenium is really better ), or as a showcase/annoying operation tool.

Today I faced it for the first time with the need to bomb URLs progressively, some bombing kinda like:

GET /news/1
GET /news/2
GET /news/3
for 16K urls¹.

Basically, what I needed was a loop with a variable.

Unfortunately, iMacro doesn't natively support for loops, but has bridges for any kind of language ( VBS, PHP, JavaScript... ) so I only needed to use a JS script ( which can be direcly run on iMacro's web interface):

``` javascript
for (i = 0; i < N; i++)
{
  iimSet('-var_ID', i);
  iimPlay("/home/odino/iMacros/Macros/BombingIsCool.iim");
}
```

the `BombingIsCoolMacro` simply goes to an URL with the imported variable ( ID ):

``` bash
URL GOTO=http://mydomain.com/news/{{id}}
```
