---
layout: post
title: "I have built my own IDE and I'm happy to trash it after a year"
date: 2015-08-01 11:42
comments: true
categories: [nikki, open source, javascript, atom, github, nodejs]
---

{% img right /images/nikki-logo.svg 180 %}

Last year I dedicated quite some time, [during ramadan](https://github.com/odino/nikki/graphs/contributors), to a project
I really cared about: building a **fast and smart text editor** to use
on a daily basis.

That's how [Nikki was born](/last-weekend-i-wrote-an-ide-in-javascript/), and today I am happy to announce that the
project is dead, simply because I found another, very similar tool
that does the job.

This is the story of **how open source projects get born and die**,
and why we should still celebrate it.

<!-- more -->

## Preface

I had been using [PHPStorm](https://www.jetbrains.com/phpstorm/) for quite some time and I was happily
paying its license since, in the PHP world, it seemed like no
editor could match its features while performing that fast: the
problem was that PHPStorm was still an IDE at its core, meaning
that to be able to write a couple lines of code I needed to wait
at least 10 seconds for it to boot the GUI, scan the current project,
look for updates, cook dinner, do the dishes and whatever else
it needed to do...

See, it's been a while **I changed job**: at [Namshi](https://www.namshi.com) I'm no longer the guy who is
going to implement long-term features or will need to spend a lot of time on a single, monolithic
project; right now I am mostly kicking new projects off, adding
small features, pairing or discussing with the team what kind of
design to use and so on: most of my time is really spent in
scripting over microservices which, in my opinion, rarely require
an IDE, especially when they're written in JavaScript.

At the end of the day our typical project looks very slim: if
I compare the size of our initial API layer (a Symfony app with
lots of bundles and abstraction) to our newest services (express
apps with 10/15 files in total{% fn_ref 1 %}) they look like night
and day; our node microservices ain't very complex and are quite
self-explanatory: you won't need to navigate through a lot of
methods to understand the responsibilities of each module.

Want to make an API call? Just open `api.js` and
see which methods are public:

``` javascript api.js: an example module that wraps some API calls
function request(uri, params) {
  // ...
}

function getCustomer(email) {
  return request('/customers/' + email);
}

module.exports = {
  getCustomer: getCustomer,
  //  ...
}
```

This transition happened around a year and a half ago, and
I started growing frustrated of PHPStorm as it wasn't very helpful
for my use-case: it was doing too much, taking too long.

Time to look for an alternative!

## Looking around

There were a few alternatives at that time:

* [sublime](http://www.sublimetext.com/)
* [lighttable](http://lighttable.com/)
* a pimped [gedit](http://grigio.org/pimp_my_gedit_was_textmate_linux/)

but none of them felt "right": either they didn't have a
vibrant community behind them or they simply lacked of
coolness (I'm looking at you, gedit).

So far I couldn't find a real winner amongst them, so I started thinking that
writing a simple thingy on my own would have been a very
good learning experience now that the new [socket.io](http://socket.io/)
had just been [released](http://socket.io/blog/introducing-socket-io-1-0/).

I mean, you can create editors in [one line of code](https://coderwall.com/p/lhsrcq/one-line-browser-notepad),
how big of a task would this be?

## Enter Nikki

That's how Nikki was born: I put up some [crappy frontend](https://raw.githubusercontent.com/odino/nikki/master/bin/images/nikki-ss.png)
and made it talk with a simple NodeJS server that would have
fun browsing, opening and modifying files on my machine.

I can't say that the code was the [best I've ever written](https://github.com/odino/nikki/blob/master/server/socket.js#L81-L93)
(especially on the [frontend](https://github.com/odino/nikki/blob/master/client/scripts/fs.js) :-P), but
at the end of the day I got the chance to play with socket.io,
[dnode](https://github.com/substack/dnode), learned how to "[daemonize](https://github.com/odino/nikki/commit/efecd05ab8a02406d63011e465850f2931ecef07)"
a node process, played with the [ACE editor](http://ace.c9.io/) and
learned [how to watch for file changes in Node](https://github.com/odino/nikki/commit/704927c369ef156d3d03d90af68853657328c5f4) (and the fact that this feature was [quite unstable](https://nodejs.org/docs/latest/api/fs.html#fs_fs_watch_filename_options_listener)):
I dedicated a lot of time to Nikki but I also practiced
a lot with new tools and patterns, which resulted in me getting to know
the platform and becoming more confident with JavaScript{% fn_ref 2 %}
as the days went by.

I'm not lying: whenever I needed to start a new project or make some
changes my terminal would look like:

```
~ (master ✔) ᐅ cd projects/something
~/projects/something (master ✔) ᐅ nikki
```

and my browser would open on port `9123` and let me code in milliseconds:
how nice it felt!

Of course, Nikki didn't have a community behind it so
[features or bugfixes took me some time](https://github.com/odino/nikki/issues?q=is%3Aissue+is%3Aclosed)
but, by using it on a daily basis, I made sure that it
wouldn't crash or misbehave -- else I would have grown
frustrated at my own child!

## Then, one night...

{% img right /images/atom.png %}

This went on for over a year: I think I was the only guy
on the planet using it, and it still made me feel very proud
as it fit my needs very well.

At the same time, I got very curious when I first heard of [Atom](https://atom.io/)
as it felt modern (JavaScript) and cool (GitHub), though, as soon as
GitHub released it, I realized it was still missing a couple things:

* not battle-tested
* not a huge community
* no Linux build

The first 2 points were quickly resolved: developers started to love
the "hackable text editor" and the community beefed up in a very short
span of time, meaning that the project could reach a stable
version very quickly as lots of people were using and testing it{% fn_ref 3 %}.

A working version for Linux came into existence after
a few months, which meant that Atom was ready for me:
then, one night, I decided to format my machine and give
it a brand new life, a good excuse to **try something new**.

I installed Atom and never looked back: it behaves quite like Nikki{% fn_ref 4 %},
has plugins, a well-tested ground and has a huge community of users / developers
ready to help: this product **makes much more sense**. I am
happily using it since a month or so and I **totally love it**: the way it uses
shortcuts for a ton of things, "open in github", the speed it takes to open
up, how simple it is to customize...

...and here we are: now that **Nikki is dead**, was it a wasted effort?

## Let's celebrate Open Source

I think, on a smaller scale, PHPStorm, Nikki and Atom represent a very
common pattern in technology and Open Source: a cool project that
doesn't age very well, or needs to adapt to new technologies.

The same has happened with Solr, just a few years ago: ElasticSearch
was born and Solr suddenly lost its coolness.

The same is happening with Python and Golang.

The same for the [Zend Engine](https://en.wikipedia.org/wiki/Zend_Engine)
and [HHVM](http://hhvm.com/).

Same for Ruby and NodeJS.

Might be that the same will happen for [Graylog](https://www.graylog.org/) and [Sentry](https://github.com/getsentry/sentry).

Now...you got me.

The beauty of Open Source is that **no one
will prevent you from converting your ideas into working code**: great
engineers will develop a new product, the underlying technology
will age and look less appealing in 1, 3 or 5 years and a new
group of developers will pick those great ideas, patterns and
implement them on their own, on a newer, different platform, to
provide some competition to the "old guys".

At the end of the day, I have 3 key takeaways from this experience:

* **community wins**: no man is an island, you should look for help
and be guided by the community as they most-likely had your same
problem and already found an answer. In most cases, follow what smart
people do and look at the size of the community, as that will tell you
how big of a reach the project has
* **OSS is a phenomenal learning experience**: open source your code,
use the tools that the community gives you. Even if you have to trash
it after a few months you'll probably learn so much on your way to `v1.0`
* **don't go too far**: do not think that you are going to create
the Next Big Thing, keep a low profile and learn not to love code:
it doesn't age well and there will always be someone that can write
a faster and more elegant version of your function. From [libcontainer's principles](https://github.com/docker/libcontainer/blob/master/PRINCIPLES.md):
"*Don't try to replace every tool. Instead, be an ingredient to improve them*"

With this in mind, I am still glad I wrote Nikki: it was a truly great
learning experience.

**Check**.

And I'm still happy to trash it: it served
its purpose, I knew its limitations and led me to another great tool.

**Check**.

And yeah, I'm super-excited for who's going to challenge Atom.<br />
That's the way it is, the way it will always be.

{% footnotes %}
  {% fn Plus tests...   ...most of the times :-P %}
  {% fn Back at the time my go-to language was still PHP, whereas now I can almost only do JS %}
  {% fn Funny enough, a couple guys at the office told me they tried it way back at the time and weren't happy with it because it used to be quirky %}
  {% fn or...I should say Nikki behaves quite like Atom :) %}
{% endfootnotes %}
