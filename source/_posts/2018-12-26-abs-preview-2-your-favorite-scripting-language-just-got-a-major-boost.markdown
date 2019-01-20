---
layout: post
title: "ABS preview-2: your favorite scripting language just got a major boost"
date: 2018-12-26 14:25
comments: true
categories: [abs, scripting, programming language, open source]
---

These days I got some spare time to work on the [2nd preview](https://github.com/abs-lang/abs/releases/tag/preview-2)
release of ABS, with loads of interesting features making into this version.

<!-- more -->

Let me quickly run you through the most notable additions:

## Array destructuring

Similar to JS' destructuring, you can now assign multiple
variables based on the elements of an array:

``` bash
[x, y, z] = [1, 2]
x # 1
y # 2
z # null
```

The line before a destructuring statement needs to end
with a `;`, but we'll [fix the parser](https://github.com/abs-lang/abs/issues/83):

``` bash
# This will not work
# as the parser sees `x = "10"[a]`
x = "10"
[a] = [100]

# This is ok
x = "10";
[a] = [100]
```

## Standard input

My personal favorite, you can now capture `stdin` with the
(surprise) `stdin()` function. An asciicast is better than
words:

[![asciicast](https://asciinema.org/a/218451.svg)](https://asciinema.org/a/218451)

Note that you can loop through the `stdin` as well:

```
for x in stdin {
    # Do stuff with x...
}
```

## Floats

Weird that I didn't look into this earlier :)

Floats are now fully supported, and integers have been replaced
with the generic "number", wich represents both integers and floats:

``` bash
1 + 1 # 2
1.2 + 1 # 2.1
type(1) # NUMBER
type(1.1) # NUMBER
```

You can also "convert" a float to integer using `int()`:

``` bash
1.5.int() # 1
```

## Compound assignments & additional operators

These aren't crazy, but weren't there in the first preview of ABS:

```
>=
<=
%
<=>
+=
-=
*=
/=
**=
%=
```

Nothing much to explain here, I'm sure you're familiar with these.
Note that I opted to keep `++` and `--` out of the picture for now
as the complexity of implementing those is, in my opinion, not worth
it since you can simply `x+=1`.

## What now?

Grab the [latest release](https://github.com/abs-lang/abs/releases/tag/preview-2) for your platform,
dump it in your path and start hacking with ABS!

If you're brave enough, just:

``` bash
bash <(curl https://www.abs-lang.org/installer.sh)
```

*(you might need to sudo right before that)*

Cheers!