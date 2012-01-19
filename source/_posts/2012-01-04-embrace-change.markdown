---
layout: post
title: "Embrace change"
description: "A new engine for my blog: let's get octopressed!"
date: 2012-01-04 14:57
comments: true
categories: 
---
So this is my final attempt to ensure my nerdy passions and my will to blog will
keep up together.
<!-- more -->

Being a nerd, it's fun to spend time on something like *deploying my new article*
or stuff like that: thanks to [Octopress](http://octopress.org/) my technical
sadism has been satisfied and now I can run my own blog on [Github](http://github.com),
thanks to **Github pages**.

I am porting the old most viewed contents here, with some rewrites to ensure old
links will not break: the problem is that Github Pages does not provide any way
to reasonably handle an `.htaccess` file for your site, so the redirects are such
this kind of crap:


``` html 
      <!DOCTYPE html>
      <html>
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8" />
      <meta http-equiv="refresh" content="0;url=/my-new-url/" />
      </head>
      </html>
```

So you, humans, will continue to consume old links while spiders and automated 
bots will never know that the old contents have switched location ( they will get
a `200 OK` status code delivered by Github ).

If someone of you knows how to handle a `301 Moved Permanently` on Github Pages... 
free beer.