---
layout: post
title: "ABS 1.7.0: ctrl+r and other optimizations"
date: 2019-08-30 19:15
comments: true
categories: [abs, scripting, programming language, open source]
description: "ABS 1.7 introduces reverse search in the REPL as well as some syntactic sugar."
---

A few days ago I released a new minor version of the ABS
programming language, [1.7.0](https://github.com/abs-lang/abs/releases/tag/1.7.0),
which adds some syntactic sugar as well as improvments to
the REPL -- let's get to them!

{% img center /images/abs-1.7.png %}

<!-- more -->

## Reverse search in the REPL through ctrl+r

You can type something in the REPL and, by pressing
`ctrl+r`, ABS will try to find the last command that
was executed that matches what you typed.

See it in action:

[![asciicast](https://asciinema.org/a/0yT7ZRCeIwGAYNRg5hmoykyoe.svg)](https://asciinema.org/a/0yT7ZRCeIwGAYNRg5hmoykyoe)

If you press `ctrl+r` multiple times, the REPL will
walk its way back into the history to find the previous
command matching your input, until it reaches the end
of the history.

This feature has been implemented thanks to some improvements
in [go-prompt](https://github.com/c-bata/go-prompt), so hats off to
[Masashi Shibata](https://github.com/c-bata) for helping out!

## Number abbreviations

Easily my favorite, this feature allows you to append a suffix to a
number in order to specify the "order of magnitude" of the number itself.
Confused? It's actually quite simple:

``` bash
1k # 1000 - thousand
1m # 1000000 - million
1b # 1000000000 - billion
1t # 1000000000000 - trillion
```

Suffixes are case-insensitive, so you can express `1000000`
with either `1m` or `1M`.

## Improvements to some builtin functions

We've decided to ease using some of the standard functions:
you can now, for example, print a message before exiting
a script directly through the `exit` function.

Your code would have previously looked like:

``` go
if err {
    echo("an error occurred, goodbye!")
    exit(1)
}
```

while now you can simply do:

``` go
if err {
    exit(1, "an error occurred, goodbye!")
}
```

Similarly, we made it easier to use the `replace` function on
strings: you can now omit the last argument (number of replacements),
with its default value being `-1` (no limit):

``` bash
"aaa".replace("a", "b", -1) # "bbb"

# is now the same as

"aaa".replace("a", "b") # "bbb"
```

and you can now also specify a list of characters to replace:

``` bash
"a_0".replace(["a", "_", "0"], "b") # "bbb"
```

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!