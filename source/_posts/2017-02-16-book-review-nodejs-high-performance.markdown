---
layout: post
title: "Book review: NodeJS High Performance"
date: 2017-02-16 14:16
comments: true
categories: [nodejs, book, review]
---

It's been a couple months that I started reading more aggressively compared to
the past couple of years, and today I want to give you an honest review of a book
I found extremely underwhelming, [NodeJS High Performance](https://www.amazon.com/Node-js-High-Performance-Diogo-Resende/dp/1785286145).

<!-- more -->

{% img right /images/nodejs-high-perf-book.jpg %}

I feel terrible as I really, really wanted this book to be great or, at least,
*good enough*, as I can imagine the struggle the author went through to get it
done, to then hear a bad review such as this one. Alas, I want to be objective
and give my honest opinion about it.

The book's target audience is apparently the mid/sr engineer who has either moved
to node or has a bit of experience building server-side JS apps, but never dug
deep onto performance or benchmarks. I legitimately felt part of the audience,
as I never did any serious performance tuning or auditing on node apps.

The book contains a couple chapter that are focused on performance / benchmarking / profiling
but they are definitely not enough, especially given the fact that most of the
content of those chapters is information that's already [available online](https://www.google.ae/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=nodejs+profiling).
Give the "high performance" on the title of the book I thought there should have
been way more in-depth content dealing with memory and CPU cycles.

As far as the rest of the book goes, well...  ...it's even less interesting.
There is a chapter dedicated to testing with mocha which, in my opinion, should
be part of another book, probably targeted to beginners.

*NodeJS High Performance* is more of an overview of development practices for Node, from how to
use NPM to using mocha to test your code, but quite a few of the things that are
mentioned are very basic (turn on HTTPs, test your code, mocha has timeouts on
tests to ensure they dont take long) and I think that, as long as you used node
for longer than 6 months, you won't find anything new in there.

As I said on my [Amazon review](https://www.amazon.com/gp/customer-reviews/RZKZLVB34PRZ9/ref=cm_cr_arp_d_rvw_ttl?ie=UTF8&ASIN=1785286145),
I would definitely discourage experienced developers from purchasing it, as it
won't add much to your knowledge. On the other side, if you just got started a
few months ago or switched to node after other platforms I would say it has a
lot of informative points and lists quite a few best practices, so it could be
considered as a good reference on how to generally create "good" node apps.
