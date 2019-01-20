---
layout: post
title: "ABS preview-3: loads of bugfixes prior to version 1.0"
date: 2018-12-29 12:43
comments: true
categories: [abs, scripting, programming language, open source]
---

I just released the [preview-3](https://github.com/abs-lang/abs/releases/tag/preview-3) version of [ABS](https://www.abs-lang.org/), a terse, pragmatic
scripting alternative to Bash. This release is geared towards
cleaning up bugs before [1.0](https://github.com/abs-lang/abs/milestone/5), so I thought I'd spend some time
going through the changes.

<!-- more -->

## Backward-incompatible changes

We got 1 of them!

I first thought of implementing array destructuring with the
very same syntax JavaScript uses:

``` js
[x, y] = [1, 2]
```

but this created a few issues with ABS' parser. For example,
when executing code such as:

``` bash
x = 10
[y] = [1]
```

the parser would see `x = 10[y]`, and throw a truckload of 
errors. A simple fix was to add a semicolon on the line
right before a destructuring statement:

``` bash
x = 10;
[y] = [1]
```

Now, considering I had to fix this as well as the fact that
I'm always aiming to keep the language as terse as possible,
I took some inspiration from Ruby and refactored destructuring
to resemble [Ruby's multiple assignments](https://nathanhoad.net/ruby-multiple-assignment).

In order to destructure an array, you will now have to:

``` js
x, y = [1, 2]
```

Easy peasy, with the added bonus of less typing!

## Features

Only 1 new feature in this release of ABS: bitwise operators.

``` bash
$ abs
Hello alex, welcome to the ABS programming language!
Type 'quit' when you're done, 'help' if you get lost!
⧐  1 & 0
0
⧐  1 ^ 0
1
⧐  1 | 0
1
⧐  1 >> 0
1
⧐  1 << 0
1
⧐  ~1
-2
⧐  
```

## Bugfixes

Here's where the bulk of changes happened:

* `null` is now an "assignable" value. Earlier on, you couldn't `x = null`, which resulted in funny behaviors such as [#85](https://github.com/abs-lang/abs/issues/85)
* numbers are not following scientific notation: for very large numbers, the formatter used to convert them to something like `1e+06`. This has been now fixed.
* fixed a panic when using `.map(...)` without return values ([#62](https://github.com/abs-lang/abs/issues/62))
* fixed a panic when calling functions without enough arguments ([#61](https://github.com/abs-lang/abs/issues/61))
* beautified a panic when trying to execute a script that does not exist ([#77](https://github.com/abs-lang/abs/issues/77))
* beautified a panic when trying to execute `.sum()` on an array with elements other than numbers ([#75](https://github.com/abs-lang/abs/issues/75))
* fixed error handling in `.map()` and `.filter()` ([#80](https://github.com/abs-lang/abs/issues/80))
* fixed script halting when there was an error in a while block ([#82](https://github.com/abs-lang/abs/issues/82))
* added `\r` and `\f` as a separator for `.lines()`
* strengthened the command parser ([#78](https://github.com/abs-lang/abs/issues/78))
* fixed shell command escaping ([#81](https://github.com/abs-lang/abs/issues/81))
* destructuring statements do not need a `;` on the preceding line anymore ([#83](https://github.com/abs-lang/abs/issues/83))

## In other news...

Travis-ci [recently launched](https://blog.travis-ci.com/2018-10-11-windows-early-release) Windows builds,
so I took the opportunity to configure ABS' builds on Linux, OSX and Windows ([#88](https://github.com/abs-lang/abs/issues/88)).

## What next?

Ever hoped a bash script could look like:

``` bash
# Ask the user what is the best city in the world!
echo("What is the best city in the world?")
selection = stdin()

echo("You picked %s", selection)

tz = $(cat /etc/timezone)
continent, city = tz.split("/")

if selection == city {
    echo("You might be biased...")
} else {
    echo("You know, I heard %s is a nice place as well...", city)
}

# $ abs script.abs
# What is the best city in the world?
# "New York"
# You picked New York
# You know, I heard Rome is a nice place as well...
```

Hope no more! Simply

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

and start hacking like it's 2018!