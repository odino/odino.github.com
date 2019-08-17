---
layout: post
title: "The ABS playground: run ABS code directly in your browser (WHOOOOP!)"
date: 2019-08-17 18:45
comments: true
categories: [ABS, open source, WebAssembly, JavaScript]
description: "An amazing journey into WebAssembly allowed me to build the ABS playground, where you can run ABS code directly in your browser."
---

{% img right /images/wasm.png %}

Remember the last time you thought "ough, JavaScript"?

Well, that's me every other day: I love JS for
its flexibility and dynamism, but I also sometimes find
it painful to deal with, especially in some
specific programming contexts.

If you, like me, hoped to be able to write
something other than JavaScript in order to get
stuff done on the web, chances are you bumbed
into [WebAssembly](https://en.wikipedia.org/wiki/WebAssembly) (abbr. WASM),
and considered it your holy grail. WASM
is a portable binary format that's been
[implemented by all major browsers](https://caniuse.com/#search=wasm) and
allows other languages to be compiled for the
web.

Why is that important? Well, that's the key
of how I managed to run an ABS playground
(a code runner) on the browser.

<!-- more -->

## The original issue

One of ABS' main contributors, Ming, [smartly
suggested](https://github.com/abs-lang/abs/issues/236) that it would be interesting to let
users play around with ABS without having it
installed on their systems.

My first thought was to replicate the [Go playground](https://play.golang.org/),
but that would have meant setting up a server-side
code-runner, and that would have required
more time (maintenance) and money (server cost)
that we had on hand.

We abandoned the idea of a code runner for a while,
until we thought of something creative...

## WASM to the rescue

[Go recently added support for WASM](https://github.com/golang/go/wiki/WebAssembly)
as one of its compilation targets, meaning you can
run Go applications on the browser -- you just
need a simple `GOOS=js GOARCH=wasm go build -o script.js script.go`
and you're set with an executable that can run within the
browser.

I then thought: what if we could compile the ABS interpreter,
which is purely written in Go, to WASM?

The result is a simple ["JS" distribution of the ABS
interpreter](https://github.com/abs-lang/abs/blob/4112e3ef13b595ef39e55c4be8d5314004037d62/js/js.go),
50 lines of code that bring ABS to the browser!

The downside of compiling Go into WASM is that the
binaries are a bit heavy ([ABS is 4.3 MB](https://github.com/abs-lang/abs/blob/master/docs/abs.wasm)),
but, considering that this is more of a proof-of-concept
than a serious attempt to run ABS in the browser, I
can't really complain.

Armed with a distribution of the ABS interpreter that
can run within your browser, I then setup a [silly HTML
page in our docs](https://raw.githubusercontent.com/abs-lang/abs/4112e3ef13b595ef39e55c4be8d5314004037d62/docs/playground.md)
that would load the WASM binary and give you a textboxt
to play around, which brings me to the big announcement...

## Welcome to the ABS playground!

Without further ado, please head over to
[www.abs-lang.org/playground](https://www.abs-lang.org/playground):

{% img center /images/abs-playground.png %}

You can try most of ABS' features directly in
the web editor: simply write some code, hit
`Ctrl+Enter` and see the result pop in front
of your eyes!

Let me know if you have any feedback!

