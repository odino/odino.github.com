---
layout: post
title: "The 5 golden rules when writing open source software"
date: 2014-07-05 21:29
comments: true
categories: [oss, open source, coding]
---

There you are, you just opened your laptop
and got the inspiration to write a bunch of
code and release it open-source: sounds quite
simple and easy, but you should always keep
in mind a few rules that are going to boost
your "creature" before releasing it to the
public.

<!-- more -->

## Documentation

> If it's not documented, it doesn't exist

That's probably the biggest truth of OSS: if you don't
provide a good [README](https://github.com/visionmedia/express)
or some [more complete docs](http://pypy.readthedocs.org/en/improve-docs/index.html)
it's gonna be hard for people to be able to understand
the value of your software, or to even give it a try and
get straight to the point.

[ReadTheDocs](https://readthedocs.org/) is an awesome project
that lets you create beautiful documentation for your projects
for free but, if you want to keep things simple, github's
[pages](https://pages.github.com/) or [wiki](https://help.github.com/articles/about-github-wikis)
might be what you were looking for.

## Packaging

{% img left /images/npm-logo.png  %}

Do never forget about shipping it in a way that makes it easy,
for others, to install your software in a matter of seconds:
a great example, in this sense, is [NPM](https://www.npmjs.org/)
for NodeJS, which lets you install modules with a simple `npm install moduleName`.

This is possible with basically any platform out there: PHP has
[Composer](https://getcomposer.org/), Ruby has [Gems](https://rubygems.org/)
and Python uses, if I'm not wrong, [pip](https://pypi.python.org/pypi/pip)
(there are many other examples, like CocoaPods and so on, but the ones
i mentioned seem to be most mature and stable nowadays{% fn_ref 1 %}).

## Visibility

{% img right /images/github-logo.png  %}

I don't know about you, but I always have a strange feeling
when I open a link to a project and it's hosted somewhere like,
let's say, [GoogleCode](https://code.google.com/): I wouldn't
say that your choices are limited, but whenever you're
gonna pick a hosting solution for your library it's though to look
anywhere but [Github](https://github.com/), as they have:

* great user experience
* good platform for engagement (pull requests, comments)
* [love for the OSS world](https://github.com/github)
* awesome [vision and communication](https://github.com/blog)
* [tricks](https://www.flickr.com/photos/ginatrapani/5016915048/) to make your experience fabolous

If you want to look for widespread alternatives, though, you might
find Atlassian's [BitBucket](https://bitbucket.org/) the most
serious competitor of GitHub.

## Coding standards

Follow the coding standards that are *en vogue* in your community:
for example, in PHP you got the [PSR](http://www.php-fig.org/)s,
which are guidelines for writing your code, created by the
PHP community itself (or - at least - its most prominent members).

Writing code with your own standard will just make it
harder for the ones interested in your project: you want them
to be able to focus on what you're offering and to discuss it,
not to spend too much time reading commas and brackets in weird
positions.

## Tests

{% img left /images/travis-logo.png  %}

Automated tests are probably a must if you plan to have
people relying on your software, especially if what it does
is not contained in very few lines of code (and in any case,
even there tests are so much helpful).

Tests will also help you evaluating contributions from the
community: other devs will get interested in your software,
find a glitch, fix it, add a test and send you a pull
request. At that point you only have to check the code,
because the tests are gonna take care of the build on their own.

Nowadays you don't even have to boot your own machine to run
the tests: hook your library with [travis-ci](https://travis-ci.org/)
and you're done!

## Recap

Before announcing your latest project to the world, I would:

* put it on github or bitbucket
* write a decent `README.md`
* create the package on the most suitable package manager
* review the code to check everything makes sense
* add tests and let them run on Travis

I'm sure I might have missed something...   ...so you tell me,
what are **your** golden rules?

{% footnotes %}
  {% fn Besides, probably, apt :) %}
{% endfootnotes %}