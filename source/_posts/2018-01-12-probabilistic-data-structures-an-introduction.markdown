---
layout: post
title: "Probabilistic data structures: an introduction"
date: 2018-01-12 09:44
comments: true
categories: [data structures, probability, probabilistic data structures, series, hll]
description: "Welcome to the world of probabilistic data structures, where ingenious algorithms meet real-life problems"
---

{% img right /images/dice.png %}

In the past few years I've got more and more accustomed to computer science
concepts that were foreign to me earlier in my career: one of the most interesting
aspects that I've focused on is [probabilistic data structures](https://dzone.com/articles/introduction-probabilistic-0),
which I want to cover with a few posts in the upcoming months.

My excitement around these structures come from the fact that they
enable us to accomplish tasks that were impractical before, and can really influence
the way we design software -- for example, Reddit counts unique views with a
probabilistic data structure as it lets them scale more efficiently.

<!-- more -->

## What's all the fuss about?

Let's get practical very quickly -- imagine you have a set of records and want to calculate if an element is part
of that set:

``` js
let set = new Array()

for (let x = 0; x < 10; x++) {
  set.push(`test${x}`)
}

console.log(set.includes('a')) // false
```

Here we are loading the entire set in memory and then loop (`.includes(...)`)
over it to figure out if our element is part of it.

Let's say we want to figure out the resources used by this script:

``` js
console.time('search')
let set = new Array()

for (let x = 0; x < 10; x++) {
  set.push(`test${x}`)
}

console.log(set.includes('a'))
console.timeEnd('search')
console.log(`~${process.memoryUsage().heapUsed / 1000000}mb`)

// output:
// false
// search: 2.184ms
// ~4.448288mb
```

As you can see, the time spent in running the script is minimal, and memory is
also "low". What happens when we beef up our original list?

``` js
...
for (let x = 0; x < 10000000; x++) {
  set.push(`test${x}`)
}
...


// output:
// false
// search: 2383.794ms
// ~532.511032mb
```

See, the figures change quite drastically -- it's not even the execution time
that should scare you (most of the time is spent in filling the array, not in the
`.includes(...)`), but rather the amount of memory the process is consuming: as usual,
the more data we use, the more memory we consume (no shit, Sherlock!).

This is exactly the problem that probabilistic data structures try to solve, as you:

* might not have enough available resources
* might not need a precise answer to your problem

If you can trade certainty off for the sake of staying lightweight, a [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter)
would, for example, be the right data structure for this particular use case:

``` js
const BloomFilter = require('bloomfilter').BloomFilter
console.time('search')
var bloom = new BloomFilter(
  287551752, // number of bits to allocate.
  20        // number of hash functions.
);

for (let x = 0; x < 10000000; x++) {
  bloom.add(`test${x}`)
}

console.log(bloom.test('a'))
console.timeEnd('search')
console.log(`~${process.memoryUsage().heapUsed / 1000000}mb`)

// output
// false
// search: 11644.863ms
// ~10.738632mb
```

In this case the bloom filter has given us the same output (with a [degree
of certainty](https://en.wikipedia.org/wiki/Bloom_filter#Probability_of_false_positives)) while using 10MB of RAM rather than 500MB.
Oh, boy!

This is exactly what probabilistic data structures help you with: you need an
answer with a degree of certainty and don't care if they're off by a tiny
bit -- because to get an exact answer you would require an impractical amount of
resources.

Who cares if that video has been seen by 1M unique users or 1.000.371 ones? If
you find yourself in this situation, chances are that a probabilistic structure
would fit extremely well in your architecture.

## Next steps

I have only really started to scratch the surface of what is possible thanks to
probabilistic data structures but, if you are fascinated as much as I am, you
will find some of my next articles interesting enough, as I am planning to cover
the ones that I understand better in the upcoming weeks -- namely [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog)
(by far my favorite data structure) and
[Bloom filters](https://en.wikipedia.org/wiki/Bloom_filter).

The papers behind these data structures are pretty *math-heavy* and I do not understand half of that jazz :)
so we're going to take a look at them with more of a simplistic, practical view
than a theoretical one.

## Just before you leave...

One thing I want to clarify: the specific numbers you've seen in this post will vary from platform to platform, so don't
look at the absolute numbers but rather at the magnitude of the difference. Also,
here I just focused on one application of Bloom filters, which demonstrates their
advantage in terms of space complexity, but time complexity should be accounted
for as well -- that's material for another post!

Cheers!