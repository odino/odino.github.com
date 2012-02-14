---
layout: post
title: "Custom pagination on different models with symfony and Doctrine"
date: 2010-10-24 12:03
comments: true
categories: [symfony, Doctrine]
alias: "/224/custom-pagination-on-different-models-with-symfony-and-doctrine"
---

As I [googled](http://www.google.it/search?sourceid=chrome&client=ubuntu&channel=cs&ie=UTF-8&q=sfdoctrinepager+different+models) and [asked](http://groups.google.it/group/symfony-it/browse_thread/thread/bad5cffee14c60fb?hl=it), and nobody could give me a better solution, I post it, conviced that the following code is **pure crap**.
<!-- more -->

## The problem©

I have a cool schema, which uses both *column aggregation* and *concrete table inheritance*, and a simple search engine to develop, which needs to search the field title ( or name ) of every entity, regardless its definition.

This means, for example, that it has to look for the *query* ( Es. "John" ) in the `sfGuardUser` model, matching the name column, and also in the `Post` model, matching the title column.

Worthless to say, I got something like 15 tables: not *that* much, neither a couple.

##Solution: use Lucene

Yes, I know: [Lucene](http://framework.zend.com/manual/en/zend.search.lucene.html) ( or Solr ) would be the best way to do that; but I can't use it as I forced myself not to use Lucene every time I need a search engine that simple. I need to search for a **single word**, in 15 tables, between something like **400 records**.

Lucene would swear at me if I use it for this kinda purposes.

## Solution2: be a column-aggregation-holic

Another time: I can't.

The whole schema has different and various fields so I cannot stand a *full-of-null* record set.

## Solution3: UNIONs

Here's how I "solved" it, with UNIONs and a custom pagination.

[Alex](http://www.alessandrolombardi.com/blog/en), CTO @ DNSEE, said the drawbacks of this approach are justified by the poverty of the SE.

Breaking the concept of **fat models and thin controllers**, I fulfilled my controller with the following code...

### First step: build the UNION

``` php
<?php

$WHERE = "WHERE (title LIKE '%{$this->word}%')"; 

$query = "( 
  SELECT id, title, intro, type, date FROM post $WHERE) 
UNION ( 
  SELECT id, title, description, type, date FROM boats $WHERE) 
UNION ( 
  SELECT id, title, intro, 'harbour', date FROM harbour $WHERE) 
...
...
...
ORDER BY date DESC ";
```

### Execute the query

```php
<?php

$this->items = Doctrine_Manager::getInstance()->getCurrentConnection()->fetchAssoc($query);
```

## Prepare the paginator

``` php
<?php

$count        = count($this->items); 
$page         = ( $request->getParameter('page') - 1 ) . 0; 
$this->items  = array_slice($this->items, $page, $limit); 
$this->pages  = ceil($count / $limit);
```

In the view you will only need to render $items and print the pagination:

``` php
<?php

for($x = 0; $x < $pages; $++)
  ...
  ...
```
