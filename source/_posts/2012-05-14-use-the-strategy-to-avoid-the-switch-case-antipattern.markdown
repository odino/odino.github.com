---
layout: post
title: "Use the Strategy to avoid the Switch-Case antipattern"
date: 2012-05-14 00:28
comments: true
categories: [design patterns, refactoring]
---

In PHP we have tons of bad constructs/functions that don't actually
help newcomers on writing good code: the `SWITCH/CASE` statement is one
of those that I hate the most, although very few developers rely on
it.
<!-- more -->

The statement is pretty straightfoward

``` php Simple SWITCH/CASE statement
<?php

class Logger
{
	public function logMessage($message = "CRITICAL::The system encountered a problem")
	{
		$parts = explode('::', $message);
		$level = $parts[0];

		switch ($var) {
		    case 'notice':
		        ...
		        break;
		    case 'critical':
		        ...
		        break;
		    case 'catastrophe':
		        ...
		        break;
		}
	}
```

and is intended to make multiple IFs more readable.

It may seem useful, but at first you should recognize that **multiple
IFs are already a bad smell**, so, from the beginning there is something
with a code trying to make them look nicer.

The [Strategy pattern](http://en.wikipedia.org/wiki/Strategy_pattern),
one of my favourites, is a simple but powerful way to avoid writing
procedural code that relies on IFs.

The main concept is that you should contextualize the application's
workflow at runtime, deciding which steps (methods) to run based on
data which is external to the method itself.

``` php silly implementation of Strategy
<?php

class Logger
{
	public function logMessage($message = "CRITICAL::The system encountered a problem")
	{
		$parts 	= explode('::', $message);
		$level 	= $parts[0];
		$method = sprintf('log%sMessage', ucfirst($level));
		$output = $this->$method($parts[1]);
	}

```

In this way we are able to isolate and keep clean the implementations
of the methods, thus the logic behind the application.

This means that we only need to implement submethods:

``` php
<?php

public function logNoticeMessage($message);

public function logCriticalMessage($message);

public function logCatastropheMessage($message);
```

If this doesn't seem important to you, consider this scenario:
you are shipping a library with the `SWITCH/CASE` in the first example;
what would happen if another developer using that library would only
like to edit the logic when a `catastrophe` message is received?

Yes, he would need to override the entire `logMessage` method,
**loosing the possibility to benefit of future software updates**
for that specific method.