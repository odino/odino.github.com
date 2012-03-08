---
layout: post
title: "Customizing pagination in symfony"
date: 2010-09-11 14:58
comments: true
categories: [symfony]
alias: "/136/customizing-pagination-in-symfony"
---

Today I had to face a huge drama customizing the way a collection of results had to be displayed in a backend grid, using symfony 1.4.
<!-- more -->

Here's how I managed my problem.

What I specifically needed was the possibility to see, by default, a certain type of content filtered by default fields: in Qredd, a kind of CMS I'm rewriting using Symfony, I've decided not to separate the two entities content and category, so I gave the possibility, to every content, to be an aggregator.

Following this approach I've though to a content manager, which directly gives you the possibility to edit content details ( title, description and so on ) and an aggregator manager ( which gives you the possibility to edit things specifically related to the aggregator property, like type of sorting... ).

So I needed 2 grids, which referred to the same model, but in the first I needed to display all the record in the content table, in the second all the record with the attribute `is_aggregator` equal to 1.

I've created a new module referring to the same model of the "pure" contents, and therefore I was seeing two identical grids.

The paginator is automatically instantiated by the backend cache, so I needed to override the actions of my module.

``` php
<?php

public function executeIndex(sfWebRequest $request)
{
  parent::executeIndex($request);

  $this->pager->getQuery()->where('is_aggregator = ?', 1);
 
  $this->sort = $this->getSort();
}
```

The parent call does all the previous stuff: after that, customizing the query that was retrieving the results was the only thing I needed to do.

If you don't want to call the parent method you only need to basically create the paginator from scratch, specifying the input class:

``` php
<?php

$this->pager = new sfDoctrinePager('myclass',10);
$this->pager->getQuery();
```

Please note I'm using an instance of sfDoctrinePaginator: with Propel the synthax could be a little different
