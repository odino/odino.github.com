---
layout: post
title: "ABS 1.0.0: here we go!"
date: 2019-01-26 16:21
comments: true
categories: [abs, scripting, programming language, open source]
description: "We just released the first stable version of the ABS language."
---

Eventually, the time has come: [ABS 1.0.0 is finally out](https://github.com/abs-lang/abs/releases/tag/1.0.0)!

{% img center /images/abs-horizontal.png %}

This wraps up weeks of work since I started the project a
little over a month ago, and gives you a fairly stable
release with all of the "must" features I originally
wanted to introduce in the language.

<!-- more -->

## About this release

There are 5 major talking point in this release
(which I will go through in the next paragraphs),
but I want to start by saying that ABS is now leaving
the `preview-x` versioning scheme and committing to
semantic versioning.

{% pullquote %}
I originally didn't want to start by using semantic
versioning as I thought `0.1.0` and similar would spook
users and contributors away, and opted to use the `preview-x`
naming scheme to indicate that we're on our way towards
a stable release, with a few interediate previews to give
users a taste of ABS as we implement it.

Anyhow, we're now switching to `x.y.z` and will keep using
semantic versioning in order to offer a strong backwards-compatibility
promise. {" Sticking to a major release means you're going
to be able to apply minor / patch upgrades without even
thinking about it."}

So...enough with the chatter, let's have a look at what's in ABS 1.0.0!
{% endpullquote %}

## New features

We have now added a new operator, `in`, for membership testing ([#128](https://github.com/abs-lang/abs/pull/128)):
`1 in [1,2,3]` will return a boolean (`true` in this case).

Note that you can combine in with whatever other types / operator,
for example:

``` bash
echo("type a number")
n = stdin().number()
return n in 1..10 # true if the user types a number between 1 and 10
```

In addition to the `in` operator, the other new feature introduced in
this version is `else if` ([#27](https://github.com/abs-lang/abs/issues/27)):
it might seem very trivial, but up until now you could only use `if...else` blocks.

Now you're going to be able to use `if...else if...else` like in any
other programming language:

``` js
if x {
    return x
} else if y {
    return y
} else {
    return z
}
```

## Bug fixes

Two nasty issues were solved within this version:

* you can now call `json()` on strings representing all literal JSON data types:
earlier you weren't able to `'[1, 2, 3]'.json()` as only objects were supported ([#54](https://github.com/abs-lang/abs/issues/54))
* just like in a lot of other major programming languages, ABS strings now support special characters such as `\n`. If you use double quotes these characters will be converted to their ASCII control codes, whereas if you use single quotes the literal `\n` will appear. This is implemented for `\n`, `\r` and `\t` ([#130](https://github.com/abs-lang/abs/pull/130))

``` bash
⧐  [1,2,3].join("\n")
1
2
3
⧐  [1,2,3].join('\n')
1\n2\n3
⧐  
```

## Deprecations

* `[].contains(x)` is now deprecated in favor of the `in` operator, and will be removed in the next major release (`2.0.0`)

## Thanks to...

A big thank you to [Rick](https://github.com/ntwrick) who managed to implement
[#130](https://github.com/abs-lang/abs/pull/130) which was pending for quite
some time.

Without his help, it would have taken a while longer to get 1.0.0 out of the way :)

## What's next?

Ready to increase your productivity with a shell script
that looks modern and simple? Then:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

## Bonus point: what's next for ABS?

We're now going to focus working on 2 releases:

* `1.0.X`, which brings bugfixes to `1.0.0`
* `1.1.X`, which is going to start adding new functionality (have a look at the [roadmap here](https://github.com/abs-lang/abs/milestone/6)):
it's going to be an exciting release as we will be probably introducing functionalities
such as time manipulation as well as parallel commands

Adios!