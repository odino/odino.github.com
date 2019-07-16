---
layout: post
title: "ABS 1.5.0: file writers have landed!"
date: 2019-07-16 19:00
comments: true
categories: [abs, scripting, programming language, open source]
description: "A new minor release for ABS (1.5.0): time for file writers, break/continue and a few minor additions."
---

A few hours ago I released a new minor version of the ABS programming
language, [1.5.0](https://github.com/abs-lang/abs/releases/tag/1.5.0),
which includes a couple of interesting features -- let's get to them!

{% img center /images/abs-15-intro.png %}

<!-- more -->

## File writers

Probably one of the most exciting things coming out of this release
are file writers: `>` and `>>`.

``` go
for x in 1..3 {
    x >> "file.txt"
}

`cat file.txt` // 1\n2\n3

for x in 1..3 {
    x > "file.txt"
}

`cat file.txt` // 3
```

These operators work as file writers when both the left and right
arguments are strings, and proceed to either truncate and write
(`>`) or append (`>>`).

## [].unique()

Arrays now have a `.unique()` method, used to filter out
duplicated elements:

``` go
[1, 2, 2, 3].unique() // [1, 2, 3]
```

An element is considered duplicate if both its type and string
representation match:

``` go
[1, "1", 2, 2].unique() // [1, "1", 2]
```

For example, different hashes with the same content are
considered duplicates:

``` go
a = {"key": "value"}
b = {"key": "value"}
[a, b].unique() // [{"key": "value"}]
```

## Break and continue in for loops

We finally implemented `break` and `continue`
within for loops: earlier on you could use `return`
to exit a loop but it always felt a tad awkward --
with this release this has been fixed.

``` go
x = 0

for v in 1..10 {
    if v < 10 {
        continue
    }

    x += v
}

x // 10

for v in 1..10 {
    if v > 1 {
        break
    }

    x += v
}

x // 11
```

## for..in stackoverflow

We also fixed a bug that resulted in a stack overflow when looping
a high number of times in a `for..in` loop:

``` bash
$ for x in 1..10_000_000 { 1 & 2 }
runtime: goroutine stack exceeds 1000000000-byte limit
fatal error: stack overflow
```

This has been fixed. As a bonus point, `for..in` loops are
also significantly faster with this change (especially noticeable
on larger loops, at around 30% faster):

``` bash
$ cat for-benchmark.abs 
start = `echo $(($(date +%s%N)/1000000))`
for x in 1..1_000_000 { 1 & 2 }
end = `echo $(($(date +%s%N)/1000000))`
echo(end.int() - start.int())

$ abs1.4 for-benchmark.abs         
820
$ abs1.5 for-benchmark.abs
546
```

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!