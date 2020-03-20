---
layout: post
title: "Last weekend I wrote an IDE. In JavaScript."
date: 2014-06-29 23:32
comments: true
categories: [nikki, oss, nodejs, javascript]
---

In the past days I've been spending some hours on a project
I had in mind since a while, and finally got to roll out
something I am already using on a daily basis: a fast IDE
that runs within a browser.

<!-- more -->

## Nikki

The idea is very simple: why booting a Java monster like
WebStorm / Eclipse / Netbeans when you can satisfy all
of your basic needs with a simple `<div contenteditable />`?

Well, because a browser editor would still need to be able
to talk with your filesystem, and that's something a completely
"frontend" JS app wouldn't be able to do
([but might be able to do soon](https://hacks.mozilla.org/2014/06/webide-lands-in-nightly/)).

So, take JavaScript, put it on the frontend (browser), put
it on the backend (NodeJS), get them to talk (socket.io) and
use a pretty good web editor (ACE), add `ctrl + f` and `ctrl + s`
and we're done:

{% img center https://raw.githubusercontent.com/odino/nikki/master/bin/images/nikki-ss.png?token=328420__eyJzY29wZSI6IlJhd0Jsb2I6b2Rpbm8vbmlra2kvbWFzdGVyL2Jpbi9pbWFnZXMvbmlra2kuZ2lmIiwiZXhwaXJlcyI6MTQwMzk4MDA4N30%3D--df43445fcfba173ae878bc6447c1169b61bc59cf %}

## How to get started

Simply install nikki with an `npm install -g nikki`, `cd`
into a project's directory and launch the editor with the `nikki`
command: the editor will launch a new browser window to let
you have fun with your project.

A `nikki --help` might get the confusion away, but if you
really want to give the project a closer look simply check
the [README on github](https://github.com/odino/nikki).

Of course, of course, of course, I need to clarify a few points:
first of all, nikki is not a "real" IDE, it's  more a text editor
(the marketer in me!), and it didn't really come out in a single weekend
(even though  the basics were setup last WE); last but not least,
I'm not a javascripter ([I guess](http://osrc.dfm.io/odino/)), so most of the credit goes
to [socket.io](http://socket.io/), the [ACE editor](http://ace.c9.io/#nav=about)
and [David](https://it.linkedin.com/in/davidfunaro), who made me write my
very first lines of JS back in 2011 (I know, so late!)

## Considerations

I've started writing this thing 2 weeks ago and I'm very happy
with where I've got so far; in fact, I am writing
this post from "my" nikki, here's the proof:

{% img center /images/nikki-proof.png %}

I plan on fixing a few more bugs I have in my todo list
(because they're "bugging" me) and would be extremely happy
to fix anything you find while playing with nikki: I must admit
that, by using the latest version of Chrome on Linux, I might
have broken a few things on other browsers, so I'd be very
happy to fix anything that comes up (ofc don't mention IE).

## One more thing

As per the README:

> Hey, couldn't you simply use TextMate or LightTable?

> Yes, but then, where's the fun?

Remember, this is a pet project and I firstly did it for
fun, learning and to practice a bit over my spare time:
it is nothing groundbreaking or rocket-science, and I
don't see this going anywhere but my laptop (in terms of
userbase). If you wish to use (or at least try) nikki
I would be very happy though :)