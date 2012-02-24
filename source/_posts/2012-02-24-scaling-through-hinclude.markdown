---
layout: post
title: "Scaling asynchronously through HInclude"
date: 2012-02-24 10:50
comments: true
categories: [scaling, cache]
---

Since it's been a while that I spread the idea of
having [ESI on the client side](/edge-side-includes-how-to-spare-terabytes-every-day/),
someone pointed out that a good solution, technically
different from the one I personally proposed, would
be to use JavaScript to and asynchronous sub-requests.
<!-- more -->

There is a small JS library, written by the good
[Mark Nottingham](http://www.mnot.net/){% fn_ref 1 %},
called [HInclude](http://mnot.github.com/hinclude/),
which does this kind of job.

## The problem

Consider that you have an high-traffic websites which has
some parts of its webpages that rarely change, like the header,
the footer and some sidebars: why should you regenerate all
those parts at every request?

[ESI](http://www.w3.org/TR/esi-lang) solves this kind
of problem, but requires you to make a request through the
network, as you need, at least, to hit the reverse proxy,
which then handles the composition on a resource with
sub-resources.

As I [stated earlier](/edge-side-includes-how-to-spare-terabytes-every-day/),
this is not an optimal approach for every *use-case*, so you
definitely should try to use local caches (your users) to
scale better.

## The solution

HInclude fits perfectly in this context, as you only need to
include the JS and add a namespace declaration to your documents:

``` html
  <html xmlns:hx="http://purl.org/NET/hinclude">
    <head>
      <script src="/lib/hinclude.js"
       type="text/javascript"></script>
```

whenever you need to aggregate data from a sub-recource you
only need to **add an hinclude tag**:

``` html
<hx:include src="/header.html"></hx:include>
```

You can specify a default content - if the user has not javascript
or whatever - and it provides a nice behaviour when the sub-request
generates an error (status codes different from `200` and `304`), as
it adds an `hinclude_$statusCode` class to the tag.

## A dummy benchmark

I provide here a benchmark, a simple and silly one, as you should be
already able to understand the power of HInclude.

First of all let's create a simple response, which aggregates header
and footer directly from PHP, as we are used to do:

``` php index_no_hinclude.php
<html>
    <head>
    </head>
    <body>
      <p>
        <?php include 'header.php'; ?>
      </p>
      <div class="main">
        <!-- start slipsum code -->

        Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?

        <!-- please do not remove this line -->

        <div style="display:none;">
        <a href="http://slipsum.com">lorem ipsum</a></div>

        <!-- end slipsum code -->
      </div>
      <p>
        <?php include 'footer.php'; ?>
      </p>
    </body>
</html>
```

and then the header and footer files:

``` php header.php
<?php usleep(200000); ?>
<!-- start slipsum code -->

You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. Nature is lethal but it doesn't hold a candle to man.

<!-- please do not remove this line -->

<div style="display:none;">
<a href="http://slipsum.com">lorem ipsum</a></div>

<!-- end slipsum code -->
```

``` php footer.php
<?php usleep(200000); ?>
<!-- start slipsum code -->

Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.

<!-- please do not remove this line -->

<div style="display:none;">
<a href="http://slipsum.com">lorem ipsum</a></div>

<!-- end slipsum code -->
```

Bear in mind that I use

``` php
<?php usleep(200000); ?>
```

to simulate some php code execution (`200ms` seems a
reasonable amount of time - inspired by one of our
live projects).

I took a look at Chrome's timeline bar to get an idea of
the average time spent for rendering this resource, and it
was `~450ms`.

If you try to use HInclude, just create a new page:

``` html index_hinclude.php
<html xmlns:hx="http://purl.org/NET/hinclude">
    <head>
      <script src="src/hinclude.js"
       type="text/javascript"></script>
    </head>
    <body>
      <p>
        <hx:include src="header.php"></hx:include>
      </p>
      <div class="main">
        <!-- start slipsum code -->

        Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?

        <!-- please do not remove this line -->

        <div style="display:none;">
        <a href="http://slipsum.com">lorem ipsum</a></div>

        <!-- end slipsum code -->
      </div>
      <p>
        <hx:include src="footer.php"></hx:include>
      </p>
    </body>
</html>
```
and add, in `header.php` and `footer.php`, a caching header,
which HInclude will made the browser take advantage of:

``` php At the top of header.php and footer.php
<?php header('Cache-Control: max-age=3600'); ?>
```

For the first user requests it will require `~220ms` to render
the whole page: this is a pretty good starting gain, as we are
**requesting header and footer in parallel**, but as you retrieve
the page for the second time, performances will incredibly
improve, down to `~40/50ms`: it's, basically, a **90% performance
gain**, but you should be aware that the biggest load time should
be spent within the main body of the page, that I just ignored in
this example; but gaining almost a half second for each pageview
is just a great goal achieved.

As pointed out by other people on twitter, HInclude has a few
drawbacks - think about
[SEO](https://twitter.com/#!/lyrixx/status/172849248868646912) -
but you should be able to use it with contents that rarely need
to play a major role in your SEO strategy (eg. never use HInclude
to retrieve the body of a blog post{% fn_ref 2 %}).

{% footnotes %}
  {% fn You should know him for his contributions to the HTTP specification, httpbis, cache channels and - in general - the HTTP cache %}
  {% fn Recently Matt Cutts came out with the assertion that Googlebot is capable to understand basic JS redirects, so... there's hope %}
{% endfootnotes %}
