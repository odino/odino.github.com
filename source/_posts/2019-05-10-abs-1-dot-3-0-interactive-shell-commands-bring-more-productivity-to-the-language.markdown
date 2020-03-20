---
layout: post
title: "ABS 1.3.0: interactive shell commands bring more productivity to the language"
date: 2019-05-12 18.16
comments: true
categories: [abs, scripting, programming language, open source]
description: "A new minor release for ABS (1.3.0): time for interactive commands!"
---

A couple weeks ago the ABS team managed to pull together
a new minor release of the language, [1.3.0](https://github.com/abs-lang/abs/releases/tag/1.3.0).
This new release only adds 2 new features, but we believe
one of them (interactive commands) is money!

{% img center /images/abs-13-intro.png %}

<!-- more -->

## Interactive commands via exec(...)

Interactive commands allow you throw the user into their
preferred shell while running an ABS script (even within
the ABS repl).

An asciinema is worth a thousand words:

[![asciicast](https://asciinema.org/a/ZVMEJ59cuhbZPfOkcVOE2ocfw.svg)](https://asciinema.org/a/ZVMEJ59cuhbZPfOkcVOE2ocfw)

The syntax is very simple: just call the `exec` function with the
command you want to run as the only argument, such as
`exec("vi /etc/hosts")`. IO is left to the user so ABS will
not try to meddle with that -- it's all yours!

## for...else

We added the ability to specify an `else` block
in a `for` loop!

This feature is [inspired by the
jinja template engine](http://jinja.pocoo.org/docs/2.10/templates/#for) and allows to run code
when the list you're iterating over is empty:

``` bash
for x in flag("test").split(",").filter(f(e) { e.int() != 1 }) {
    echo(x)
} else {
    echo("No elements provided")
}

# $ abs script.abs --test 1,2,3,4
2
3
4

# $abs script.abs --test 1,1,1,1
No elements provided
```

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

PS: Again, many thanks to [Erich](https://github.com/ntwrick),
who's been taking a larger role as the weeks have gone by -- interactive
commands were his idea, and he took care of implementing them from A
to the Z!

I would also like to thank [Ming](https://github.com/mingwho)
who already helped ABS with a few contributions in the past,
and was responsible for `for...else` in this release!

See you next time!