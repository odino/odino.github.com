---
layout: post
title: "The strange case of OrientDB and graph databases"
date: 2015-02-06 01:29
comments: true
categories: [orientdb, series, orientdb 101, database]
published: true
description: "Let's dive deep into the NoSQL world to eventually meet one of its rising stars: OrientDB"
---

{% render_partial series/orientdb.markdown %}

I'd  like to start this new series by providing some
context and all-around information about the subject,
so this article will mostly be a boring cascade of
words rather than real-world examples: I plan to publish
~10 articles on OrientDB in the next 2/3 months (as I have some
old drafts that I finally got to complete) so...just be patient ;-)

<!-- more -->

## OrientDB in a sentence

[OrientDB](http://www.orientechnologies.com/orientdb/) in a sentence?
Let's try with:

> A NoSQL graph database that recently gained lot of attention
> due to its performances and features which, combined together,
> offer a tool that is by far different from any other product
> in the DBMS ecosystem

The aim of this series is to guide the reader through understanding
what are the most interesting  features that OrientDB brings on
the table out-of-the-box and how, melding them altogether,
this database differs from traditional relational systems and
other NoSQL products, being it document DBs like MongoDB or
key-value stores like Redis or Memcache.

{% pullquote %}
OrientDB, in a few more words, is a NoSQL database that belongs
to the family of [graph DBs](http://en.wikipedia.org/wiki/Graph_database), a type of storage engines particularly
suited to represent and store data in graphs, composed of [nodes
and edges](http://en.wikipedia.org/wiki/Graph_%28mathematics%29),
which are structures connecting nodes to each other.

Orient is extremely versatile, as **it includes features from relational
databases, object oriented engines, document DBs and, of course, graph
models**: it is also capable of storing and serving records as JSON documents
and performs very well thanks to its indexing algorithm, named [MVRB-Tree](https://groups.google.com/forum/#!topic/orient-database/vSV6dWHQRyk):
OrientDB is so impressive that, even though it’s pretty young, big players
like [Sky, Lufthansa, Cisco and UltraDNS](http://www.orientechnologies.com/customers/)
are already using it in production.

Since it provides a wide variety of different and powerful features that we
can’t find altogether in any other database, OrientDB can be considered
a **new-generation DB**, as it differs from all of its competitors by aggregating
features from different engines: from having an object-oriented model to
exposing a REST interface, from being able to traverse a graph of thousands
records, at any level of depth, in milliseconds, to its simplified SQL
syntax, all of the features that make this DB engine so unique will lead
us to the conclusion that {" OrientDB is a game-changer in the DB market "}, as
it provides to the developers a toolset and a variety of functionalities that
they can never take advantage of with any other database management system.
{% endpullquote %}

## Why looking into OrientDB?

It would be easier, but probably too less interesting, to start this series
by immediately introducing the reader to the incredible meshup of features
and scenarios that OrientDB offers and covers; so before digging into the
product itself, a good question we should ask ourselves would be:
why should we look at another database engine?

One thing that we - software engineers - are always eager to do is to learn
new patterns, tools and practices, as the process of learning stimulates us
and seems to be a good workaround for our day-to-day routine.

On an opposite note, what we find really hard to accept, is to apply very old
technologies and schemes to new contexts, as we tend to think that what has been
working for us in the past few years will always work and be there for us.

If you, for example, think about the NoSQL ecosystem, you will find that those
concepts that are really attractive in our times are an implementation of **ideas
engineers had 20, 30 or even 40 years ago**: when Mikio Hirabayashi released,
in 2007, Tokyo Cabinet, a key-value storage engine,  it was clear that most of
Hirabayashi’s work was a re-implementation a tool he already wrote 4 years before,
named QDBM; an interesting thing that a few know is that QDBM itself is almost 40
years old, as it is a direct descendant of [DBM](http://en.wikipedia.org/wiki/Dbm), a generic database library written
by [Ken Thompson](http://en.wikipedia.org/wiki/Ken_Thompson) - also known for being the main contributor to the UNIX operating
system - in 1979.

When we look at Hirabayashi’s work, we can think of it as a "[Kaizen](http://en.wikipedia.org/wiki/Kaizen)" - a Japanese
word which stands for “continuous improvement“ - as he took concepts and an initial
design (DBM) and developed 3 tools, in rapid succession, based on that 30+ years
old original tool: QDBM, Tokyo and Kyoto Cabinet{% fn_ref 1 %}.

{% pullquote %}
But to reach his own Kaizen one does not only have to improve and re-elaborate
old ideas and make them better, as there are some scenarios where the problem
is caused by the idea itself, not the implementation: it is the “one size fits
all” problem; one has a good solution, tries to adapt it to all possible scenarios
and projects he faces...and drowns with it.

As we are all used to relational database management systems (RDBMS), {" it is often
difficult for us to realize that sometimes, even though RDBMS serve for a wide
range of purposes, they are not the best tools to work with "} for a specific
problem: we often pick them among other solutions because we’re used to them,
thinking “it worked until now”, without wondering if we could utilize a very
different tool for the job.

For us, most of the time, “RDBMS fit all”, and persistency of our applications
is enslaved to their patterns, limitations and design.
{% endpullquote %}

## NoSQL to the rescue

But this was a few years back, right?

In the last ~5 years we saw a huge  growth in utilization of NoSQL
storage engines like CouchDB, MongoDB, Redis  or whatsoever buzzword of
the moment: we first took a look at those tools, thought that they were
pretty attractive and eventually used them, without
really asking ourselves “why are we using a NoSQL database?” and - most
important - “why is it called NoSQL?”.

As most of us know, **NoSQL is not a negation of the traditional RDBMS ecosystem**,
it just stands for “Not only SQL”, as if there is no war between relational
engines and NoSQL databases: fact is that there is no conflict between relational
and non-relational models, as they serve for different needs; comparing the 2
is like comparing pizza with eggs: one can chose based on his own taste, but at
the end the final decision is made considering external requirements, like if
you are on a diet or out for dinner with your better half; we, as software engineers,
are bound to the same constraint: we cannot decide based on our own taste, we
need to first consider the project’s requirements and eventually pick the right
tool for the situation.

This is why I am writing this series dealing with a NoSQL database - *one of a kind*, I would
say - as it’s build on top of innovative concepts as well as ten-years-old ones,
it’s a direct descendant of other DBMS and brings brand new possibilities in
data storage and management.

Categorizing a tool such as OrientDB is a very difficult job: sure, we can
define OrientDB as a NoSQL graph database, but limiting ourselves to a mere
definition wouldn’t allow us to comprehend the power of the tool itself;
OrientDB, for example, also includes a document layer and can be therefore
classified also as a document DB: given the mix of concepts and features
included in it, this storage engine pushes a developer’s boundaries further
ahead compared to what any other DBMS can offer.

Ready to [be amazed](http://pettergraff.blogspot.sg/2013/12/orientdb-thanks.html)?
Let's have a closer look at Orient's power features in the next article!

{% footnotes %}
  {% fn Hirabayashi eventually developed Kyoto 2009, to review the implementation of Tokyo %}
{% endfootnotes %}
