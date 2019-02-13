---
layout: post
title: "ABS 1.1.0 released: more Python and Bash for the most fun programming language out there"
date: 2019-02-13 18:52
comments: true
categories: [abs, scripting, programming language, open source]
description: "A new minor release for ABS (1.1.0), borrowing syntax and features from both bash and python."
---

Fresh new release of the [ABS programming language](https://www.abs-lang.org/),
bringing more syntax you should be familiar with,
inspired both by Bash and Python.

{% img center /images/abs-1.1.0.png %}

This release includes 8 new features and 2 bugfixes, let's
discover them together!

<!-- more -->

## Better membership testing

The membership testing operator, `in`, now
supports finding whether an object has a
particular key as well as it allows to
find substrings in strings:

``` bash
some in {"some": "thing"} # TRUE
some in {} # FALSE

"str" in "string" # TRUE
"hello" in "string" # FALSE
```

With these changes to `in` we are now
deprecating the `set.includes(member)`
function:

``` bash
"string".contains("str")
[1, 2, 3].contains(2)
```

The function will keep working but, again,
is deprecated. We will likely not remove it
from future releases (even major ones) but...
...you're warned!

## 1 ~ 1.1

The similarity operator, `~`, now supports numbers:

```
1 ~ 1.23 # TRUE
1 ~ 0.99 # FALSE
```

Numbers will be similar if their integer conversion
is the same. This is a shorthand for:

```
1.int() == 1.23.int() # TRUE
1.int() ~ 0.99.int() # FALSE
```

## for .. in

We've made a few changes to `for .. in` to make
it more useful, as you can now loop through hashes:

``` bash
for k, v in {"some": "thing"} {
    # k is some 
    # v is thing 
}
```

## More destructuring

We introduced destructuring [before ABS was stable](https://github.com/abs-lang/abs/releases/tag/preview-2),
[updated it right before 1.0](https://github.com/abs-lang/abs/releases/tag/preview-3)
and we've now expanded it to be able to destructure hashes:

``` bash
some, thing = {"some": 1, "thing": 1}
some + thing # 2
```

## Backtick commands

My *absolutely* favorite feature in this release is the ability
to execute commands with the backtick shell syntax:

``` bash
`ls -la`

# previously you could only do
$(ls -la)
```

There are some limitations with the `$()` syntax (namely, a command
needs to be on its own line) that are not there anymore with backticks.
Now you can do things such as:

``` bash
if `somecommand`.ok {
    ...do something...
}

# This is not possible, $() needs its own line
$(somecommand).ok
```

The same interpoltion style available with `$()` is
working with backticks:

```
arg = "-la"
`ls $arg`
```

## sleep(ms)

Well...every language has one!

You can now pause execution of a script by
sleeping for certain amount of milliseconds:

```
echo("This will be printed immediately")
sleep(10000)
echo("This will be printed in 10s")
```

## Hash builtin functions

With this release we've added a bunch of new builtin
functionalities to hashes:

```
hash = {"a": 1, "b": 2, "c": 3}

hash.keys() # ["a", "b", "c"]
hash.values() # [1, 2, 3]
hash.items() # [["a", 1], ["b", 2], ["c", 3]]
hash.pop(a) # hash is now {"b": 2, "c": 3}
```

## NULL comparison

In [ABS 1.0.0](https://github.com/abs-lang/abs/releases/tag/1.0.0)
we introduced a bug that would make NULL comparison fail:

```
null == null # FALSE
```

In 1.2.0 we fixed it (and backported it to [1.0.2](https://github.com/abs-lang/abs/releases/tag/1.0.2)).

## Index assignments

Assigning to the index of an hash / array now works:

```
array = []
array[0] = 1 # array is now [1]
array[5] = 1 # array is now [1, null, null, null, null, 1]

hash = {}
hash.x = 1 # hash is now {"x": 1}
```

## What are you waiting for?

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

PS: Again, many thanks to [Erich](https://github.com/ntwrick), who's been helping me
along the way and has become a crucial member of the
team over the past few weeks. Just want to make sure
his name is mentioned as most of this stuff would not
have been possible without him!

PPS: [1.2.0 is already well underway](https://github.com/abs-lang/abs/milestone/9) -- expect it within
the next 2 to 3 weeks. We'll be introducing extremely
interesting features such as background commands and
REPL history, so it's going to be an exciting release!