---
layout: post
title: "Debug a SQL query in Magento"
date: 2010-09-11 02:22
comments: true
categories: [PHP]
alias: "/99/debug-a-sql-query-in-magento"
---

Magento offers a powerful built-in DBA layer ( proudly powered by the Zend Framework ) and a set of custom API to perform basic actions in Magento's way.
<!-- more -->

Using `Zend_Db_Select` is simple to debug a bad smell in your SQL, but with Magento's APIs?

There is a very simple solution, when we talk about, for example, the collections.

Look at this example:

``` php
<?php

$collection = Mage::getModel('catalog/category')->getCollection()
->addAttributeToSelect('name', '%');
```

Seems like we're trying to get a list of ALL categories with MySQL wildcard ( stop just a second: this example is silly, is just to make you understand ) but, printint the $collection, we don't get a single category.

Ok, it's time to see why our SQL is failing:

``` php
<?php

echo $collection->getSelect();
```

Nothing more.

Just to be clear: if you want to run a query conditional in Magento you must use `->addAttributeToFilter('name', array('like' => '$likeValue'))`.

Note, wildcards are not automatically inserted; so, for example, your `$likeValue` might look like `%myLikeValue` instead of `myLikeValue`.

About `getSelect()`: it is a very powerful method because it lets you switch between Magento SQL APIs and ZF's ones.
So after having described your `getCollection()` ( magento ) you can call the `getSelect()` and add a `where()` ( Zend Framework ).
