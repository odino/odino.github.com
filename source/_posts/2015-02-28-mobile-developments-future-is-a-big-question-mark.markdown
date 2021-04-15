---
layout: post
title: "Mobile development's future is a big question mark"
date: 2015-02-28 18:48
comments: true
categories: [mobile, android, ios, development, javascript, reactjs]
published: true
description: How will the mobile development ecosystem look in 5 years? The current landscape isn't very exciting, and I feel there might be revolutions ahead
---

In the past 5 years, mobile devices have taken
the world by storm, creating new opportunities
for both consumers and vendors: truth is, the
landscape of mobile **development** still looks
very immature and we should be prepared to see a
radical change in the next 2 to 5 years.

<!-- more -->

## A suboptimal development industry

As we all agree, [duplication is something bad](http://en.wikipedia.org/wiki/Duplicate_code)
in software engineering: it leads to unmaintainable,
error-prone code that requires a signicant effort
to be fixed.

If you are a mobile factory or a product-company
with its own apps-development team, you might be
familiar with the annoying problem of fixing, or
implementing, the same thing twice.

Nowadays, unfortunately, **duplicate efforts are the norm
while developing mobile apps**: you have to reproduce
the same behaviour across different platforms (ios
and android, but add blackberry or windows phone if you're
not that lucky) which led people to create tools like
[cordova](http://cordova.apache.org).

Problem is, these tools ain't the solution: they don't work
as nicely as native apps, they probably hide too
much from the developer and vendors aren't keen
on supporting them that much. If you, like me,
gave stuff like [ionic](http://ionicframework.com/) a try,
you probably first found yourself surprised by
how nice your demo app would look and behave,
to then just find out that **the more you were
implementing, the quirkier it looked**.

On another note, the decision on how to structure
the team isn't trivial as well: shall
I get devs who can hack on both
platforms? Let's create 2 separate teams? Shall I
get 2 lead developers or 1 guy that has a good
sense on how both platforms work?

We need things to be better: just like the web,
mobile is now a scary land of vendors-dictated
"standards". **We don't need another JavaScript.**

## The need for standards

I don't think mobile is much different to what
JavaScript used to look like until 3/5 years ago:
a lot of vendor-specific standards, weird tools
that try to uniform these platforms and a plethora
of things that just don't feel "right".

We need uniform APIs, we need to be able to rely
on the same toolchain (for example, official [staged rollouts](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en) on the Apple Store)
and we need the same kind of transition the JS
ecosystem has seen: vendors need to
come together and design all of these things
altogether, agree on a minimal interface to share
and get ready to kill the mess.

Of course, there are a bit more complications here,
as we are talking about very different platforms,
with different development tools and workflow, which
is why I think we will see huge changes, from this
point of view, in the next 3 years.

## How will it look like?

I have been telling people for a while that I do not
believe this multi-platform, fragmented ecosystem
can last for long, as I think it will eventually
lead vendors to agree on a common platform to work on.

I don't necessarily think it needs to be Objective-C,
but it definitely [won't be Android on Java](http://www.reddit.com/r/androiddev/comments/27mu3v/why_do_android_dev_tools_still_suck/).
At the same time, I don't know how interested Apple
would be in making Swift / Objective-C a thing for the
masses ([the masses are interested though](http://stackoverflow.com/questions/7133728/objective-c-in-linux)).

At the end of the day, thinking of **one, unified mobile
platform** seems kind of crazy today but, in 5 years,
devs would look back and wonder "how could we do it like
that, to be wasting efforts on so many different platforms?".

## My personal feeling?

At the end of the day, all we need is to give a popular
language a simple API to be able to completely access
your device.

That language's name is probably JavaScript{% fn_ref 1 %}.
And that API is probably something like [JavaScriptCore](http://trac.webkit.org/wiki/JavaScriptCore).

Since [React Native](http://www.railslove.com/stories/fresh-on-our-radar-react-native)
seems to be already halfway through the journey of
making all of this real, my feeling is that it won't
take long until vendors will realize that the
easiest thing to do is to **give JavaScript a (real) shot**.

KTHXBYE.

{% footnotes %}
  {% fn I know that it sounds a bit counter-intuitive since I earlier said that "we don't need another JavaScript", but there I was referring to what JS used to look like 3/5 years back (= a mess). We've come a long way, though there's still a lot we can do :)  %}
{% endfootnotes %}