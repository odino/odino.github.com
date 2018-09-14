---
layout: post
title: "Web security demystified: WASEC"
date: 2018-07-14 22:45
comments: true
categories: [security, WASEC, web application security, infosec, course, series]
description: "I've decided to work on a short course / e-book on Web Application SECurity (WASEC since I like to shorten things)"
---

{% render_partial series/wasec.markdown %}

{% img right /images/wasec.jpeg %}

I've been thinking of writing a long article around *everything a web developer
should know about application security* for quite some time, and it's clear to me
that this mastodontic exercise is never going to take place all at once.

In order to get things rolling, I've decided that,
instead of writing one long, exhaustive article, I'll be splitting my efforts
over a longer period of time, and come up with a series around
Web Application SECurity (WASEC, since I like to shorten things).

In this article I'd like to introduce the contents I'm going to write about,
and how I'm planning to publish them.

Interested in learning how a compromised CDN wouldn't affect your users?
Want to know why CSRF is going to die? Read on.

<!-- more -->

## Why?

This is how I like to sum up the goal of WASEC, a series on **W**eb **A**pplication **SEC**urity:

> As software engineers, we often think of security as an afterthought: build it, then fix it later.
>
>Truth is, knowing a few simple browser features can save you countless of hours banging your head against a security vulnerability reported by a user. This book is a solid read that aims to save you days learning about security fundamentals for Web applications, and provide you a concise and condensed idea of everything you should be aware of when developing on the Web from a security standpoint.
>
> Don't understand prepared statements very well? Can't think of a good way to make sure that if your CDN gets compromised your users aren't affected? Still adding CSRF tokens to every form around? Then this book will definitely help you get a better understanding of how to build strong, secure Web applications made to last.
>
> Security is often an afterthought because we don't understand how simple measures can improve our application's defense by multiple orders of magnitude, so let's learn it together.

It's been a while I've been thinking of *writing* something meaningful: not that
I think my previous articles are terrible, but I always wanted to try to make
something more "durable" -- if you get what I mean.

With WASEC, my goal is to publish a reference for developing web application with
security in mind, so that instead of receiving 100 vulnerability reports...
...you could probably reduce that number to 90 :)

## So now you're a security guru?!?!

Not at all, that's why I'd like to emphasize that **this is content for the everyday
software engineer** that writes web applications: I've made a living of writing web
apps for [various employers](https://www.linkedin.com/in/alessandronadalin/), and have seen things going south as well as strong, solid
approaches to security -- with this, I'm simply trying to share my experience
and what I like to keep in mind when trying to secure web applications.

## Contents

This table of contents is as stable as a table with three legs, but should give
you a rough idea of the contents I'm planning to write about:

* Introduction
* Understanding a browser
* HTTP(S)
  * HTTP vs HTTPS vs HTTP/2
    * Cloudflare: a twist of the tale
  * GET vs POST
  * Security-related headers
    * HTTP Strict Transport Security (HSTS)
    * Public Key Pinning Extension for HTTP (HPKP)
    * X-Frame-Options
    * X-XSS-Protection
    * X-Content-Type-Options
    * Content-Security-Policy
    * X-Permitted-Cross-Domain-Policies
    * Referrer-Policy
    * Expect-CT
    * Origin
    * CORS
      * CORS vs proxies
* Managing sessions
  * Understanding HTTP cookies
  * Session vs persistent cookies
  * Flags
    * secure
    * same-site
      * CSRF tokens
    * httpOnly
  * Supercookies
  * Alternatives
    * localStorage
    * tokens
      * JWT
* Situationals
  * Blacklisting vs whitelisting
  * Logging secrets
  * Cookie tampering: never trust the client
  * Injection
    * Understanding prepared statements
  * Dependencies with known vulnerabilities
  * OWASP
    * XSS
  * Have I been pwoned?
    * Re-using credentials: a real-world story
  * Session invalidation in a stateless architecture
  * Sub-resource integrity
* DDOS attacks
  * Introduction
  * Don't panic!
    * CloudFlare
    * Cloud Armor
    * AWS Shield
* Secrets management
  * Pushing to Github
  * An isolated repository
  * Encrypting secrets with SOPS
  * Environment variables: not a silver bullet?
* Bug Bounty Programs
  * What's in a program?
  * HackerOne
  * Dealing with security researchers
  * "Malicious" reporters
* Leveraging other services
  * An all in one solution: CloudFlare
  * Travis-ci
  * NPM audit
  * Gemnasium and similar tools
    * GH security alerts

And I'm sure I'm forgetting half of the content I originally thought of... :)

## Series? E-book?

If you have followed me throughout the years, you surely noticed how I like to
open-source as much as possible: helping the community comes first, the same way it
helped me -- if it wasn't for the first conference
I attended, I would have never become the kind of software engineer I am today (hint: *a very bad one!*).

I have a short history at publishing series, but over the years I've managed to
come up with a few, connected series of articles that saw the light on this blog:

* [Probabilistic Data Structures](/probabilistic-data-structures-an-introduction/)
* [Symfony2 components in your own userland](/using-the-symfony2-dependency-injection-container-as-a-standalone-component/)
* [OrientDB](/the-strange-case-of-orientdb-and-graph-databases/)

These are very short series (by the way, the probabilistic data structures one is still in progress),
and I'd like to mimic my previous approach for WASEC: short articles that make
an interesting story -- or, in this case, a book.

I'm going to be publishing [WASEC as a book, through LeanPub](https://leanpub.com/wasec),
and post 80% of its chapters in this blog (as well as in its [medium](https://medium.com/@AlexNadalin) copy).

Why not replicate the entire book on this blog? Well, I want to make sure you'd'be
interested in grabbing a copy of the book as well, which I'm planning to publish
in a few stores (Kindle, LeanPub) for a ridicolous amount of money. LeanPub sets
the minimum price for a book at $4.99 but, if it was for me, I'd ask for $2.99
(and that's because [one of my most satisfying reads costed me that much](/book-review-an-introduction-to-stock-and-options/)).

Long story short: [grab the book, it's going to be worth it](https://leanpub.com/wasec).

## Cadence

I'm planning to release a new chapter every 45 days, meaning WASEC should be
completed within a year, year and a half (~10 chapters). If this sounds like a very long-term
commitment, consider this a diversion in the topics that I generally like to write
about: I'll be mainly focusing on Web Application SECurity rather than, for example,
[probabilistic data structures](/categories/probabilistic-data-structures/) (or [rant about Twitter's ads](/advertising-on-twitter-give-us-your-personal-data-or-were-going-to-bomb-your-timeline-with-nsfw-sexual-ads/)).

This does not mean that I will forget about everything else I used to write about,
but rather than 2 out of 3, maybe 3 out of 4, or 4 out of 5 articles I publish
are going to be related to WASEC.

## In the end...

Game on! Off to writing...
