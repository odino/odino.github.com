---
layout: post
title: "Graph databases: OrientDB to the rescue"
date: 2011-04-16 14:02
comments: true
categories: [NoSQL, GraphDB, OrientDB]
alias: "/327/graph-databases-orientdb-to-the-rescue"
---

[OrientDB](http://www.orientechnologies.com/) is a graph database written in Java, mainly developed by [Luca Garulli](http://zion-city.blogspot.com/), [AssetData](http://www.assetdata.it/it/index.php)'s CTO.
<!-- more -->

{% img right /images/orientdb.png %}

## Why a graph database

Sometimes the relation model isn't the way you want both to collect and navigate your data: Luca Bonmasser, at the NoSQL day, highlighted it in his talk about [anti-patterns in the relational ecosystem](http://www.slideshare.net/bonmassar/patterns-antipatterns-with-nosql/29).

So, sometimes, in order to:

* improve performances
* mantain a clean data structure
* do DDD right{% fn_ref 1 %}

you should go for a NoSQL solution: that said, when you also need to store and retrieve a particular data structure, you should work with a graph database.

##Oh My Graph

{% img left /images/directed.graph.svg %}

A graph is a really simple entity ( ok, not that simple: I try to outrageously simplify things here ) with **vertices** and **edges**.

Edges connect various vertices, and can be **directed** or **undirected**: directed connections happen when the edge has an orientation ( like in the case of a person *having* a car ), undirected when it hasn't ( like a person being friend of a person, which is a bi-directional connection ).

You use and work with graphs more frequently than what you can actually think: when dealing with trees ( like the ones you tend to solve with [Doctrine's nested sets](http://www.doctrine-project.org/documentation/manual/1_2/nl/hierarchical-data) ) you are basically working with **a directed graph with no cycles**.

In the database domain, the graph has an additional element, the **property**: N properties can be assigned to a vertex ( thus **any graph storage engine can work as a document-oriented DB** ).

## Why OrientDB

OrientDB is a NoSQL graph database with an aim: be easy by making you more productive.

So it's really easy to install and setup: you just need to download the [latest release from googlecode](http://code.google.com/p/orient/downloads/list) ( hope they will move it to GitHub soon ), unzip it and start the server:

``` bash
cd path/to/orient
cd bin
chmod +x server.sh
./server.sh
```

{% img center /images/orient-bash.png %}

Orient is also SQL-friendly, letting you query the database with SQL-like syntax: since everybody knows SQL, you should be able to take confidence with its query language in a few minutes.

It is [ACID](http://en.wikipedia.org/wiki/ACID) and can be schema-*; which means that:

* it can be schema-ful, just like a RDBMS
* it can be schema-less, leveraging the power of no-prior knowledge of data's structure
* it can be schema-mixed, ...well, you guessed it!

Another cool thing is that the distribution comes with a pre-defined set of data: so now you are ready to play with graph stuff... but how?

## REST in P...DB

{% img right /images/orient-studio.png %}

I introduce you OrientStudio, the GUI to manage your Orient's instance.

OrientStudio is a simple tool bundled with Orient's package, which listens on port 2480 as you start the server, mainly developed in JavaScript, able to let you:

* CRUD objects, [classes](http://code.google.com/p/orient/wiki/Concepts#Class) and [clusters](http://code.google.com/p/orient/wiki/Concepts#Cluster)
* query the DB
* explore and navigate your graph's objects

There's something really cool about OrientStudio: it works, natively, via HTTP, which means that Orient has an [HTTP interface](http://code.google.com/p/orient/wiki/OrientDB_REST) to let you manage your graph.

The interface is defined "RESTful", in the docs: just don't be finicky and consider it as RESTful as CouchDB ( so definitely not RESTful, but HTTP-loving ).

Orient also works with its binary protocol, which is a looooooot faster than the HTTP one.

## OrientDB and PHP

So, what does this have in common with our so-loved scripting language?

We'll find it out in my next article, where I'll tell you how to query OrientDb from PHP.

{% footnotes %}
  {% fn This is not an academic motivation: DDD is the base of a good OO design %}
{% endfootnotes %}
