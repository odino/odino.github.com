---
layout: post
title: "GraphDB in PHP: time for the serious stuff"
date: 2011-10-25 12:09
comments: true
categories: [graphdb, php]
alias: "/391/graphdb-in-php-time-for-the-serious-stuff"
---

This weekend I've been, for the first time in my life, in Poland, to speak at their national PHP conference.

We - as I was co-speaking with [David](http://davidfunaro.com/) - introduced to the audience the fantastic ecosystem of graph databases, which are storage system using graphs as their primary data structures.

They rule for many reasons that I won't explain here, so I embed the presentation:

{% slideshare 9831071 100% 550 %}
 
We had a little demo at the end of the talk, and everything went fine except for the last feature we wanted to show; we eventually noticed that it didn't work because of a missing fixture in the DB, what a disappointment!

PHPCon Poland was really funny, although we weren't able to follow the 99% of the talks, as they were in Polish.

Saturday night was really intense because of the chats we had with the guys there about our talk and, later, the drinks.

## And now?

On our way back to home we started working on the only huge miss of [Orient](https://github.com/congow/Orient/) ( our ODM for OrientDB ): **persisting PHP objects to the DB** ( the opposite process is almost finished, it was subject of the [beta-5](https://github.com/congow/Orient/issues?sort=created&direction=desc&state=closed&page=1&milestone=3) milestone that we have almost finished ).

Rock the graph out :)