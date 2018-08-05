---
layout: post
title: "Book review: The Go programming language"
date: 2017-09-23 22:07
comments: true
categories: [golang, book, review]
description: "A breath-taking overview of Golang: one of the best reads of my life."
---

Some books are so good you feel honored to be able
to read them, and "[The Go programming language](https://www.amazon.com/Programming-Language-Addison-Wesley-Professional-Computing/dp/0134190440)",
in my opinion, happens to make that list: it's a real gem.

<!-- more -->

{% img right https://images-na.ssl-images-amazon.com/images/I/51kErZGgOZL._SX399_BO1,204,203,200_.jpg %}

Now, I can't really tell if it's because I personally
like Golang a lot or because the author is some kind of
Stephen King of technical writers, but I must admit this
was one of the best books I've ever read: the way it guides
you through the language, explain design decisions, common
pitfalls (and how to avoid them) and so on is simply beautiful.

To give you a perspective, the book is very practical, and each
chapter kind of adds a feature to the software you're building:

* first, familiarize with the language (ie. syntax)
* then, write a small app, such as a crawler
* then, make it perform faster through concurrency
* *then, make it concurrency-safe etc etc etc...*

To me, reading the book just feels like entering Rob Pike's brain
to understand the decisions and rationale behind Go's design,
standard library and so on.

(side note: Rob Pike actually reviewed the book. As soon as I found
out, I got quite excited!)

As someone who has been playing with the language for 2
years but didn't deploy more than 2 real-word Go apps in production,
it was definitely a good read, so I'd encourage mid, novice
and aspiring Golang programmers to read the book.

Keeping in mind that I tend to be
excited about Golang in general, here's a bunch of significant
quotes from the book:

{% blockquote %}
creating one goroutine is cheap and creating a million is practical
{% endblockquote %}

{% blockquote %}
go doc http.ListenAndServe
{% endblockquote %}

{% blockquote %}
There is no limit on name length, but convention and style in Go programs lean toward short names, especially for local variables with small scopes; you are much more likely to see variables named i than theLoopIndex. Generally, the larger the scope of a name, the longer and more meaningful it should be.
{% endblockquote %}

{% blockquote %}
normal practice in Go is to deal with the error in the if block and then return, so that the successful execution path is not indented
{% endblockquote %}

{% blockquote %}
Get into the habit of considering errors after every function call, and when you deliberately ignore one, document your intention clearly.
{% endblockquote %}

{% blockquote %}
the unit of encapsulation is the package, not the type as in many other languages.
{% endblockquote %}

{% blockquote %}
The entire errors package is only four lines long
{% endblockquote %}

{% blockquote %}
When designing a new package, novice Go programmers often start by creating a set of interfaces and only later define the concrete types that satisfy them. This approach results in many interfaces, each of which has only a single implementation. Don’t do that. Such interfaces are unnecessary abstractions; they also have a run-time cost. You can restrict which methods of a type or fields of a struct are visible outside a package using the export mechanism. Interfaces are only needed when there are two or more concrete types that must be dealt with in a uniform way.
{% endblockquote %}

{% blockquote %}
A defer is marginally more expensive than an explicit call to Unlock, but not enough to justify less clear code. As always with concurrent programs, favor clarity and resist premature optimization. Where possible, use defer and let critical sections extend to the end of a function.
{% endblockquote %}

{% blockquote %}
Be descriptive and unambiguous where possible. For example, don’t name a utility package util when a name such as imageutil or ioutil is specific yet still concise.
{% endblockquote %}

{% blockquote %}
Good documentation need not be extensive, and documentation is no substitute for simplicity.
{% endblockquote %}

{% blockquote %}
Go’s attitude to testing stands in stark contrast. It expects test authors to do most of this work themselves, defining functions to avoid repetition, just as they would for ordinary programs.
{% endblockquote %}

{% blockquote %}
As the influential computer scientist Edsger Dijkstra put it, “Testing shows the presence, not the absence of bugs.”
{% endblockquote %}

{% blockquote %}
Since other goroutines cannot access the variable directly, they must use a channel to send the confining goroutine a request to query or update the variable. This is what is meant by the Go mantra “Do not communicate by sharing memory; instead, share memory by communicating.”
{% endblockquote %}

Go is really magical, the kind of magical that makes you productive and
leaves you speechless{% fn_ref 1 %} when writing code.

{% footnotes %}
  {% fn Note: not the PHP kind of speechless ;-)  %}
{% endfootnotes %}
