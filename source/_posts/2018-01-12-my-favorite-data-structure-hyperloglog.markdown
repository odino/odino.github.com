---
layout: post
title: "My favorite algorithm (and data structure): HyperLogLog"
date: 2018-01-13 21:09
comments: true
categories: [probabilistic data structures, data structures, HLL, BigQuery, algorithms, series]
description: "One of the most amazing algorithms that were ever invented -- how to efficiently count unique things"
---

Every now and then I bump into a concept that's so simple and powerful that I want
to stab my brain for missing out on such an incredible and beautiful idea.

I discovered [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) (HLL) a
couple years ago and fell in love with it right after reading how
[redis decided to add a HLL data structure](http://antirez.com/news/75):
the idea behind HLL is devastatingly simple but extremely powerful, and it's
what makes it such a widespread algorithm, used by giants of the internet such
as Google and Reddit.

<!-- more -->

## So, what's your phone number?

My friend Tommy and I planned to go to a conference and, while heading to
its location, decide to wager on who will talk to the most strangers.
So once we reach the place we start conversing around and keep a counter of
how many people we talk to.

{% img center /images/networking-event.png %}

At the end of the event Tommy comes to me with his figure (17) and I tell him
that I had a word with 46 people: I clearly am the winner, but Tommy's frustrated
as he thinks I've counted the same people multiple times, as he only saw me with
15/20 people in total. So, the wager's off and we decide that,
for our next event, we'll be taking down names instead, so that we're sure we're
going to be counting unique people, and not just the total number of conversations.

At the end of the following conference we enthusiastically meet each other with
a very long list of names and, guess what, Tommy had a couple more encounters
than I did! We both laugh it off and while discussing our approach to counting
uniques, Tommy comes up with a great idea:

{% blockquote %}
Alex, you know what? We can't go around with pen and paper and track down a list
of names, it's really impractical! Today I spoke to 65 different people and counting
their names on this paper was a real pain in the back...I lost count 3 times and had to start from scratch!
{% endblockquote %}

{% blockquote %}
Yeah, I know, but do we even have an alternative?
{% endblockquote %}

{% blockquote %}
What if, for our next conference, instead of asking for names, we ask people the
last 5 digits of their phone number?

Now, follow me: instead of winning by counting their names, the winner will be
the one who spoke to someone with the longest sequence of leading zeroes in those digits.
{% endblockquote %}

{% blockquote %}
Wait Tommy, you're going too fast! Slow down a second and give me an example...
{% endblockquote %}

{% blockquote %}
Sure, just ask people for those last 5 digits, ok? Let's suppose you get 54701.
No leading zero, so the longest sequence of zeroes for you is 0. The next person
you talk to tells you it's 02561 -- that's a leading zero! So your longest sequence
comes to 1.
{% endblockquote %}

{% blockquote %}
You're starting to make sense to me...
{% endblockquote %}

{% blockquote %}
Yeah, so if we speak to a couple people, chances are that are longest zero-sequence
will be 0. But if we talk to ~10 people, we have more chances of it being 1.

Now, imagine you tell me your longest zero-sequence is 5 -- you must have spoken
to thousands of people to find someone with 00000 in their phone number!
{% endblockquote %}

{% blockquote %}
Dude, you're a damn genius!
{% endblockquote %}

And that, my friends, is how HyperLogLog fundamentally works: it allows us to
estimate uniques within a large dataset by recording the longest sequence of
zeroes within that set. This ends up creating an incredible advantage over keeping
track of each and every element in the set, making it an incredibly efficient way
to count unique values with relatively high accuracy:

{% blockquote Fangjin Yang http://druid.io/blog/2012/05/04/fast-cheap-and-98-right-cardinality-estimation-for-big-data.html Fast, Cheap, and 98% Right: Cardinality Estimation for Big Data %}
The HyperLogLog algorithm can estimate cardinalities well beyond 10^9 with a relative accuracy (standard error) of 2% while only using 1.5kb of memory.
{% endblockquote %}

Since this is the usual me oversimplifying things
that I find hard to understand, let's have a look at some more details of HLL.

## More HLL details

HLL is part of a family of algorithms that aim to address
[cardinality estimation](https://en.wikipedia.org/wiki/Count-distinct_problem),
otherwise known as *count-distinct problem*,
which are extremely useful for lots of today's web applications -- for example
when you want to count how many unique views an article on your site has generated.

When HLL runs, it takes your input data and hashes it, turning into a bit
sequence:

```
IP address of the viewer: 54.134.45.789

HLL hash: 010010101010101010111010...
```

Now, an important part of HLL is to make sure that your hashing function
distributes bits as evenly as possible, as you don't want to use a weak function
such as:

``` js
function hash(ip) {
  let h = ''

  ip.replace(/\D/g,'').split('').forEach(number => {
    h += number < 5 ? 0 : 1
  })

  return h
}
```

A HLL using this hashing function would return biased results if, for example,
the [distribution of your visitors is tied to a specific geographic region](https://stackoverflow.com/a/277537/934439).

The [original paper](http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf)
has a few more details on what a good hashing function means for HLL:

{% blockquote Philippe Flajolet http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf HyperLogLog: the analysis of a near-optimal cardinality estimation algorithm %}
All known efficient cardinality estimators rely on randomization, which is ensured by the use of hash functions.

The elements to be counted belonging to a certain data domain D, we assume given a hash function, h : D → {0, 1}∞; that is, we assimilate hashed values to infinite binary strings of {0, 1}∞, or equivalently to real numbers of the unit interval.

[...]

We postulate that the hash function has been designed in such a way that the hashed values closely resemble a uniform model of randomness, namely, bits of hashed values are assumed to be independent and to have each probability [0.5] of occurring.
{% endblockquote %}

Now, after we've picked a suitable hash function we need to address another pitfall:
[variance](https://en.wikipedia.org/wiki/Variance).

Going back to our example, imagine that the first person you talk to at the conference
tells you their number ends with `00004` -- jackpot! You might have won a wager
against Tommy, but if you use this method in real life chances are that specific
data in your set will negatively influence the estimation.

Fear no more, as this is **a problem HLL was born to solve**: not many are aware that [Philippe
Flajolet](https://en.wikipedia.org/wiki/Philippe_Flajolet), one of the brains behind HLL, was quite involved in cardinality-estimation
problems for a long time, long enough to have come up with the [Flajolet-Martin
algorithm in 1984](https://en.wikipedia.org/wiki/Flajolet%E2%80%93Martin_algorithm#Improving_accuracy) and
[(super-)LogLog in 2003](http://algo.inria.fr/flajolet/Publications/DuFl03-LNCS.pdf),
which already addressed some of the problems with outlying hashed values by dividing
measurements into buckets, and (somewhat) averaging values across buckets.

If you got lost here, let me go back to our original example: instead of just
taking the last 5 digits of a phone number, we take 6 of them and store the longest
sequence of leading zeroes together with the first digit (the bucket). This means
that our data will look like:

```
Input:
708942 --> in the 7th bucket, the longest sequence of zeroes is 1
518942 --> in the 5th bucket, the longest sequence of zeroes is 0
500973 --> in the 5th bucket, the longest sequence of zeroes is now 2
900000 --> in the 9th bucket, the longest sequence of zeroes is 5
900672 --> in the 9th bucket, the longest sequence of zeroes stays 5

Buckets:
0: 0
1: 0
2: 0
3: 0
4: 0
5: 2
6: 0
7: 1
8: 0
9: 5

Output:
avg(buckets) = 0.8
```

As you see, if we weren't employing buckets we would instead use 5 as the longest
sequence of zeroes, which would negatively impact our estimation: even though I
simplified the math behind buckets (it's not just a simple average), you can
totally see how this approach makes sense.

It's interesting to see how Flajolet addresses variance throughout his
works:

{% blockquote Nick Johnson http://blog.notdot.net/2012/09/Dam-Cool-Algorithms-Cardinality-Estimation Improving accuracy: SuperLogLog and HyperLogLog %}
While we've got an estimate that's already pretty good, it's possible to get a lot better. Durand and Flajolet make the observation that outlying values do a lot to decrease the accuracy of the estimate; by throwing out the largest values before averaging, accuracy can be improved.

Specifically, by throwing out the 30% of buckets with the largest values, and averaging only 70% of buckets with the smaller values, accuracy can be improved from 1.30/sqrt(m) to only 1.05/sqrt(m)! That means that our earlier example, with 640 bytes of state and an average error of 4% now has an average error of about 3.2%, with no additional increase in space required.

Finally, the major contribution of Flajolet et al in the HyperLogLog paper is to use a different type of averaging, taking the harmonic mean instead of the geometric mean we just applied. By doing this, they're able to edge down the error to  1.04/sqrt(m), again with no increase in state required.
{% endblockquote %}

## HLL in the wild

So, where can we find HLLs? Two great web-scale examples are:

* [BigQuery](https://cloud.google.com/blog/big-data/2017/07/counting-uniques-faster-in-bigquery-with-hyperloglog),
to efficiently count uniques in a table (`APPROX_COUNT_DISTINCT()`)
* [Reddit](https://redditblog.com/2017/05/24/view-counting-at-reddit/), where it's used to calculate how many unique views a post has gathered

In particular, see how HLL impacts queries on BigQuery:

``` bash
SELECT COUNT(DISTINCT actor.login) exact_cnt
FROM `githubarchive.year.2016`
> 6,610,026 (4.1s elapsed, 3.39 GB processed, 320,825,029 rows scanned)

SELECT APPROX_COUNT_DISTINCT(actor.login) approx_cnt
FROM `githubarchive.year.2016`
> 6,643,627 (2.6s elapsed, 3.39 GB processed, 320,825,029 rows scanned)
```

The second result is an approximation (with an error rate of ~0.5%), but takes
a fraction of the time.

Long story short: **HyperLogLog is amazing!** You now know what it is and when it can be
used, so go out and do incredible stuff with it!

## Just before you leave...

One thing I'd like to clarify is that even though I've referred to HLL as a data structure before, it
should be noted that it is an algorithm first, while some databases (eg. Redis, Riak, BigQuery)
have implemented their own data structures based on HLL (so while saying HLL is a data structure is technically incorrect, it's also not
entirely wrong).

## Further readings

* [HyperLogLog on Wikipedia](https://en.wikipedia.org/wiki/HyperLogLog)
* the [original paper](http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf)
* [HyperLogLog++, Google's improved implementation of HLL](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40671.pdf)
* [Redis new data structure: the HyperLogLog](http://antirez.com/news/75)
* [Damn Cool Algorithms: Cardinality Estimation](http://blog.notdot.net/2012/09/Dam-Cool-Algorithms-Cardinality-Estimation)
* [HLL data types in Riak](https://github.com/basho/riak_kv/blob/develop/docs/hll/hll.pdf)
* [HyperLogLog and MinHash](http://tech.adroll.com/blog/data/2013/07/10/hll-minhash.html)
