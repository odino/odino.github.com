---
layout: post
title: "Versioning other behaviours' columns with Doctrine Versionable"
date: 2010-11-23 13:54
comments: true
categories: [Doctrine]
---

Using doctrine inside symfony is a relief: behaviours, particularly, can save your days.
<!-- more -->

The Versionable behaviour, for example, has the ability to manage versions of your model's entities.

``` yml
Entity:
  actAs:
    Versionable: ~
  columns:
    name:  { type: varchar(25) }
```

In this case every time you're gonna update an entity, it's name is stored in a table called `entity_version`, and your object is ready to be reverted to a previous version by simply calling:

``` php
<?php

$entity->revert(X);
```

where X is the revision number.

But, but, but...

...when using this behaviour with other behaviours you must pay attention at the order of the behaviours in your `schema.yml`.

``` yml
Entity:
  actAs:
    Versionable: ~
    Timestampable: ~
  columns:
    name:  { type: varchar(25) }
```

In this case we added the timestampable behaviour, another built-in behaviour which adds `created_at` and `updated_at` attributes/columns.

But with this YML, the versioning table will not store the additional columns, because **the Versionable behaviour is declared before the timestampable one**, so you need to **put it after all the behaviours which add columns you want to version**:

``` yml
Entity:
  actAs:
    Timestampable: ~
    Versionable:  ~
  columns:
    name:  { type: varchar(25) }
```
