---
layout: post
title: "Web performances: 10 tips for the beginner"
date: 2014-03-04 06:37
comments: true
categories: [web, performances, speed, optimization]
published: false
---

I will start today a new series of articles - hopefully
once a month - that give the reader some practical tips
based on his level of expertise.

In this first series, about web performances, I am going
to show you how beginners should deal with optimizations
in order to speed up their web apps.

<!-- more -->

## #1 Use a (popular) CDN

## #2 Minify assets

## #3 Combine assets

Another golden rule is to combine assets altogether, so that
the browser, while parsing the page, doesn't have to make a lot
of additional requests but just needs to download 1 CSS and one
JS file (usually).

From this:

```
<head>
	<meta charset="utf-8">
	<link href="/stylesheets/main.css" rel="stylesheet">
	<link href="/stylesheets/post.css" rel="stylesheet">
	<link href="/stylesheets/something-else.css" rel="stylesheet">
```

you should be able to end up with this:

```
<head>
	<meta charset="utf-8">
	<link href="/stylesheets/combined.css" rel="stylesheet">
```

When the browser parses the first snippet, it will have to make 3 HTTP
requests to download all the CSS files needed to render the page while, in
the second case, it just needs one roundtrip connection to get all the style
it needs to render the page: in situation where connections end up with
high latency (ie. think of mobile users) this is a **must-have**.

## #4 Use Google PageSpeed Insights

## #5 CSS selectors

## #6 You might not need jQuery

## #7 Embrace partial updates

## #8 Preload

## #9 Enhance progressively

## #10 You should not have too many problems