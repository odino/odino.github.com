---
layout: post
title: "ABS 1.6.0: the convenience of index ranges and default return values"
date: 2019-08-18 18:15
comments: true
categories: [abs, scripting, programming language, open source]
description: "ABS 1.6 introduces index ranges and default return values (null), two very convenient features."
---

Here we are with a new release of ABS, the elegant programming language
for all of your scripting needs!

{% img center /images/abs-1.6.png %}

Even though small, 1.6 (with [1.6.0](https://github.com/abs-lang/abs/releases/tag/1.6.0)
and [1.6.1](https://github.com/abs-lang/abs/releases/tag/1.6.1)) introduces a
couple interesting features, so let's check them out!

<!-- more -->

## Index ranges

You can now access ranges within strings and arrays by using the
popular `[start:end]` syntax: `[1,2,3,4][0:2]` will return `[1,2]`.

Start and end can be ommitted -- you could simplify the expression
above with `[1,2,3,4][:2]`.

## Default return values

You can now simply use a `return;` at the end of a function, and
it will return the default value `null`:

``` go
fn = f() {
    return;
}

echo(fn())
```

## Deprecation of $(...)

If you've followed ABS since its initial release, chances are you first
used system commands through the `$(command)` syntax: we've now deprecated
it and make sure the documentation reflects the fact that `` `command` ``
is the standard, preferred way to run commands.

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!