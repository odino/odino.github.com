---
layout: post
title: "My (nice) experience with Golang"
date: 2015-04-19 22:30
comments: true
categories: [golang, programming]
description: "Go is an incredibly exciting language: what made me fall in love with it?"
---

{% img right /images/gopher.png %}

For the past six months (right after the [DockerCon](http://europe.dockercon.com/))
I have been constantly taking some time out to play
around with [Go](http://golang.org/), trying
to understand why a lot of new tools were being
written in this interesting language, especially
in the DevOps world.

In the last few days [we](http://tech.namshi.com/)
published our first open source
library written in go, [godo](https://github.com/namshi/godo),
and I wanted to share my impression
of the language and the platform.

<!-- more -->

## Background

I have no solid experience in Go and you
should understand that I come from a scripting
background, starting from PHP all the way to
JavaScript, 2 languages I both love & hate
depending on the day :)

Even though my experience comes from 2 languages
and platforms that have been [highly](http://eev.ee/blog/2012/04/09/php-a-fractal-of-bad-design/) [criticized](http://www.boronine.com/2012/12/14/Why-JavaScript-Still-Sucks/)
over the past years, I've had a lot of fun
trying to preach towards the adoption of of [PEAA](http://martinfowler.com/eaaCatalog/),
automated testing{% fn_ref 1 %} and good abstraction,
so I've seen both the [simplistic / simple](http://programmers.stackexchange.com/questions/110797/why-is-php-so-frequently-used-on-web-servers) and the
[complex / structured](http://www.quora.com/What-are-the-most-ridiculous-Java-class-names-from-real-code), which is why I always tend
to play around with new tools and platforms: **one
more try, one more point of view**.

So, here starts the fun...

## Getting started

So, it all started on my way back from Amsterdam
(where DockerCon 2014 was held), I typed `mkdir holland`
(what else?) and followed an advice [a friend of mine](http://www.matteocollina.com/#biography)
gave me, which was "*Golang is really good with concurrency,
[...] go ahead and write your next proxy with it*":
let's write a proxy then!

The first natural thing was to then write a simple
Dockerfile starting with:

```
FROM golang

MAINTAINER Alessandro Nadalin "alessandro.nadalin@gmail.com"

RUN go get github.com/codegangsta/gin
...
```

5 minutes and I was ready to play with Golang on my
machine, writing my first "hello world" copying
the sample code from `golang.org`.

**Overall experience**: it was fairly easy to setup
everything on my system, but this is more thanks to
Docker rather than Go itself.

## Documentation

The next step was to try to find documentation
on how to do the simplest tasks with Go, just like I
did when I first started learning PHP 7 years ago and
JS a few full-moons ago.

To be honest, the experience wasn't pleasant, at least at first:
there aren't as many tutorial guiding through your first
steps with Go and, obviously, I was finding myself in trouble
even to simply declare my own packages and understanding
[how the gopath works](https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=gopath).

Luckily, I was able to figure these basic things out
quite quickly, but not quick enough to avoid getting my
wifi being cut off as I was getting on a plane to get back
to Dubai; at that point, the greatest of all surprises:
`godoc -http=:6060`. Pure magic.

{% img right /images/godoc.png %}

Yes, you can basically browse the whole golang.org website
offline, which gave me a huge boost even though I was
on a plane, without internet connection{% fn_ref 2 %}.

**Overall experience**: what I still find hard is to be
able to rely on a plethora of online tutorials on how to
do some stuff (ie. [SSHing from Go through a gateway](https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=golang+ssh+gateway+host)),
but you can live with it. The offline documentation is
really great and, on a broader level, the whole Golang
community is making a great effort to give newcomers a
clue.

## Compilation

One of the I was worried about is that Go is compiled,
though it's also one of its biggest strenghts.

The *meh* feeling you get once you hear that something is
compiled, coming from a scripting environment, is that
all of that jazz adds overhead, dead moments that
get you out of the zone and so on; luckily, Golang was born
at Google which means that it was designed to scale, both
in production and during development, else imagine how many
man days would be lost in a place like Google, who can
count on [~10k engineers](http://www.quora.com/How-many-software-engineers-does-Google-have){% fn_ref 3 %}.

As a matter of fact, you can compile the entire Go source
in [8 seconds](http://www.quora.com/How-do-Rust-and-Go-compare-1/answer/Carmi-Grushko),
which gives you a fair idea. Your own software, which will
probably use 5% of those dependencies, will probably take
less than 300ms, which is pretty **ideal**.

In JS I would develop much different applications,
but if I have to think of how long I wait between editing a file
in an angular app and being able to see the changes on the browser,
I think it might be around the same time.
This is not to compare JS and Go (how silly would that be?) but it's
more to highlight the fact that if you've already worked on frontend,
the average Go program won't dramatically change your habits,
at least from a development workflow perspective.

And then, [Go is fast](http://programmers.stackexchange.com/questions/83780/how-fast-can-go-go). How fast?
You don't really care, because your typical use case won't stress
Go that much, but expect it to perform [significantly better
than scripted stuff like Python or Node](http://www.reddit.com/r/golang/comments/2r1ybd/speed_of_go_compared_to_java_and_python/).

Of course, it always depends on **your application**, **your need** and
**your coding skills** -- at the end of the day I can only point
obvious truths out, and the fact that something compiled performs
better than something interpreted isn't groundbreaking news :)

One thing I don't particularly like is that whenever I comment
some code, I find that the source hasn't been compiled because

```
src/exec/exec.go:8: imported and not used: "sync"
```

which means that I just commented some code that relied on an
external package and now, since that code is not used anymore,
the compiler warns me that "*hey, why are you importing a useless package?*"

Can live with this kind of stuff.

**Overall experience**: pretty solid. I love the fact that whatever
I write can be run on Windows without too much of a hassle, that
it produces a binary that **just works** and that you don't have
to worry about too many things. The transition, in terms of paradigm,
was pretty straightforward.

## Standard library

Go's standard library is rock-solid and quite vast:
give a look at the [list of packages](http://golang.org/pkg/) and you'll get
an idea.

The way the `godoc` commands presents packages, by the way, is
pretty good: you will see the docblocks for every package / function,
along with the annotated source:

{% img right /images/go-source.png %}

Overall, I feel someone's got my back when I have a problem:
you will usually find some package or small utility function
that will solve your problem or provide inspiration for your own
use case.

**Overall experience**: I think there is still a lot that can
be abstracted and put in Go's standard library, but the general
feeling I have is that's already very good. Sometimes I miss the
(3rd party) modularity that comes with JavaScript, but there are
a lot of [external packages](http://go-search.org/) for Go as well.

## Generics

This has been reported to me by more than one person, and I never understood
it until I actually had to face the "problem".

Go's [lack of generics](http://golang.org/doc/faq#generics) irritates
a few people, though I can ensure you can live without them without
having to worry too much.

In other words, **consider not having generics a feature**: you need to
live without them and design software in a way that doesn't allow
room for generics or, in other words, ambiguity.

**Overall experience**: it is probably true that generics add flexibility
to your development experience, but like the golang's website says, they
"*add complexity and extra cost in the type system and run-time*", so you'll
have to learn to live without them. I am ok with it.

## go fmt ./...

I wont waste too much time on this, but let's just say that, in
my opinion, we should have something like go's fmt in every single
programming platform.

{% img center /images/go-fmt.png %}

**Overall experience**: A W E S O M E ++

## Wonkiness

There are other small weird things that make Go look
wonky at first, ie. function visibility:

``` go
package mypackage

// protected
func doSomething() {
  ...
}

// public
func DoSomething() {
  ...
}
```

These sort of things might seem counter-intuitive,
but at the end of the day they all contribute to a
more coincise syntax{% fn_ref 4 %} and a more pragmatic
way of programming.

**Overall experience**: I would say Go's wonky enough :)
I don't like the syntax very much, but it's not like
I was coming straight out of the 7th heaven, being used
to JS and PHP. At the end of the day it's coincise and
decent enough that I feel pretty ok about it.

## Conclusion

I'm very happy of my experiment and I hope I'll be able
to play more with Go, as it seems to fill some gaps where
other programming languages / platforms aren't great at. I believe that
the overall development experience is quite nice and the
language is pretty easy to pick up, granted you have
a couple years of experience with software development in general.

Last but not least, lately I've seen [so many DevOps tools
being built with Golang](http://odino.org/5-technologies-you-should-keep-an-eye-on-in-2015/), and I can finally say
[we joined the party](https://github.com/namshi/godo) :)

{% footnotes %}
  {% fn lol, godo doesnt have tests #sorry %}
  {% fn European airlines... %}
  {% fn Of course, not everyone does Go there, but you get the point %}
  {% fn And, to be clear, I don't like Go's syntax overall %}
{% endfootnotes %}
