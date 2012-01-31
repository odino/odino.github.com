---
layout: post
title: "Graph in PHP through OrientDB"
date: 2011-04-16 14:11
comments: true
categories: [PHP, OrientDB]
alias: "/328/graph-in-php-through-orientdb"
---

As I [said](http://www.odino.org/327/graph-databases-orientdb-to-the-rescue), Orient has an HTTP interface which you can use to manage and query any DB, document and navigate the graph: since it speaks HTTP...
<!-- more -->

## OrientDB and PHP

So, as you can imagine, liking OrientDB and HTTP brought me and [David](http://www.davidfunaro.com/) writing the [PHP binding for Orient DB](https://github.com/odino/Orient/tree/beta-1): it is a small library ( a couple classes, a couple interfaces ) able to let you manage your database through HTTP and an OO API.

We're still working on it, but it's already usable.

As I'll show you now, **graph in php can be really funny and simple**.

##Friendship traversal in 5 minutes

You have this new super-cocky website which lets the user be friends, share stuff and so on. Just like FaceBook.

So you download orient, start the server and go to `127.0.0.1:2480`, where you can administrate your Orient server via web, through [OrientStudio](http://code.google.com/p/orient/wiki/OrientDB_Studio).

Orient's package comes with a demo DB, so you only need to log in as `admin/admin`.

**Set-up instructions are doable also with PHP, but I think, to be faster and more clear, we should use OrientStudio instead**.

{% img right /images/oeirnt-add-class.png %}

So, now, you only need to create a class, called `fellas`.

A class is similar to a real-world class, like in OO design: so records of the same class share the type and class propertis ( when mandatory: as I said yesterday, classes can be schema-full, *-less, *-mixed ).

As you create the class you should populate it with some records, from the **command tab**:

``` sql
insert into fellas (name) values ('Michelle Obama'); -- our starting point
insert into fellas (name) values ('Barack Obama'); -- Michelle's husband ( =  friend )
insert into fellas (name) values ('Angela Merkel'); -- Barack's friend
insert into fellas (name) values ('Nicolas Sarkozy'); -- Angela's friend
insert into fellas (name) values ('Silvio Berlusconi'); -- friend of no one
```

Note that you'll need to execute insert after insert, as multiple inserts are not supported.

After you created your records you are able to see them: go to the **query tab** and execute

``` sql
select from fellas
```

{% img center /images/orient-select-all.png %}

So you see your records with some attributes:

* `@rid`, the resource identifier of your record: the part before the colon is the ID of the cluster ( a cluster is like a table, gruping all the records of the same class ), the second the ID of the record
* `@version` is the ...well you guessed it: it's auto-magically handled by Orient when you create/update your records
* `@class`
* `name`, which is the property assigned with the INSERT command: remember it has been created on-the fly ( *schema-less* )

Now we just want to connect our fellas:

{% img center /images/undirected.graph.no.cycles.png %}

As you can see, the graph is undirected, with no cycles{% fn_ref 1 %}.

So we have to update our records:

``` sql
update fellas add friends = [Barack @rid] where @rid = [Michelle @rid]
update fellas add friends = [Michelle @rid] where @rid = [Barack @rid]
update fellas add friends = [Barack @rid] where @rid = [Angela @rid]
update fellas add friends = [Angela @rid] where @rid = [Barack @rid]
update fellas add friends = [Nicolas @rid] where @rid = [Angela @rid]
update fellas add friends = [Angela @rid] where @rid = [Nicolas @rid]
```

There we go:

{% img center /images/orient-fellas-with-relationships.png %}

Now, to work with this grah with php, just clone the binding from GitHub; your directory structure should look like:

``` bash
myProject
  |
  Orient/
  |
  fellas.php 
```

where `myProject` is your project route and `fellas.php` the script we want to execute to retrieve Michelle Obama's connections.

First of all we should register an autoloading function in `fellas.php`{% fn_ref 2 %}:

``` php
<?php

spl_autoload_register(function ($className){
    $path = __DIR__ . '/' . str_replace('\\', '/', $className) . '.php';
 
    if (file_exists($path))
    {
      include($path);
    }
  }
);
```

then we need to istantiate the HTTP client for Orient and the binding:

``` php
<?php

$driver = new Orient\Http\Client\Curl();
$orient = new Orient\Foundation\Binding($driver, '127.0.0.1', '2480', 'admin', 'admin', 'demo');
```

after that we can execute our query:

``` php
<?php

$response = $orient->query("select from fellas where any() traverse(0,-1) ( @rid = [Michelle @rid] ) and @rid <> [Michelle @rid]");
```

and output the results:

``` php
<?php

$output = json_decode($response->getBody());
foreach ($output->result as $friend)
{
  var_dump($friend->name);
}
```

{% img left /images/orient-output.png %}

As you will see ( try running the script from the command line or from your localhost ) the output will return all Michelle Obama's connection, **direct and indirect**.

If we modify the query we can return all the connections under a certain depth ( which is determined by the `traverse()` arguments ).

So, in 5 minutes, you should be able to setup and **work with a graph DB from PHP**.

## Under the hood

When you work with an instance of [Binding](https://github.com/odino/Orient/tree/beta-1/Orient/Foundation/Binding.php) almost every public method returns an [HTTP Response](https://github.com/odino/Orient/tree/beta-1/Orient/Http/Response.php), so you basically only need to get the body of the response and `json_decode()` it ( OrientDB works only with the JSON format ).

Once you decoded it, you can parse it as a Std object: if you're not ok working with this kinda stuff don't worry, because...

## Object graph mapper and... Help!

Our library is quite finished: we still need to define better interfaces and polish a few things, but the main functionalities are there, ready to be used.

As soon as we release the first stable version we will start working on a **basic mapper** ( *OGM* sounds cool ) for OrientDB: if you want to help us, don't hesitate, we will certainly need the help of someone from PHP's community.

{% footnotes %}
  {% fn An real-world example of this kind of graph is a simple... tree %}
  {% fn since I'm not an autoloading master, if you have better solutions I'll be pleased to use'em %}
{% endfootnotes %}
