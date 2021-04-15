---
layout: post
title: "Book review: Release It -- Design and Deploy Production-Ready Software"
date: 2017-03-16 14:00
comments: true
description: "Review of a masterpiece for whoever wants to build safe and robust distributed systems"
categories: [book, review, distributed systems, architecture]
---

I've been reading quite a bit over the past 2/3 months (thanks to -- believe it
or not -- my wife), and today I wanted to share my review of
[Release It! Design and Deploy Production-Ready Software](https://www.amazon.com/Release-Production-Ready-Software-Pragmatic-Programmers/dp/0978739213).

<!-- more -->

{% img right /images/book-release-it.jpg %}

The book is extremely interesting as it's a collection of patterns and practices
to build reliable and robust distributed systems, with a few advices on process
design as well: for example, I extremely liked, at the beginning of the book,
the notion that a lot of software architects are living in the "[ivory tower](http://www.lessonsoffailure.com/developers/avoid-asshole-architect/)",
meaning that they are distant from the real-world code that turns their ideas
into working software, and rely too much on the *happy-path* rather than
recognizing that, more often that we'd like, systems are going to fail.

Another trait of the book I really liked is the fact that the author brings his
own experience to the table: you'll read about weird situations where an e-commerce
portal used to be down every night at a specific time, how a "dumb" firewall can
kill all of your idle connections and so on; by the end of the book you'll surely
be hating on firewalls, connection pools and (missing) timeouts.

The only negative I can think of is that the book is a bit too *java-ish*, as
sometimes you might feel some ideas won't really apply to the platform you
generally work with -- but, to be honest, that's no biggie.

Strongly, strongly recommended for software engineers that want to understand how
their systems should be modeled once they reach a certain scale and, inevitably,
need to deal with failure.