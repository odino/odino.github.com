---
layout: post
title: "A disgrace called Yii"
date: 2012-08-03 19:23
comments: true
categories: [PHP]
published: false
---

Since I wanted to clarify one of my
[latest tweets](https://twitter.com/_odino_/status/230567223205457920), here's why you should
really be careful while adopting
a framework like [Yii](http://www.yiiframework.com/).

<!-- more -->

I'm considering the [just released](http://www.yiiframework.com/news/55/yii-php-framework-1-1-11-is-released/)
`1.1.11` version, which came to the public
just a few days back.

## Separation of concerns

Yii doesn't have the minimum SoC that you would expect
from a "*Professional PHP Framework*": if you, for example,
take a look at the new CHttpCacheFilter{% fn_ref 1 %},
you'll notice that it directly manipulates an
[HTTP header](http://www.yiiframework.com/doc/api/1.1/CHttpCacheFilter/) ( `send304Header()` ),
which is a responsability that an HttpResponse
should take care of.

If you want to be more abstract, you can have a class which
just manages HTTP headers, but not different entry-points
to manipulate/process/send the same informations.

## Singletons

## Static-oriented programming

## Poor HTTP support

## Poor hMVC architecture

## Coding standards

Looking at Yii's [coding standards](https://github.com/yiisoft/yii/blob/1.1.11/framework/caching/CCache.php#L103) it's a pure joy:
I'll pay you a beer if you're able to give me
a motivation behind such these choices.

Coding standards are not the only *gotchas*
in the "framework", sometimes you really need
to take a break while facing some
[pieces of code](https://github.com/yiisoft/yii/blob/1.1.11/framework/cli/commands/WebAppCommand.php#L49).

## PSR-0

Yii is so dumb that even though it can work with - and has
[some utilities](http://www.yiiframework.com/doc/guide/1.1/en/extension.integration) to implement - the PSR-0, it just
[ignores it](https://github.com/yiisoft/yii/blob/1.1.11/framework/caching/CFileCache.php#L27).

The most scary thing, while going through the
documentation, it's reading lines like this:

{% blockquote Yii guide http://www.yiiframework.com/doc/guide/1.1/en/extension.integration Using 3rd-Party Libraries %}
Because all Yii classes are prefixed with letter C, it is less likely class naming issue would occur
{% endblockquote %}

Here it seems that in 2012, having a prefix on every class name is still considered cool. Poor PHP 5.3.

## Other emotions

Taking a look at the code, I've found a few places
where [directory separators](https://github.com/yiisoft/yii/blob/1.1.11/framework/cli/commands/WebAppCommand.php#L107)
are completely ignored: I wonder if they just dropped
the support for Windows or have some kind of fallbacks.

Another greates thing is the `getRestParams()` method,
available in the `CHttpRequest` class:

``` php https://github.com/yiisoft/yii/blob/1.1.11/framework/web/CHttpRequest.php#L233
<?php

/**
 * Returns the PUT or DELETE request parameters.
 * @return array the request parameters
 * @since 1.1.7
 */
protected function getRestParams()
{
	$result=array();
	if(function_exists('mb_parse_str'))
		mb_parse_str(file_get_contents('php://input'), $result);
	else
		parse_str(file_get_contents('php://input'), $result);
	return $result;
}
```

This is a great example of how ignorant you can
be without anyone noticing it.

A brief list:

* it's called **REST**
* REST doesn't mean [using PUT or DELETE](/rest-better-common-pitfalls/)
* a method which retrieves parameters regardless of the HTTP method used
it's 100% against REST itself, since one of the key points of REST is
taking advantage of a uniform interface ( HTTP ), using its semantic ( like HTTP methods )

## All in all

{% footnotes %}
	{% fn I suppose filters are kind of a crappy implementation of event dispatching/filtering %}
{% endfootnotes %}