---
layout: post
title: "How to make your JavaScript apps SEO-friendly"
date: 2014-01-17 14:15
comments: true
categories: [SEO, JavaScript, AngularJS, Prerender]
---

One of the challenges in moving your application logic
from the backend (Rails, Django or whatsoever) to the
new frontier of JS web frameworks like AngularJS and
EmberJS is how you can make them SEO-friendly, as these
JavaScript applications get sent to the browser by your
webserver as a `200 OK`, no matter if, once the app boots,
the page that its being represented is not found, or has
some specific metatags, like title and description.

<!-- more -->

This is, for example, how a tipical angular app's `HEAD`
section of the HTML looks like:

{% raw %}
``` html
<head>
    <meta charset="utf-8">
    <title>
    	{{ pageTitle }}
    </title>
    <meta name="keywords" content="{{ metaKeywords }}">
    <meta name="description" content="{{ metaDescription }}">
    <link type="image/x-icon" data-ng-href="https://example.org/favicon.ico" rel="shortcut icon">
    <link rel="stylesheet" href="https://example.org/screen.css">
</head>
``` 
{% endraw %}

As you see, the page title, which is what SE like Google use
as main text in your indexed pages, is a mere placeholder for
a variable that come after the JS framework has booted and
executed its own logic, eventually leading to SERP results
like this:

{% img center /images/google-result-placeholders.png %}

So, how will you make sure that search engines will actually
see the post-processed HTML and not the very first one that
gets sent from your server?

You have at least a couple different solutions that use the
same underlying tecnique.

## Once feared, Cloaking is your only way

The practice of [cloaking](http://en.wikipedia.org/wiki/Cloaking)
has been penalized by search engines for years but turned out to
be [endorsed by Google](https://developers.google.com/webmasters/ajax-crawling/docs/html-snapshot)
when you have JS-based apps.

It basically consist in serving to the search engine a different
version of the webpage, already rendered, instead of the one
that you would serve to a normal visitor, which has to run
the JS framework on the browser.

The workflow is very simple: instead of serving, from the webserver,
your traditional app that you would serve to a normal user, in case
of a bot you simply **forward the request to another application**,
which will request the original page, wait for it to render through
an headless browser like [PhantomJS](http://phantomjs.org/) and then
**serve back the fully rendered content** to the bot:

{% img center /images/prerender-seo.svg %}

This is a very straightforward way to effectively implement SEO in
JS apps, and it can be achieved with a couple tools instead of
having to write the whole thing on your own.

## BromBone

[BromBone](http://www.brombone.com/) is a service that crawls your
sitemap, generates a snapshot of the rendered HTML, stores it on
Amazon (presumably [S3](http://aws.amazon.com/s3/)) and relieves you
from the pain of setting up the middleware SEO app on your own.

It basically acts as the SEO app seen in the picture, but instead of
rendering pages on the fly it does it by looking at your sitemap: once
the bot hits the webserver, you can then proxy it to the BromBone page
so that it gets the actual response from the server.

Even though the service is [very affordable](http://www.brombone.com/#pricing)
relying on the sitemap it's a bit tricky, because, well...what happens
if you have new pages that are not included in the sitemap?

After bumping into this requirement we, at Namshi, decided to opt for
something else.

## Prerender

[Prerender](https://prerender.io/) is both a SaaS and an
[open source library](https://github.com/collectiveip/prerender)
that prerendrs pages on the fly using PhantomJS and some other
nice tricks to [serve the correct status codes and HTTP headers](https://prerender.io/server#http-headers).

The only disadvantage with rendering on the fly is that the bot will
have to wait a bit longer in order to get the response, and this might
result in a penalization from search engines: the solution is very simple,
as you can simply warm up prerender's cache on your own by hitting the URLs
that you want to cache.
In order to refresh the cache, Prerender lets you do `POST` requests, so
that:

* a `GET` request to `http://prerender.example.org/http://example.org/foo.html`
will prerender the page on the fly, so that you can cache for future requests
by real bots
* a `POST` request to `http://prerender.example.org/http://example.org/foo.html`
will refresh the prerendered content

Prerender gives you a bit more freedom compared to Brombone but it requires you
to do some manual work, at least if you want to run it on your own servers
without using their solution as a SaaS; in any case, their pricing modes
is [very affordable](https://prerender.io/pricing) as well.

## What shall I use?

{% pullquote %}
It really depends, as both are very interesting tools: given our confidence
with NodeJS and the will of developing some of the SEO-related stuff in-house,
so that we have a bit more control over these things, we opted to give
Prerender a go, but if you feel the sitemap solution proposed by BromBone
is good enough for you, I'd recommend you that service, as it's easier to
run and requires very less configuration / manual work.

All in all, the good thing is that, in 2014, we can finally say that
{" making SEO-friendly JavaScript apps is not a hassle anymore "}!
{% endpullquote %}