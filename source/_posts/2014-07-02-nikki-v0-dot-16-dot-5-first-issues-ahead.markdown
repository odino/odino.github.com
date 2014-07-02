---
layout: post
title: "Nikki v0.16.5: first issues ahead"
date: 2014-07-02 22:47
comments: true
categories: [nikki, JavaScript, release, IDE, NodeJS]
---

Today I migrated all the possible issues I knew
from [nikki](https://github.com/odino/nikki)'s
README to [github's issues](https://github.com/odino/nikki/issues), and started
addressing the first few of them.

<!-- more -->

> If you are new to nikki, you might want to read
> [this introductory post](/last-weekend-i-wrote-an-ide-in-javascript/) I wrote a while ago.

Among the things I've been hacking on today:

* if you tried to open a non-existing directory the server
would crash, now it's simply telling you you're trying to do
something nasty
* I added [this awesome favicon](https://github.com/odino/nikki/blob/master/client/images/favicon.png) :)
* I ported the keyboard shortcuts to the Mac:
whatever you were able to do with `ctrl` now is also available
with `⌘`
* when you boot nikki, now, you will be able to see it running
under the name `nikki` in the process' list (try a `ps -ef | grep nikki`)
* you can customize the [mappings for syntax highlighting](https://github.com/odino/nikki/blob/master/.nikki.yml#L9-L25) by adding
them in your `.nikki.yml`

Contextually, I released `v0.16.5`, so simply run an
`npm update -g nikki` and enjoy this bunch of new things!