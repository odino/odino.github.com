---
layout: post
title: "Book review: Data-Intensive Text Processing with MapReduce"
date: 2012-02-23 12:57
comments: true
categories: [book, MapReduce]
---

As part of my studies not directly connected to my job,
in the last month I've finished this interesting book, which
gives you a good overview about
[MapReduce](http://en.wikipedia.org/wiki/MapReduce).
<!-- more -->

{% img right /images/mapreduce.book.jpg %}

[Jimmy Lin](http://www.umiacs.umd.edu/~jimmylin/) and Chris
Dyer nailed this one: the book is really clear and leaves
room for further studies, maybe more practical ones: the book
starts with the definition of MapReduce, from the algorithm to
the execution framework and the analyzes each part of the
algorithm and theyr variants in some frameworks, like
Hadoop{% fn_ref 1 %}.

After studying the components of MapReduce you will
take a practical look at possible implementations{% fn_ref 2 %},
from graph algorithms to the pagerank one: note that there are
so many references in the book, so if you will be into it, you're
gonna find yourself screwed in a *nerdy* loop :)

The EM chapter (dealing with *expectation-maximization* algorithms)
was pretty difficult for me, as it's too much time that I don't
take math *that* seriously, but I - however - was able to
follow all the theory explained there.

Something that I really appreciated was the closing remark stating that,
just like every technology, is not the right pick for every problem - 
think about **stateful** large scale data-processing algorithms.

I strongly recommend you to read such this kind of book: the approach
followed by the writers is so engineered and some examples they give,
like the [stupid backoff](/quality-isnt-always-better-than-quality/),
are pearls for your working experience.

{% footnotes %}
  {% fn But please remember, this book is not any kind of Hadoop guide %}
  {% fn Which are code-agnostic, as everything is written in a pretty clear pseudo-code %}
{% endfootnotes %}
