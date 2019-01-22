---
layout: post
title: "ABS preview-4: as the language matures, the features keep coming!"
date: 2019-01-22 18:18
comments: true
categories: [abs, scripting, programming language, open source]
---

Thanks to [a few contributions](https://github.com/abs-lang/abs/graphs/contributors),
I got around to releasing another preview of ABS, the dynamic and modern
language for shell scripting.

<!-- more -->

First and foremost: a huge *thank you* to [nicerobot](https://github.com/nicerobot)
and [ntwrick](https://github.com/ntwrick) who managed to take a crack at some of
the pain points I didn't manage to have a look at myself -- their contributions
added some interesting features to the language and I can only hope they'll keep
coming!

Let's now run throgh the most notable changes in this new release.

## Features

The most important "feature" of this release is the ability, for ABS, to help
you locate parsing and execution errors by pin-pointing the code that causes
the error, including the line and column number:

```
$ cat tests/test-eval.abs 
# eval fails

test_num = int(arg(2))

if test_num == 1 {
    # mismatched type
    s = "string"
    s = s + 1   # this is a comment
}

if test_num == 2 {
    # invalid property
    a = [1,2,3]
    a.junk
}

if test_num == 3 {
    # invalid function as index
    {"name": "Abs"}[f(x) {x}];  
}

$ abs tests/test-eval.abs 1
ERROR: type mismatch: STRING + NUMBER
	[8:11]	    s = s + 1   # this is a comment

$ abs tests/test-eval.abs 2
ERROR: invalid property 'junk' on type ARRAY
	[14:6]	    a.junk

$ abs tests/test-eval.abs 3
ERROR: index operator not supported: f(x) {x} on HASH
	[19:20]	    {"name": "Abs"}[f(x) {x}];
```

You can now also access command line flags passed to your script
with the `flag(...)` function:

``` bash
$ abs --foo=1 --bar 2 --baz
Hello user, welcome to the ABS (preview-4) programming language!
Type 'quit' when you're done, 'help' if you get lost!
⧐  flag("foo")
1
⧐  flag("bar")
2
⧐  flag("baz")
true
⧐  
```

Other small additions:

* both single (`'hello'`) and double (`"hello"`) quotes are supported in strings,
allowing for an easier syntax when you need quotes in your string (`"She said 'hello!'"`)
* added `"string".is_number()`
* ABS will now output its version when called with the `--version` argument alone (`abs --version`)

## Bugfixes

* shell commands [wouldn't receive the stdin](https://github.com/abs-lang/abs/pull/113) passed to the abs interpreter
* you [could not loop more than once over an array](https://github.com/abs-lang/abs/issues/112) when using the `for ... in` syntax

## What are you waiting for?

Grab the [latest release](https://github.com/abs-lang/abs/releases/tag/preview-4) for your platform,
dump it in your path and start hacking with ABS!

If you're brave enough, just:

``` bash
bash <(curl https://www.abs-lang.org/installer.sh)
```

Adios!