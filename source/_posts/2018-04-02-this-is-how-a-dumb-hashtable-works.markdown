---
layout: post
title: "This is how a (dumb) hashtable works"
date: 2018-04-02 17:27
comments: true
categories: [data structures, computer science, JavaScript]
description: "Let's have a look at how hashtables work and why they're so fast by building one and understanding their inner mechanisms."
published: false
---

{% img right /images/hashtable.png %}

How beautiful is `{}`?

It lets you store values by key, and retrieve them in a very cost-efficient manner
(`O(1)`, more on this later).

In this post I want to implement a very basic hashtable, and have a look at its inner
workings to explain one of the most ingenious ideas in computer science.

<!-- more -->

## The problem

Imagine you're building a new programming language: you start by having pretty
simple types (strings, integers, floats, ...) and then proceed to implement very basic
data structures -- first you come up with the array (`[]`), then comes the hashtable
(otherwise known as dictionary, associative array, hashmap, map and...the list goes on).

Ever wondered how they work? How they're so damn fast?

Well, let's say that JavaScript did not have have `{}` or `new Map()`, and let's
implement our very own `DumbMap`!

## A note on complexity

Before we get the ball rolling, we need to understand how complexity of a function works:
Wikipedia has a good refresher on [computational complexity](https://en.wikipedia.org/wiki/Computational_complexity_theory),
but I'll add a brief explanation for the lazy ones.

Complexity measures how many steps are required by our function -- the fewer steps,
the fastest the execution (also known as "running time").

Let's a look at the following snippet:

``` js
function fn(n, m) {
  return n * m
}
```

The computational complexity (from now simply "complexity") of `fn` is `O(1)`,
meaning that it's constant (you can read this as "*the cost is one*"): no matter
what arguments you pass, the platform that runs this code only has to do one
operation (multiply `n` into `m`). Again, since it's one operation, the cost is
referred as `O(1)`.

Complexity is measured by assuming arguments of your function could have very large values.
Let's look at this example:

``` js
function fn(n, m) {
  let s = 0

  for (i = 0; 0 < 3; i++) {
    s += n * m
  }

  return s
}
```

You would think its complexity is `O(3)`, right?

Again, since complexity is measured in the context of very large arguments,
we tend to "drop" constants and consider `O(3)` the same as `O(1)`. So, even in this case, we would say that the complexity of
`fn` is `O(1)`. No matter what the value of `n` and `m` are, you always end up
doing 3 operations -- which, again, is a constant cost (therefore `O(1)`).

Now this example is a little bit different:

``` js
function fn(n, m) {
  let s = []

  for (i = 0; 0 < n; i++) {
    s.push(m)
  }

  return s
}
```

As you see, we're looping as many times as the value of `n`, which could be in the
millions. In this case we define the complexity of this function as `O(n)`, as you
will need to do as many operations as the value of one of your arguments.

Other examples?

``` js
function fn(n, m) {
  let s = []

  for (i = 0; 0 < 2 * n; i++) {
    s.push(m)
  }

  return s
}
```

This examples loops `2 * n` times, meaning the complexity should be `O(2n)`.
Since we mentioned that constants are "ignored" when calculating the complexity
of a function, this example is also classified as `O(n)`.

One more?

``` js
function fn(n, m) {
  let s = []

  for (i = 0; 0 < n; i++) {
    for (i = 0; 0 < n; i++) {
      s.push(m)
    }
  }

  return s
}
```

Here we are looping over `n` and looping again inside the main loop, meaning the
complexity is "squared" (`n * n`): if `n` is 2, we will run `s.push(m)` 4 times,
if 3 we will run it 9 times, and so on.

In this case, the complexity of the function is referred as `O(n²)`.

One last example?

``` js
function fn(n, m) {
  let s = []

  for (i = 0; 0 < n; i++) {
    s.push(n)
  }

  for (i = 0; 0 < m; i++) {
    s.push(m)
  }

  return s
}
```

In this case we don't have nested loops, but we loop twice over two different arguments:
the complexity is defined as `O(n+m)`. Crystal clear.

Now that you've just got a brief introduction (or refresher) on complexity, it's
very easy to understand that a function with complexity `O(1)` is going to perform
much better than one with `O(n)`.

Hashtables have a `O(1)` complexity: in layman's terms, they're **superfast**.
Let's move on.

## Let's build a (dumb) hashtable

Our hashtable has 2 simple methods -- `set(x, y)` and `get(x)`. Let's start writing
some code:

``` js
class DumbMap {
  get(x) {
    console.log(`get ${x}`)
  }

  set(x, y) {
    console.log(`set ${x} to ${y}`)
  }
}

let m = new DumbMap()

m.set('a', 1) // "set a to 1"
m.get('a') // "get a"
```

ans let's implement a very simple, inefficient way to store these key-value pairs
and retrieve them later on. We first start by storing them in an internal array
(remember, we can't use `{}` since we are implementing `{}` -- mindblown!):

``` js
class DumbMap {
  constructor() {
    this.list = []
  }

  ...

  set(x, y) {
    this.list.push([x, y])
  }
}
```

then it's simply a matter of getting the right element from the list:

``` js
get(x) {
  let result

  this.list.forEach(pairs => {
    if (pairs[0] === x) {
      result = pairs[1]
    }
  })

  return result
}
```

Our full example:

``` js
class DumbMap {
  constructor() {
    this.list = []
  }

  get(x) {
    let result

    this.list.forEach(pairs => {
      if (pairs[0] === x) {
        result = pairs[1]
      }
    })

    return result
  }

  set(x, y) {
    this.list.push([x, y])
  }
}

let m = new DumbMap()

m.set('a', 1)
console.log(m.get('a')) // 1
console.log(m.get('I_DONT_EXIST')) // undefined
```

Our `DumbMap is amazing`! It works right out of the box, but how will it perform when we add a large amount of key-value
pairs?

Let's try a simple benchmark -- we will first try to find a non-existing element
in an hashtable with very few elements, and then try the same in one with a large quantity
of elements:

``` js
let m = new DumbMap()
m.set('x', 1)
m.set('y', 2)

console.time('with very few records in the map')
m.get('I_DONT_EXIST')
console.timeEnd('with very few records in the map')

m = new DumbMap()

for (x = 0; x < 1000000; x++) {
  m.set(`element${x}`, x)
}

console.time('with lots of records in the map')
m.get('I_DONT_EXIST')
console.timeEnd('with lots of records in the map')
```

The results? Not so encouraging:

``` bash
with very few records in the map: 0.118ms
with lots of records in the map: 14.412ms
```

In our implementation, we need to loop through all the elements inside `this.list`
in order to find one with the matching key. The cost is `O(n)`, and it's quite
terrible.

## Make it fast(er)

We need to find a way to avoid looping through our list: time to put *hash*
back into the *hashtable*.

Ever wondered why this data structure is called **hash**table? That's because
a hashing function is used on the keys that you set and get: we will use this
function to turn our key into an integer `i`, and store our value at index `i`
of our internal list. Since accessing an element, by its index, from a list has
a constant cost (`O(1)`), then the hashtable will also have a cost of `O(1)`.

Let's try this out:

``` js
let hash = require('string-hash')

class DumbMap {
  constructor() {
    this.list = []
  }

  get(x) {
    return this.list[hash(x)]
  }

  set(x, y) {
    this.list[hash(x)] = y
  }
}
```

Here we are using the [string-hash](https://www.npmjs.com/package/string-hash)
module which simply converts a string to a numeric hash, and use it to store
and fetch elements at index `hash(key)` of our list. The results?

``` bash
with lots of records in the map: 0.013ms
```

W - O - W. This is what I'm talking about!

We don't have to loop through all elements in the list and retrieving elements
from `DumbMap` is fast as hell!

Let me put this as straightforward as possible: **hashing is what makes hashtables
extremely efficient**. No magic. Nothing more. Nada. Just a simple, clever, ingenious
idea.

## The cost of picking the right hashing function

Of course, **picking a fast hashing function is very important**: if our `hash(key)`
runs in a few seconds, our function will be quite slow regardless of its complexity.

At the same time, **it's very important to make sure that our hashing function doesn't
produce a lot of collisions**, as they would be detrimental to the complexity of our
hashtable.

Confused? Let's take a closer look at collisions.

## Collisions

You might think "*Ah, a good hashing function never generates collisions!*": well,
come back to the real world and think again. [Google was able to produce collisions
for the SHA-1 hashing algorithm](https://security.googleblog.com/2017/02/announcing-first-sha1-collision.html),
and it's just a matter of time, or computational power, before a hashing function
cracks and returns the same hash for 2 different inputs. Always assume your hashing
function generates collisions and implement the right defense against such cases.

Case in point, let's try to use a `hash()` function that generates a lot of collisions:

``` js
function divide(int) {
  int = Math.round(int / 2)

  if (int > 10) {
    return divide(int)
  }

  return int
}

function hash(key) {
  let h = require('string-hash')(key)
  return divide(h)
}
```

This function uses an array of ten elements to store values, meaning that elements
are likely to be replaced -- a nasty bug in our `DumbMap`:

``` js
let m = new DumbMap()

for (x = 0; x < 1000000; x++) {
  m.set(`element${x}`, x)
}

console.log(m.get('element0')) // 999988
console.log(m.get('element1')) // 999988
console.log(m.get('element1000')) // 999987
```

In order to resolve the issue, we can simply store multiple key-value pairs at the
same index -- let's amend our hashtable:

``` js
class DumbMap {
  constructor() {
    this.list = []
  }

  get(x) {
    let i = hash(x)

    if (!this.list[i]) {
      return undefined
    }

    let result

    this.list[i].forEach(pairs => {
      if (pairs[0] === x) {
        result = pairs[1]
      }
    })

    return result
  }

  set(x, y) {
    let i = hash(x)

    if (!this.list[i]) {
      this.list[i] = []
    }

    this.list[i].push([x, y])
  }
}
```

As you might notice, here we fall back to our original implementation: store a list
of key-value pairs and loop through each of them, which is going to be quite slow
when there are a lot of collisions for a particular index of the list.

Let's benchmark this using our own `hash()` function that generates indexes from 0 to 10:

``` bash
with lots of records in the map: 11.919ms
```

and by using the hash function from `string-hash`, which generates random indexes:

``` bash
with lots of records in the map: 0.014ms
```

WHOA, there's the cost of picking the right hashing function -- fast enough that
it doesn't slow our execution down on its own, and good enough that it doesn't produce a lot
of collisions.

## Generally O(1)

Remember my words?

> Hashtables have a `O(1)` complexity

Well, I lied: the complexity of an hashtable depends on the hashing function you
pick. The more collisions you generate, the more the complexity tends toward `O(n)`.

A hashing function such as:

``` js
function hash(key) {
  return 0
}
```

would mean that our hashtable has a complexity of `O(n)`.

This is why, in general, computational complexity has 3 measures: best, average
and worst-case scenarios. Hashtables have a `O(1)` complexity in best and average case scenarios, but fall
to `O(n)` in their worst-case scenario.

Remember: **a good hashing function is the key to an efficient hashtable** -- nothing more, nothing less.

## More on collisions...

The technique we used to fix `DumbMap` in case of collisions is called [separate chaining](https://xlinux.nist.gov/dads/HTML/separateChaining.html):
we store all the key-pairs that generate collisions in a list and loop through
them.

Another popular technique is [open addressing](https://en.wikipedia.org/wiki/Open_addressing):

* at each index of our list we store **one and one only key-value pair**
* when trying to store a pair at index `x`, if there's already a key-value pair, try to store our new pair at `x + 1`
* if `x + 1` is taken, try `x + 2` and so on...
* when retrieving an element, hash the key and see if the element at that position (`x`) matches our key
* if not, try to access the element at position `x + 1`
* rinse and repeat until you get to the end of the list, or when you find an empty index -- that means our element is not in the hashtable

Smart, simple, elegant and [usually very efficient](http://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16-28.html)!

## FAQs (or TL;DR)

**Does a hashtable hash the values we're storing?**

No, keys are hashed so that they can be turned into an integer, and both keys
and values are stored at position `hash(key)` in a list.

**Do the hashing functions used by hashtables generate collisions?**

Absolutely -- so hashtables are implemented with [defense strategies](https://en.wikipedia.org/wiki/Hash_table#Collision_resolution)
to avoid nasty bugs.

**Do hashtables use a list or a linked list internally?**

It depends, [both can work](https://stackoverflow.com/questions/13595767/why-do-hashtables-use-a-linked-list-over-an-array-for-the-bucket).
In our examples, we use the JavaScript array (`[]`) that can be [resized dynamically](https://www.quora.com/Do-arrays-in-JavaScript-grow-dynamically):

``` js
> a = []

> a[3] = 1

> a
[ <3 empty items>, 1 ]
```

**Why did you pick JavaScript for the examples? JS arrays ARE hashtables!**

For example:

``` js
>  a = []
[]
> a["some"] = "thing"
'thing'
> a
[ some: 'thing' ]
> typeof a
'object'
```

I know, damn JavaScript.

JavaScript is "universal" and probably the easiest language to understand when looking
at some sample code. I agree JS might not be the best language, but I hope these
examples are clear enough.

**Is your example a really good implementation of an hashtable? Is it really THAT simple?**

No, not at all.

Have a look at "[implementing a hash table in JavaScript](http://www.mattzeunert.com/2017/02/01/implementing-a-hash-table-in-javascript.html)"
by [Matt Zeunert](http://www.mattzeunert.com/), as it will give you a bit more
context. There's a lot more to learn, so I would also suggest you to also have a look at:

* [Paul Kube's course on hash tables](http://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec16/lec16.html)
* [Implementing our Own Hash Table with Separate Chaining in Java](https://www.geeksforgeeks.org/implementing-our-own-hash-table-with-separate-chaining-in-java/)
* [Algorithms, 4th Edition - Hash tables](https://algs4.cs.princeton.edu/34hash/)
* [Designing a fast hash table](http://www.ilikebigbits.com/blog/2016/8/28/designing-a-fast-hash-table)

## In the end...

Hashtables are a very clever idea we use on a regular basis: no matter
whether you create a [dictionary in Python](https://stackoverflow.com/questions/114830/is-a-python-dictionary-an-example-of-a-hash-table), an [associative array in PHP](https://stackoverflow.com/a/3134315/934439) or a [Map
in JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) -- they all share the same concepts and beautifully work to let us
store and retrieve element by an identifier, at a (most likely) constant cost.

Before I leave, let me already say "*sorry*" for the typos and mistakes in this
article -- it's late in the night, I wrote this quickly...   ...but I didn't
want to leave hashtables, the unsung heroes of computer science, behind anymore!

Hope you enjoyed this article, and feel free to share your feedback with me.

Adios!
