---
layout: post
title: "ABS 1.3.2: making ABS faster with a simple fix"
date: 2019-06-05 20:36
comments: true
categories: [abs, scripting, programming language, open source]
description: "Version 1.3.2 of ABS addresses a simple yet important performance fix that makes the language orders of magnitute faster under certain circumstances."
---

Hi there! Just a quick post to announce a bugfix release of the ABS programming
language: [1.3.2](https://github.com/abs-lang/abs/releases/tag/1.3.2) fixes a simple yet important performance bug dealing
with short-circuit evaluation.

{% img center /images/abs132.png %}

<!-- more -->

Short-circuiting is the amazing property some languages assign
to boolean operators (eg. `&&` or `||`): if the first parameter
in the expression is sufficient to determine the end value of
the expression, the second value is not evaluated at all.

Take a look at this example:

``` bash
false && sleep(a_really_long_time)
```

You wouldn't expect the script to `sleep` since the first parameter
in the expression is already falsy, thus the expression can never be
truthy.

What about:

``` bash
true || sleep(a_really_long_time)
```

Same thing, easy peasy.

Even more important, short-circuiting can be really useful in order
to access a property when not sure whether it exists:

``` bash
# we don't know whether X is null or what
x && x.property
```

Compare that to what you'd usually have to write:

``` bash
# we don't know whether X is null or what
if x {
    return null
}

return x.property
```

You might be wondering what does all of this have to do with ABS:
well, we were supposed to have fully working short-circuiting but,
as it turns out, there was a bug preventing this from working. Your
code would work and run successfully, but it would always evaluate
all the arguments of an expression, even if it short-circuited. In
some cases (like when using short-circuiting for accessing properties)
your code would crash -- defeating the whole purpose of short-circuiting.

Luckily, [Ming](https://github.com/mingwho) fixed this in [#227](https://github.com/abs-lang/abs/pull/227)
and the fix got backported to the 1.3.x branch: [1.3.2 is served!](https://github.com/abs-lang/abs/releases/tag/1.3.2)

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!