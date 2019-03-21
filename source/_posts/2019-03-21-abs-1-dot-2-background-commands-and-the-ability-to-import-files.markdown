---
layout: post
title: "ABS 1.2: background commands &amp; the ability to import files"
date: 2019-03-21 05:50
comments: true
categories: [abs, scripting, programming language, open source]
description: "A new minor release for ABS (1.2.0): time for background commands and external imports!"
---

A few weeks ago the ABS team managed to pull together
a new minor release of the language, [1.2.0](https://github.com/abs-lang/abs/releases/tag/1.2.0),
which includes loads of interesting features -- let's get to them!

{% img center /images/abs-12-intro.png %}

<!-- more -->

## ~/.absrc

ABS will now look for a default `~/.absrc` file to preload
everytime you run a script: this is especially useful if you'd
like to dump "base" functions you're likely to re-use across
scripts in a common place. Your `.absrc` could look like:

``` bash
tenth = f(x) {
    return x / 10
}
```

so that in any other abs script you can `tenth(x)`.

## ~/.abs_history

We also introduced an history file in order to be able to
repeat commands easily when using the ABS repl: this is, by default,
located at `~/.abs_history` and gets synced every time you close
a repl session:

``` bash
$ abs
Hello alex, welcome to the ABS (1.2.0) programming language!
Type 'quit' when you're done, 'help' if you get lost!
⧐  `sleep 1`

⧐  quit
Adios!
$ tail ~/.abs_history 
`sleep 1`
```

## require(file)

A big one here: you can now **require external files** through `require(path/to/file.abs  )`.
This is a stepping stone in order to allow creating base libraries that can be re-used
across ABS scripts, and organize ABS code a tad better. 

## Background commands

Another big feature here: you can now issue "background" commands that won't block
your ABS script (these commands are executed within a [Goroutine](https://tour.golang.org/concurrency/1)).

A background command differs from a regular one simply because it employs
an `&` at the end of the command itself -- let's see them in action:

``` bash
`sleep 10`
echo("Hello world!") # This will be printed after 10s

`sleep 10 &`
echo("Hello world!") # This will be printed immediately
```

You can check whether a background command is done with the `.done` property:

``` bash
cmd = `sleep 10 &`
cmd.done # false
wait(10000)
cmd.done # true
```

and we've added the `wait()` function if you need to block until
the command is done:

``` bash
cmd = `sleep 10 &`
cmd.wait() # The script will be blocked for 10s
echo("Hello world!")
```

## Misc

A few more features that made it into this release:

* number functions such as `floor`, `round` and `ceil`
* `cd()`, which switches the `cwd` of a script
* you can play around with your prompt by setting the environment variables `ABS_PROMPT_LIVE_PREFIX=true` and `ABS_PROMPT_PREFIX=templated_string`. The templated string can use `{dir}`, `{user}`, `{host}` that will be replaced on-the-fly. For further info, have a look at the sample [.absrc](https://github.com/abs-lang/abs/blob/d1e92899ed0d6b3abb7a0a3fc6ec18d13dbe3ff2/tests/test-absrc.abs) file

## Bugfixes

As usual, we managed to fix some minor bugs along the way:

* fixed a few random panics when calling built-in functions without enough arguments ([#193](https://github.com/abs-lang/abs/pull/193))
* windows commands are now using cmd.exe rather than bash, as bash might not be available on the system ([#180](https://github.com/abs-lang/abs/pull/180))
* better error messages when parsing "invalid" numbers ([#182](https://github.com/abs-lang/abs/pull/182))
* the ABS installer was not working with wget 1.20.1 ([#178](https://github.com/abs-lang/abs/pull/178))
* the ABS parser now supports numbers in scientific notation (eg. 8.366100560806463e-7, [#174](https://github.com/abs-lang/abs/pull/174))
* errors on built-in functions would not report the correct error line / column numbers ([#168](https://github.com/abs-lang/abs/pull/168))

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

PS: Again, many thanks to [Erich](https://github.com/ntwrick),
who's been taking a larger role as the weeks went by. Without him,
many of the stuff included in 1.2 wouldn't be possible!

PPS: [1.3.0 is already well underway](https://github.com/abs-lang/abs/milestone/10) -- expect
it at some point in April. We'll be introducing extremely
interesting features such as the ability to kill background commands,
so it's going to be an exciting release!
