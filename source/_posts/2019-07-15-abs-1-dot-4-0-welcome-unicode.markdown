---
layout: post
title: "ABS 1.4.0: welcome unicode!"
date: 2019-07-15 19:00
comments: true
categories: [abs, scripting, programming language, open source]
description: "A few weeks ago we released ABS 1.4.0, which brings unicode, a few more features and some bugfixes to the language."
---

A few weeks ago I released version 1.4.0 (and 1.4.1, with an additional bugfix)
of the ABS programming language: in this post, I'd like to explain everything
major that made it in this new minor release.

{% img center /images/abs-1.4.png %}

<!-- more -->

## ABS ❤ unicode

We have implemented unicode in ABS: you can now use both
unicode letters in variable names as well as any
unicode character in strings.

For example, you can output any code point within a string:

``` go
echo("I ❤ ABS")
echo("Hello 世界!")
```

as well as use [unicode letters](https://www.compart.com/en/unicode/category) in variable names:

``` go
ȼ = "this is a weird c"
echo(ȼ) // "this is a weird c"
```

Note that only unicode letters (category `L`) are allowed as variable
names, and using any other character will result in a parsing error:

``` go
⧐  ❤ = a
 parser errors:
	Illegal token '❤'
	[1:1]	❤ = a
```

## eval(...)

Oh, good old-school `eval`!

This function does exactly what you'd expect it to do, as it executes
the ABS code passed as its argument:

``` go
test = [1, 2, 3, 4]
eval("test.len()") // 4
eval("test.len()").type() // NUMBER
```

## Digits in variable names

We now support digits in variable names:

``` go
v4r14bl3 = "I got numbers"
```

We might expand this feature later on to include unicode numbers,
if the community feels like this would be a useful feature (haven't
heard of any use case so far).

## Numeric separators

Following [Python 3.6](https://www.python.org/dev/peps/pep-0515/)
and [JS on Chrome 75](https://github.com/tc39/proposal-numeric-separator),
we've decided to help with readability on large numbers and allow
`_` as a numeric separator:

``` go
// before
ten_grands  = 10000
ten_yards   = 10000000

// now you can...
ten_grands  = 10_000
ten_yards   = 10_000_000
```

## Panic without a terminal

We fixed a panic when you try to run the ABS REPL without
having a terminal attached (for example, during a Docker
build, or when piping a bare `abs` command); ABS will now
explicitely let you know what the problem is:

```
$ abs > file.txt

$ echo $?
1

$ cat file.txt 
Hello alex, welcome to the ABS (1.4.1) programming language!
Type 'quit' when you're done, 'help' if you get lost!
unable to start the ABS repl (no terminal detected)
```

## Panic when converting empty strings to JSON

We fixed a pnic when trying to convert an empty string
to JSON, which will now convert to an empty string:

``` go
"".json() // ""
```

## Fixes to JSON conversion of hashes

You can easily convert an hash to JSON through the
builtin `.str   ()` function:

``` go
$ key = "hello"
$ value = "world"

$ hash = {key: value}

$ hash.str()
{"hello": "world"}
```

There was an issue when converting keys or values with
double quotes in them, but it has since been fixed.
Code such as `'{"x": "\"y"}'.json().x` will now work
seamlessly.

## Go modules

We've migrated the codebase to [Go modules](https://github.com/golang/go/wiki/Modules):
even though this might not be a ground-breaking change, it should
help those who develop the ABS core, allowing no conflicts when it
comes to dependencies.

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

PS: Again, many thanks to [Ming](https://github.com/mingwho),
who's been taking a larger role as the weeks went by. Without her,
many of the stuff included in 1.4 wouldn't be possible!

PPS: [1.5.0 is already well underway](https://github.com/abs-lang/abs/milestone/12) -- expect
it in the next few days. We'll be introducing extremely
interesting features such as file writers, so it's going
to be an exciting release!