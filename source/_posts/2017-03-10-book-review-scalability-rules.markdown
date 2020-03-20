---
layout: post
title: "Book review: Scalability Rules"
date: 2017-03-10 12:11
comments: true
categories: [book, review, scalability]
description: "My review of 'Scalability Rules: 50 principles for scaling websites'"
---

I recently finished reading [Scalability Rules: 50 principles for scaling websites](http://www.scalabilityrules.com/)
(2nd edition) and wanted to share a few thoughts on the book.

<!-- more -->

{% img right /images/scalability-rules-book.png %}

The book is very straightforward, as it's basically a collection of 50 rules on
how to plan for scalability -- a lot of the rules aren't very sophisticated but
my overall feedback on the book is quite positive, as it's an interesting read
that can spark some inspiration.

One of the interesting differences from the 1st edition (from what I understood)
is that in the new release of the book the authors integrated some success (and horror)
stories heard and witnessed around: for example, you'll read on how PayPal underwent
a [massive downtime](https://arstechnica.com/uncategorized/2004/10/4296-2/) due to
some changes on how they were [managing transactions](https://en.wikipedia.org/wiki/Two-phase_commit_protocol),
which proved to create more damage than anything else. These stories were the part
of the book I kind of enjoyed the most, as the rules' credibility increases once
you hear it from the guys who have been in the trenches.

Some interesting quotes from the book:

{% blockquote  %}
Design for 20x capacity. Implement for 3x capacity. Deploy for roughly 1.5x capacity.
{% endblockquote %}

{% blockquote  %}
Apply the Pareto Principle (also known as the 80-20 rule) frequently. What 80% of your benefit is achieved from 20% of the work? In our case, a direct application is to ask, “What 80% of your revenue will be achieved by 20% of your features?”
{% endblockquote %}

{% blockquote  %}
We hope you will get a sense of how you can push back on the idea that all data has to be kept in sync in real time.
{% endblockquote %}

{% blockquote  %}
“Scaling up is failing up.” What does that mean? In our minds, it is clear: we believe that within hyper-growth environments it is critical that companies plan to scale in a horizontal fashion—what we describe as scaling out
{% endblockquote %}

{% blockquote  %}
Build your systems to be capable of relying on commodity hardware, and don’t get caught in the trap of using high-margin, high-end servers.
{% endblockquote %}

{% blockquote  %}
Try to avoid session data completely, but when needed, consider putting the data in users’ browsers
{% endblockquote %}

{% blockquote  %}
Many commerce companies and some financial services institutions apply this concept to older data that is meant primarily for historical record keeping. Your online bank provider may put all historical transactions in a read-only file system, removing it from the transactional database. You can view your past transactions, but it is unlikely that you can make changes to them, update them, or cancel them. After some period of time, say 90 days or a year, they remove your access to the transactions online and you have to request them via e-mail.
{% endblockquote %}

All in all, I don't think the book is *mind-blowing* or anything as such, but I gotta give it to
the authors that's something I'm quite happy to have in my library: at the end of the day,
it's a solid collection of memos on how to plan and build scalable, distributed systems.

Cheers!