---
layout: post
title: "Book review: Code simplicity"
date: 2017-09-23 22:08
comments: true
categories: [coding, design pattern, simplicity, architecture, book, review]
description: "The main developer behind bugzilla, the OS bug tracker, explains you how to keep architectures & code simple."
---

People who work with me tend to realize, quite soon, how much I
strive towards trying to build simple software: simplicity keeps
code reusable, open and easy to maintain or evolve -- the toll
abstractions take is generally a heavy one, and I try to avoid it
every time I can (been guilty of building complex, and some time complicated,
stuff too!): to me, **simplicity is king**.

Now, I was really excited to find out that the main dev behind
Bugzilla, the OS bug tracker, wrote a book about simplicity in software
as - I thought - he could give me a really good overview of keeping
things simple in such a huge (and dated) project.

<!-- more -->

{% img right https://images-na.ssl-images-amazon.com/images/I/51c4Mbgv-pL._SX379_BO1,204,203,200_.jpg %}

So I went ahead and bought myself a copy of "[Code simplicity](https://www.amazon.com/Code-Simplicity-Fundamentals-Max-Kanat-Alexander-ebook/dp/B007NZU848)" and,
to be honest, it was a fairly intriguing book: nothing groundbreaking
but, at the end of the day, it is a solid book that gives you some
inspiration.

Even though you might not agree with everything the author puts on the
table, you will find yourself going through some pearls on software design
and how to design good software, through simple & coincise code:

{% blockquote %}
The difference between a bad programmer and a good programmer is understanding.
{% endblockquote %}

{% blockquote %}
Programming, in essence, must become the act of reducing complexity to simplicity.
{% endblockquote %}

{% blockquote %}
You must not design by committee.
{% endblockquote %}

{% blockquote %}
The desirability of any change is directly proportional to the value of the change and inversely proportional to the effort involved in making the change.
{% endblockquote %}

{% blockquote %}
nearly all decisions in software design reduce entirely to measuring the future value of a change versus its effort of maintenance.
{% endblockquote %}

{% blockquote %}
It is more important to reduce the effort of maintenance than it is to reduce the effort of implementation.
{% endblockquote %}

{% blockquote %}
there is a difference between designing in a way that allows for future change and attempting to predict the future.
{% endblockquote %}

{% blockquote %}
Code should be designed based on what you know now, not on what you think will happen in the future.
{% endblockquote %}

{% blockquote %}
the more you code, the more defects you will introduce.
{% endblockquote %}

{% blockquote %}
Never “fix” anything unless it’s a problem, and you have evidence showing that the problem really exists.
{% endblockquote %}

{% blockquote %}
The ease of maintenance of any piece of software is proportional to the simplicity of its individual pieces.
{% endblockquote %}

{% blockquote %}
Names should be long enough to fully communicate what something is or does without being so long that they become hard to read.
{% endblockquote %}

{% blockquote %}
Consistency is a big part of simplicity. If you do something one way in one place, do it that way in every place.
{% endblockquote %}

{% blockquote %}
Some projects start out with such a complex set of requirements that they never get a first version out. If you’re in this situation, you should just trim features. Don’t shoot for the moon in your first release — get out something that works and make it work better over time.
{% endblockquote %}

{% blockquote %}
Some of the best programming is done on paper, really. Putting it into the computer is just a minor detail.
{% endblockquote %}

{% blockquote %}
Comments should explain why the code is doing something, not what it is doing.
{% endblockquote %}

{% blockquote %}
When presented with complexity, ask, “What problem are you trying to solve?”
{% endblockquote %}

As a "secondary read"{% fn_ref 1 %} I think this is a pretty solid book!

{% footnotes %}
  {% fn When I say "secondary" I mean one of those backup books you read throughout a long span of time, nothing that deserves your undivided attention while reading but is still valuable to you %}
{% endfootnotes %}