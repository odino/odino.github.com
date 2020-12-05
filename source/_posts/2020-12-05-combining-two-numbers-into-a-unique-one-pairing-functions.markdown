---
layout: post
title: "Combining two numbers into a unique one: pairing functions"
date: 2020-12-05 10:08
comments: true
categories: [math, compression]
description: How to combine 2 numbers into a single one, and be able to reverse this operation? Cantor and elegant pairing to the rescue!
---

Over the past couple of years I've grown my interest in image and data compression
-- it's a very interesting field, with a lot of interesting solutions to important
and lucrative problems (think Dropbox).

Over the past few days I was running some experiments and bumped into an interesting
concept: pairing positive integers into a "unique" number, with the ability to reverse
the operation. 

Now, in the context of compression, pairing would only be useful when
the resulting integer can be consistently represented with less bits 
than the original ones, and that's where I'm still stuck at (more on this on a later post),
but I still wanted to share a couple interesting approaches I've bumped into.

<!-- more -->

## Cantor pairing

The folks at [Wolfram](https://www.wolfram.com/) ask a very interesting question:

> We all know that every point on a surface can be described by a pair of coordinates, but can
every point on a surface be described by only one coordinate?

And it actually turns out that the german mathematician [Georg Cantor](https://en.wikipedia.org/wiki/Georg_Cantor)
had already develop a system to do exactly what we've been talking about, called
"[cantor pairing](https://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function)":

```go
func pair(n, m int) int {
	return (n + m) * (n + m + 1) /2 + m
}

func unpair(z int) (int, int) {
	w := int(math.Floor((math.Sqrt(float64(8 * z + 1)) - 1) / 2))
	t := (w * w + w) / 2
	m := z - t
	n := w - m
	return n, m
}
```

[(code gently found on a random *gist*)](https://gist.github.com/dyoo/8062270)

If you don't believe me, you can take a peek at this [runnable snippet that
illustrates cantor pairing in action](https://play.golang.org/p/wmvDNC2zEIx).

## Elegant pairing

Now, I eventually bumped into [this presentation from a Wolfram conference](http://szudzik.com/ElegantPairing.pdf)
15 years ago, and found another approach, which they call "elegant pairing",
which seems to be a lot more straightforward, at least in terms of the algorithm's
readability:

```go
func pair(n, m int) int {
	if n >= m {
		return n * n + n + m
	}

	return m * m + n
}

func unpair(z int) (int, int) {
	q := int(math.Floor(math.Sqrt(float64(z))))
    l := z - q * q
    
	if l < q {
		return l, q
	}

	return q, l - q
}
```

Again, we can [take a look at this in action on the Go playground](https://play.golang.org/p/u3mwn-o613X).

## So, what about compression?

Well, I won't go too deep into the realm of my thoughts so I'll keep this
real simple: compression is all about communicating the same information,
but with less characters. When you say "jk" you're compressing data ("*just kidding*"),
while the other party involved in the communication understands the "algorithm"
you're using and is able to translate that the 2 characters "jk" effectively
mean "just kidding" (more than compression this is just a hashmap, but let me
have it for the day...).

Images like PNGs are usually just a bunch of pixels put together, with each pixel
represented by R, G, B and A (alpha transparency) values. Each value is represented
by 1 byte, so its maximum value can be [255 at most](https://www.quora.com/What-is-the-highest-number-you-can-get-to-using-1-byte).

Think of an image as:

```js
[
    Pixel(41, 130, 130, 255), // <-- Red: 41, Green: 130, Blue: 130, Alpha: 255
    Pixel(41, 130, 130, 255),
    Pixel(41, 130, 130, 255), 
    Pixel(41, 130, 130, 255), 
    Pixel(41, 130, 130, 255),
    Pixel(41, 130, 130, 255),
    Pixel(41, 130, 130, 255),
    ...
]
```

which can be reduced to:

```js
41,130,130,255
41,130,130,255
41,130,130,255
41,130,130,255
41,130,130,255
41,130,130,255
41,130,130,255
...
```

What's interesting about pairing functions is that we could use
them to combine numbers together to end up with:

```js
16941,65155
16941,65155
16941,65155
16941,65155
16941,65155
16941,65155
16941,65155
...
```

which is, theoretically, less characters than we started with.

Unfortunately for us, the max value one of our pair can have
(255, 255) is 65535, which takes 2 bytes to store, so even if
we end up with less "characters", the number of bytes we need
to use to store them is exactly the same 
(4 * 1 byte earlier, 2 * 2 bytes later) -- so *no bueno*. I've opened
a can of worms that probably deserves its own post later on,
so I'll keep my oversimplification for now and we'll go on with
our lives :)

Adios!