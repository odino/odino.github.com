---
layout: post
title: "Book Review: Nine Algorithms That Changed the Future"
date: 2017-04-16 15:56
comments: true
categories: [book, review, computer science]
description: "Review of one of the most interesting books I read in the past months"
---

{% img right /images/9-algos-book.jpg %}

This was highly unexpected: [Nine Algorithms That Changed the Future](https://www.amazon.com/Nine-Algorithms-That-Changed-Future/dp/0691158193)
is a hell of a book!

The premise of the book is that it might be too boring for those familiar with
the industry, but it's one of the most fascinating books I've read over the past
few months instead: sure, some topics were really basic and you could skip some chapters
as they were explaining computing fundamentals to people with no prior knowledge,
but **the book got me hooked** regardless, as it's able to walk you through
some very interesting topics such as Quantum Computing or
[software that fixes itself](https://www.technologyreview.com/s/416036/software-that-fixes-itself/).

<!-- more -->

The book is divided in 9 + 1 chapters that will walk you through clever
algorithms that dominate today's computing, from indexing techniques and crypto
to pattern recognition and data compression: in each chapter you will
slowly familiarize with the problem, go through the poor man's solution and see
how clever algorithms efficiently solve the original problem. Chapters build up so
well that's a real joy to go through them -- the only negative point I might have
is that a couple of them really strive to explain it to people without a solid
background, and they might be too tedious to the programmer in you. But, considering
that one of the goals of the book is to get people closer to Computer Science, even
those "boring" chapters get my personal high-five!

Some interesting quotes from the book:

{% blockquote %}
Babylonians were using indexing 5000 years before search engines existed
{% endblockquote %}

{% blockquote %}
if you download a 20-megabyte software program, and your computer misinterprets just one in every million characters it receives, there will probably still be over 20 errors in your downloaded program—every one of which could cause a potentially costly crash when you least expect it.
The moral of the story is that, for a computer, being accurate 99.9999% of the time is not even close to good enough
{% endblockquote %}

{% blockquote %}
by repeating an unreliable message often enough, you can make it as reliable as you want
{% endblockquote %}

{% blockquote %}
Hamming we have met already: it was his annoyance at the weekend crashes of a company computer that led directly to his invention of the first error-correcting codes, now known as Hamming codes
{% endblockquote %}

{% blockquote %}
Shannon demonstrated through mathematics that it was possible, in principle, to achieve surprisingly high rates of error-free communication over a noisy, error-prone link. It was not until many decades later that scientists came close to achieving Shannon's theoretical maximum communication rate in practice.
{% endblockquote %}

{% blockquote %}
To keeps things simple, let's assume you work eight-hour days, five days a week, and that you divide your calendar into one-hour slots. So each of the five days has eight possible slots, for a total of 40 slots per week. Roughly speaking, then, to communicate a week of your calendar to someone else, you have to communicate 40 pieces of information. But if someone calls you up to schedule a meeting for next week, do you describe your availability by listing 40 separate pieces of information? Of course not! Most likely you will say something like “Monday and Tuesday are full, and I'm booked from 1 p.m. to 3 p.m. on Thursday and Friday, but otherwise available.” This is an example of lossless data compression! The person you are talking to can exactly reconstruct your availability in all 40 slots for next week, but you didn't have to list them explicitly.
{% endblockquote %}

{% blockquote %}
Although physicists have known how to split atoms for many decades, the original meaning of “atomic” came from Greek, where it means “indivisible.” When computer scientists say “atomic,” they are referring to this original meaning.
{% endblockquote %}

{% blockquote %}
The issue of whether RSA is truly secure is among the most fascinating—and vexing—questions in the whole of computer science. For one thing, this question depends on both an ancient unsolved mathematical problem and a much more recent hot topic at the intersection of physics and computer science research. The mathematical problem is known as integer factorization, the hot research topic is quantum computing
{% endblockquote %}

{% blockquote %}
the pace of algorithmic innovation will, if anything, decrease in the future. I'm referring to the fact that computer science is beginning to mature as a scientific discipline. Compared to fields such as physics, mathematics, and chemistry, computer science is very young: it has its beginnings in the 1930s. Arguably, therefore, the great algorithms discovered in the 20th century may have consisted of low hanging fruit, and it will become more and more difficult to find ingenious, widely applicable algorithms in the future.
{% endblockquote %}

As [leader of a team](http://tech.namshi.com), I'm very happy with this book as it gives me a few good inspirations
on how to teach these ideas both at work and "at home": at the end of the day it's generally
hard to find good metaphors for the stuff we use everyday, and this book has a plethora
of straightforward ones that you can re-use whenever someone comes up to you and asks
you "*why is it safe to send sensitive information via HTTPS?*".

Highly recommended!