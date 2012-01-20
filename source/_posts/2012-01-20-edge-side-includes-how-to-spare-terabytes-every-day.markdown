---
layout: post
title: "Edge Side Includes, how to spare terabytes every day"
date: 2012-01-20 14:15
comments: true
categories: [ESI, HTTP, scaling]
---

I have an idea for an RFC that I would like to write, based on some thoughts I
had in the last months.
<!-- more -->

Lots of you probably know [ESI](http://www.w3.org/TR/esi-lang), the specification
written by [Akamai](http://www.akamai.com/) and [Oracle](http://www.oracle.com/index.html)
back in 2001.

It basically consists in a XML dialect which lets [reverse proxies](http://en.wikipedia.org/wiki/Reverse_proxy)
(eg. [Varnish](https://www.varnish-cache.org/)) cache fragments of your webpages
in order not to hit your application for output fragments that can be re-used
across many clients.

``` html A webpage including an ESI tag
<html>
  <head>
    ...
  </head>
  <body>
    ...

    pile of HTML

    ...

    <esi:include src="http://example.com/footer.html" />
  </body>
</html>
```

A **really good presentation** about ESI is [Caching On The Edge](http://www.slideshare.net/fabpot/caching-on-the-edge/99)
, by [Fabien Potencier](http://fabien.potencier.org/).

## ESI's context ##

ESI is a really great technology that recently gained hype, in my ecosystem (PHP),
thanks to the Symfony2 architecture, fully embracing the HTTP specification:
consider that Symfony2 has **no application-level caching layer**, so everything
is done with the HTTP cache, and ESI is the solution for really dynamic webpages.

...but who's responsible of processing ESI fragments? Digging some more, an esi
processor can be a [middleware in your architecture](http://rack.rubyforge.org/)
, a reverse proxy or a [software component](http://symfony.com/doc/2.0/book/http_cache.html#using-edge-side-includes)
; basically any kind of software implementing the ESI specification.

But hey, all this kind of things are softwares that lie on the server side.

## A different approch ##

I was thinking about pushing ESI to the client side:

``` html The response retrieved with the browser would generate lots of subrequests
<html>
  <head>
    ...
  </head>
  <body>
    <esi:include src="http://example.com/header.html" />
    <esi:include src="http://example.com/navigation.html" />
    <esi:include src="http://example.com/foo.html" />
    <esi:include src="http://example.com/bar.html" />
    <esi:include src="http://example.com/footer.html" />
  </body>
</html>
```

Seems a bad idea, since, if the browser is capable to merge different fragments, retrieved
with different HTTP requests, for assembling a really simple webpage you would
need to hit your application much more times than with a single request, so there
is no real need to ask for ESI support in clients, in this scenario.

But there's a *real-world* application of ESI on the client side that should
**save lot of traffic** over the internet and **lot of bandwith**.

**Rarely-changing output fragments**.

A RCOF - sorry for this bad acronym - is everything that can be **cached for
relatively long time** (talking more about days than hours), like Facebook's
footer or your google analytics JS code.

{% img center /images/fb.footer.png %}

## The use-case

Why should we always transport Facebook's footer over the network?

We don't need it: once the user landed on his profile page, as he jumps
to other FB pages, **the footer it's always the same**, and **should be retrieved from
the client's cache** instead of being sent over the network.

This means that once you send your response

``` html Your profile page
<body>
    <h1>My Profile!</h1>

    ...

    <esi:include src="http://example.com/footer.html" />
</body>
```

the browser makes an additional request to retrieve the footer and then, on subsequent
requests, also **on different webpages**, it can use the cached fragment:

``` html Facebook help center
<body>
    <h1>Hi n00b, how can we help you?</h1>

    ...

    <esi:include src="http://example.com/footer.html" />
</body>
```

because it recognizes that fragment has been already retrieved once you requested
the "Your profile" page.

You probably don't get the great aspect of ESI on the client side, so **carefully
read the next chapter**.

## A few numbers

Facebook's footer is about `1.4k`:

``` html
<div id="pageFooter" data-referrer="page_footer">
    <div id="contentCurve"></div>
    <div class="clearfix" id="footerContainer">
        <div class="mrl lfloat" role="contentinfo">
            <div class="fsm fwn fcg">
                <span> Facebook © 2012</span> · <a rel="dialog" href="/ajax/intl/language_dialog.php?uri=http%3A%2F%2Fwww.facebook.com%2Fpress%2Finfo.php%3Fstatistics" title="Use Facebook in another language.">English (US)</a>
            </div>
        </div>
        <div class="navigation fsm fwn fcg" role="navigation">
            <a href="http://www.facebook.com/facebook" accesskey="8" title="Read our blog, discover the resource center, and find job opportunities.">About</a> · <a href="http://www.facebook.com/campaign/landing.php?placement=pf&amp;campaign_id=402047449186&amp;extra_1=auto" title="Advertise on Facebook.">Advertising</a> · <a href="http://www.facebook.com/pages/create.php?ref_type=sitefooter" title="Create a Page">Create a Page</a> · <a href="http://developers.facebook.com/?ref=pf" title="Develop on our platform.">Developers</a> · <a href="http://www.facebook.com/careers/?ref=pf" title="Make your next career move to our awesome company.">Careers</a> · <a href="http://www.facebook.com/privacy/explanation" title="Learn about your privacy and Facebook.">Privacy</a> · <a href="http://www.facebook.com/legal/terms?ref=pf" accesskey="9" title="Review our terms of service.">Terms</a> · <a href="http://www.facebook.com/help/?ref=pf" accesskey="0" title="Visit our Help Center.">
                Help
            </a>
        </div>
    </div>
</div>
```

while an ESI fragment is `0.5k`:

``` xml
<esi:include src="http://facebook.com/footer" />
```

Calculating how much traffic the internet needs to sustain with the 2
approaches, traditional and ESIsh, is trivial:

* Facebook has something more than [400M daily users](http://www.facebook.com/press/info.php?statistics)
* it has [12 pageviews per user](http://www.alexa.com/siteinfo/facebook.com)
* retrieving the footer the traditional way, we add `1.5k` of data each users' request
* retrieving it with ESI, we add `1.5k` of data for the first users' request,
`0.5k` for the consequent ones

Then we can extrapolate some data:

``` html Facebook daily pageviews
daily users * avg pageviews

400M * 12

4800M
```

``` html Data traffic without client-side ESI
daily pageviews * footer fragment weight

4800M * 1.4k

~6.25 terabytes
```

``` html Data traffic with client-side ESI
(first requests * footer fragment weight) + ((daily pageviews - first pageviews) * ESI tag weight)

(400M * 1.4k) + ((4800M - 400M) * 0.5k)

~2.57 terabytes
```

So, just for the footer, **facebook could decrease the internet traffic by 2 and a
half terabytes *per day***, just looking at its footer.

It's obvious that **this approach rewards facebook** (it processes less stuff on his
side, whether it uses a reverse proxy as gateway cache or not), ISPs and the final
user, who's taking advantage of a (more) **lean network**.

If you enlarge your vision, think about sites like Google, LinkedIN, twitter and all
those web applications which send **useless pieces of HTTP responses over the
internet**.

## Client side ESI invalidation

If you are scared about invalidating this kind of cache, the solution would be
really easy:

``` html Facebook before updating the footer
<html>
  <head>
    ...
  </head>
  <body>
    ...

    pile of FB code

    ...

    <esi:include src="http://example.com/footer.html?v=1" />
  </body>
</html>
```

``` html Facebook after updating the footer
<html>
  <head>
    ...
  </head>
  <body>
    ...

    pile of FB code

    ...

    <esi:include src="http://example.com/footer.html?v=2" />
  </body>
</html>
```

Note the **revision change in the ESI tag**, something we already, daily, use for
managing [static assets' caching](http://muffinresearch.co.uk/archives/2008/04/08/automatic-asset-versioning-in-django/).

## This is not a panacea

I don't wanna sound arrogant proposing this tecnique, but I would really like to
**get feedbacks about such this kind of approach**: as stated, this can be a
great plus for the global network but its **limited to RCOF**.

The only aspect I haven't considered yet is the second HTTP request the browser
needs to do to retrieve the fragment, once, parsing the response, it finds an ESI
tag: since I really don't know how to calculate how it affects the network,
so any kind of help would be appreciated.

The aim of this post is to consider if **browser vendors should really start thinking
about implementing ESI processors** directly in their products, for a better, faster
and leaner web.