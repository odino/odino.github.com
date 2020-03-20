---
layout: post
title: "Symfony2 routes"
date: 2011-01-09 13:57
comments: true
categories: [symfony2, php]
alias: "/270/symfony2-routes"
---

<!-- more -->

Let's look at two identhical routes, one described in symfony 1.4:

``` yml
post:
    pattern:  /posts/:id
    params:       { module: Blog, action: posts }
    requirements:
      sf_method: [GET, PUT, DELETE]
```

and the other one in Symfony2:

``` yml
post:
    pattern:  /posts/:id
    defaults: { _controller: BlogBundle:Post:posts }
    requirements:
      _method: (GET|PUT|DELETE)
```

as you see there are a few changes, so let's compare them line after line!

##You ain't gonna need the @ anymore

The symfony 1.X routing system was mainly identifying the routes through the `@` prefix.

That was also the way to write faster routes:

``` yml
url_for('post', array('id' => 1)) // slow
url_for('@post?id=1') // fast 
```

With the new routing system you'll be only able to reference the plain route name:

``` php
<?php

// in a controller
$this->generateUrl('post', array('id' => 1);
```

## Effectively working patterns

Once you describe your **routing pattern**, for example:

``` yml
/post/:id
```

Symfony will be able to incapsulate and isolate the request object, the controller and the needed parameters.

No more `sfWebRequest`'s hyper-referencing to get any routing parameter:

``` php
<?php

public function executePost(sfWebRequest $request)
{
  $id = $request->getGetParameter('id');
```

they are directly injected to your action:

``` php
<?php

public function postAction($id)
```

## From YAML to PHP

The localization of the proper action able to handle the matched route is not a params array anymore.

Since Symfony2 introduced multiple controllers per bundle, you need to specify, in one parameter, the bundle, the controller and the action:

``` yml
defaults: { _controller: MyBundle:DefaultController:ActionName }
```

## Internals

As you've seen, there is no *sHell*..ops, **sf prefix** for any internal convention.

For example, when requiring a request method, you need to specify the `_method parameter`, not the `sf_method anymore`.

## Multiple request methods

When dealing with some URLs ( ie. `/posts` ) you want to let the resource being asked with different verbs, such as GET to get the entire posts collection, POST for inserting a new one... etc etc...

In symfony 1.X the methods were described as a YAML array:

``` yml
sf_method: [X, Y, Z]
```

while in Symfony2 you have a slightly different syntax:

``` yml
_method: (X|Y|Z)
```

which banally reminds us the native language statements/operators:

``` yml
if (x || y || z)
```