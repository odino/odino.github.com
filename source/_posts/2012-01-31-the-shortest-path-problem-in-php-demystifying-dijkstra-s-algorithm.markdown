---
layout: post
title: "The shortest path problem in PHP demystifying Dijkstra-s algorithm"
date: 2011-09-06 02:14
comments: true
categories: [PHP, algorithms]
alias: "/379/the-shortest-path-problem-in-php-demystifying-dijkstra-s-algorithm"
---

After a very long, but intensive, night, I'm happy to announce that [Orient](https://github.com/congow/Orient), the PHP library used to work with [OrientDB](http://www.orientechnologies.com/orient-db.htm), has integrated an interesting feature, an implementation of [Dijkstra's algorithm](http://en.wikipedia.org/wiki/Dijkstra's_algorithm).
<!-- more -->

First of all, let me tell you that, as a pretty new implementation, I'm pretty sure a couple bugs will be spotted in the next days; second, the design of the algorithm and the entities connected to it could probably be better, so I recommend you to just take a look at the final result, 'cause the internals will probably change a bit.

## The problem

Given the following graph:

{% img center /images/graph-sp.png %}

how do you calculate the **best way to reach Tokio from Rome**?

Ok, that's easy, you can count with your mind when you have such a small dataset:

{% img center /images/graph-sp.png %}

and as you probably already know, the simplest solution is to fly from Rome to Amsterdam To LA to Tokio: the distance is 13 (hours? 13k miles? No matter now).

(You can also reach Amsterdam via Paris, but we don't care for the aim of this post)

## The dataset grows... enter Orient

But as your dataset grows, you need to automate the process of **finding shortest paths**.

Just install Orient:

``` bash
git clone git@github.com:congow/Orient.git
```

and create your `path.php` script, which should use the [PSR-0](https://gist.github.com/221634) autoloader:

``` php
<?php

$classLoader = new SplClassLoader('Congow\Orient', __DIR__ . "/Orient/src");
$classLoader->register();

use Congow\Orient\Graph;
use Congow\Orient\Graph\Vertex;
use Congow\Orient\Algorithm; 
```

At this point you might think that the algorithm's implementation is pretty coupled with the rest of the library we're developing, and you would be terribly wrong.

Take a look on how to create the graph

``` php
<?php

$graph = new Graph();
```

how to create vertices

``` php
<?php

$rome      = new Vertex('Rome');
$paris     = new Vertex('Paris');
$london    = new Vertex('London');
$amsterdam = new Vertex('Amsterdam');
$ny        = new Vertex('New York');
$la        = new Vertex('Los Angeles');
$tokio     = new Vertex('Tokio');
```

and how to connect vertices between themselves:

``` php
<?php

$rome->connect($paris, 2);
$rome->connect($london, 3);
$rome->connect($amsterdam, 3);
$paris->connect($london, 1);
$paris->connect($amsterdam, 1);
$london->connect($ny, 10);
$amsterdam->connect($la, 8);
$la->connect($tokio, 2);
$ny->connect($tokio, 3);
```

final step, add the vertices to the graph:

``` php
<?php

$graph->add($rome);
$graph->add($paris);
$graph->add($london);
$graph->add($amsterdam);
$graph->add($ny);
$graph->add($la);
$graph->add($tokio);
```

So, you have basically created some fixtures ( a fake graph, the one of the pictures above ), and we can finally calculate the shortest path from Rome to Tokio:

``` php
<?php

$algorithm = new Algorithm\Dijkstra($graph);
$algorithm->setStartingVertex($rome);
$algorithm->setEndingVertex($tokio);
 
echo $algorithm->getLiteralShortestPath() . ": distance " . $algorithm->getDistance();
// the real method to get the SP is $algorithm->solve(), the ones used above are for printing a nice result 
```

which will output:

``` bash
Rome - Amsterdam - Los Angeles - Tokio : distance 13
```

If you have suggestions and questions, feel free to ask everything here; also, if you spot a bug, pull requests are welcome.
