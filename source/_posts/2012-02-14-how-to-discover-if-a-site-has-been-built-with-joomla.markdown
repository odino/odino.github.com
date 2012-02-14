---
layout: post
title: "How to discover if a site has been built with Joomla!"
date: 2010-09-11 13:44
comments: true
categories: [CMS]
alias: "/33/how-to-discover-if-a-site-has-been-built-with-joomla"
---

Today I've updated my customers' requests' list with a particular one from an hair stylist products' reseller.
<!-- more -->

The mail body:

{% blockquote %}
home page restyling
{% endblockquote %}

and nothing else matters.

I'm not kiddind: not an "Hello guys" nor a thank for the patience we paied to read the mail ( the 19 letters that compose the whole mail! ).

So, no probs!

I asked, in the reply, if they need a complete restyling of the site and *...{other boring stuff}...*   ...but the big question was: how was their site built?

Current site's layout sucks at all so, I've thought, it has been built with frontpage or simple HTML+CSS old way ( like this blog's layout, but more ridicolous ).

No: after a while I've decided to know if they were using a CMS and it came out they use Joomla!.

How did I found it out? Let's take a look to the ways you can recognize a Joomla!-based site.

## URLs

Dynamic URLs, in Joomla!, are something like:

* `index.php?option=com_content...`
* `index.php?option=com_virtuemart...`

but this site used static URLs.

Next!

## Generator metatag

The generator metatag defines Joomla! 1.5 as the software that builds the site; unfortunately, it missed here.

Next!

## HTML source

In HTML source of the webpages of the site you can find lots of signs of the usage of Joomla!:

* template's path (`/templates/rhuk_milkyway/css/template.css`)
* extensions

and many others.

Ridicolous, this site used a source encryption tool!

Next!

## Standard URLs

I've tried to type a standard URL like `index.php?option=com_user` but I got a forbidden error: what a stupid webmaster built this site, trying to hide that he used Joomla!

Next!

## /administrator

The backend of the site was protected by a php script.

This appeared to me like a confirmation of the usage of Joomla! because the webmaster could have used any URL he wanted to reach the backend of the site; although I cannot directly get to the backend of the CMS, the fact that the `/administrator` path was the backend of the site made me realize that it was a Joomla!-based site, but I needed a new confirmation.

Next!

## Template blocks

So I've reached:

* ~~index.php?tp=0~~
* index.php?tp=1

and it suddenly appeared the typical Joomla!'s template blocks view.

*Next one, sheriff!*
