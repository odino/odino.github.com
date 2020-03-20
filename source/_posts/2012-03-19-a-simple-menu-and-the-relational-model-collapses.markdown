---
layout: post
title: "A simple menu and the relational model collapses"
date: 2011-04-17 16:07
comments: true
categories: [nosql]
alias: "/329/a-simple-menu-and-the-relational-model-collapses"
---

Relational sucks, some say.

That's not fair, because we used it for 30 years and we still need it: but there are some particular cases, out there, that relational, and traditional, databases can't handle well.
<!-- more -->

## The simple case of the menu

You are building a CMS for your customer, and you just got to the point you need to develop *that* feature, the **menu management system**.

A menu is really simple, because it's an entity connected ( N to N ) with other entities ( menu items ).

So the class diagram is really simple:

{% img center /images/Menuclassdiagram.png %}

But there's a problem: not all of the menu items are equal; you can link an external URI or a news ( an entity of your model ).

There you basically have 2 choices: to de-normalize your data or to do **column aggregation**.

## Column aggregation

You can simply create a single table, link, with a type column ( the type is usually used in order to [work with an ORM](http://www.doctrine-project.org/documentation/manual/1_2/en/inheritance:column-aggregation) ):

{% img center /images/Columnaggregation.png %}

but the situation gets ridicolous, although your ORM may work fine with this pattern: as soon as your domain grows and you need to link more entities, you get

``` bash
(n-1) * r
```

`NULL`s in your table, given `n` as our entities and `r` the amount of rows.

Another problem is that the relations can be NULLable, and sometimes you can't afford it.

I like to call tables created with the column aggregation **full-o'null**, because they suck really much: despite this, they can save your life if you need to develop small system, with a modest domain; plus, they usually help you avoid UNIONs.

## De-normalization

Subtitle: how to use a RDBMS as a non relational system.

Sub-subtitle: **being an ass with RDBMS**.

Normalization is one of the things we try to achieve with relational systems, so dropping it it's evil: we tend to consider de-normalization good as far as we recognize our data don't fit well in a RDBMS ( thus the problem it's not with MySQL or Oracle, it's our fault ).

But sometimes we like being asses, and we go for disrupting our relational DB.

{% img center /images/Denormalization.png %}

With this approach, you break the referential integrity, although you have much cleaner tables. I personally don't like it, but sometimes it's the fastest and most clever way to go.

## A menu, with its complications

So, as you see, a menu ( something that should be really simple ) can undermine our data structure: and since we are used to relational data we think relational DBMS can handle very well this kind of problems.

That's, obviously, wrong, because relational databases have their limitations: they can't, for example, deal with **semantic inheritance**.

## The semantic inheritance dilemma

A menu has N links, and each link differs from the others.

So a link basically has a relation with semantics ( "I **link** in a menu" ) and its inheritance ( links inherit from a base Link class ) but the relational systems aren't able to provide a way to express a relation, which has a single semantics, with entities from different sources ( = tables, roughly speaking ).

When you work with systems like [OrientDB](http://www.orientechnologies.com/), everything is done for you; being a NoSQL graph db:

* the system doesn't care, by itself, about referential integrity ( so you feel relieved :-) )
* the system stores a direct link to express the relation
* the system has a native API to easily retrieve linked objects

For example, in OrientDB you can:

``` bash
select links from menu where @rid = [rid of the menu] // [29:0, 28:0, 28:1]
```

as you see that returns you records from different classes ( **29**:0, **28**:0, ... ), that you can retrieve with:

``` bash
select from [28:0, 28:1, 29:0, ...]
```

Yes, awesome.