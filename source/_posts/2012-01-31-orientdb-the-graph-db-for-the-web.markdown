---
layout: post
title: "OrientDB, the Graph DB for the web"
date: 2011-05-19 02:07
comments: true
categories: [OrientDB]
alias: "/346/orientdb-the-graph-db-for-the-web" 
---

Yesterday I had the opportunity to talk - just a bit - with [Luca](http://zion-city.blogspot.com/), the creator of [OrientDB](http://www.orientechnologies.com/).
<!-- more -->

He showed me a few functionalities that seem pretty interesting, for a pure web-oriented usage of this GraphDB.

## Relations in a graph database

{% blockquote Claudio Martella http://blog.acaro.org/entry/somebody-is-going-to-hate-me-nosparql NoSPARQL %}
GraphDBs don't avoid relations but they embrace them in a way that they are not a computational problem anymore, by making them explicit instead of implicit through joins.
{% endblockquote %}

This means that you don't have foreign keys anymore. God bless'em.

For instance, if you look at a typical relation, in OrientDB, you'll get something like this:

``` yml
Author:
  author_1:
    rid: 1:2
    name: Ken Follet
    books: [2:1,2:2]

Book:
  book_1:
    rid: 2:1
    title: ...
  book_2:
    rid: 2:2
  ...
```

As you see, direct links are stored in the author record. 

This means that the direct reference lets you traverse the graph without the overhead that relational system have.

So traversals almost come for free, while, given a tree ( which, by the way, is a directed graph with no cycles ), in a relational system you should do expensive queries in order to extract it.

Doing it with the `parent_id` means that you are basically trying to rape your DB, doing it with some algorithm like the nested set means that you are loosing some great advantages of RDBMS.

## Some relations in OrientDB

OrientDB has some cool data types to handle relations.

First of all, it has embedded stuff, **like MongoDB**.

Orient divides relation type in embedded or link relations.

Embedded relation are the ones where the element connected to an object lives only in the context of that object ( thus, for instance, they have no record id ) while the linked ones are real objects connected to an object.

So for example, a Post can have many embedded tags:

``` yml
Post:
  title: My post
  tags: agile, php
```

or links to tag entities:

``` yml
Post:
  title: My post
  tags: [2:1,2:2] // given 2 as the cluster where you store tags
```

Given these 2 different relation types, you can choose among three main data structures to store them:

* [embedded|link] list, which is a series of ordered relations
* [embedded|link] set, which is a series of unordered relations
* [embedded|link] map, which is a series of key/value pairs

## Structure of a graph

The standardized way to structure a graph is pretty straightforward, because you have 3 entities: nodes ( your objects ), edges ( the connections between them ) and properties ( that are assigned to both of the previous ).

For example, the triples can be defined like in the following snippet:

``` yml
Book:
  1:1:
    title:  Graph databases

Author:
  2:1:
    name: Ken
    last_name: Follet
  2:2:
    name: ...

Edge:
  3:1:
    in: 2:1
    out: 1:1 
    label: wrote
    during:  2012 
```

Which is pretty easy to understand.

## Structure of OrientDB

Mmmm, so you are probably asking yourself: how the hell can I use this triples in a web-oriented product?

My short answer is: you probably can't.

Graph databases help you, for example, when you need to write GPS car navigation systems or stuff like that. But **the web hates triples**.

So, you are probably thinking that a product like OrientDB won't ever fit well in your projects, and **you are totally wrong**.

The cool thing about OrientDB is that it is **a graph database built upon a document one** ( or probably the inverse, I don't exactly know ), so it's able to perform like a common graph but lets you structure your data like a document-oriented database.

Products like Neo4j aren't able to avoid triples for your data structures, and that's why I think that OrientDB will be the precursor of the web-oriented graph databases.
