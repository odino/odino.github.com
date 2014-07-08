---
layout: post
title: "Nikki 0.19.1: awesomeness won't stop"
date: 2014-07-07 17:30
comments: true
categories: [nikki, NodeJS, JavaScript, github, OSS, open source]
---

Given it's Ramadan and we have some spare time at the
end of the day, I'm getting the chance to be
[quite active](https://github.com/odino/nikki/commits/master)
with the development of [Nikki](https://github.com/odino/nikki).

<!-- more -->

> If you are new to nikki, you might want to read
> [this introductory post](/last-weekend-i-wrote-an-ide-in-javascript/) I wrote a while ago.

I figured out the best way to document these changes, besides
writing a blog post, would be to document them with
[Github issues](https://github.com/odino/nikki/issues?direction=desc&page=1&sort=updated&state=closed)
and by beefing up the [README](https://github.com/odino/nikki/) -- so 
you should definitely have a look there.

## What's new?

{% img center /images/nikki-0.19.1.png %}

The biggest change is that you are now gonna be running nikki
as a [detached process](https://github.com/odino/nikki/commit/efecd05ab8a02406d63011e465850f2931ecef07):
once you start nikki you will see it running on port `9123` (by default)
and you will be able to stop it with a simple `nikki --stop`; to
check whether nikki is running simply run a `nikki --status`.

This change was made possible using node's spawning capabilities
and [dnode](https://github.com/substack/dnode), which lets you
implement [RPC](http://en.wikipedia.org/wiki/Remote_procedure_call)
in NodeJS: once you start nikki the main process spawns itself,
the spawned one listens on `9124` for signals and the main process
ends; when we issue `nikki --stop` we will just be sending a
`shutdown` signal to the spawned nikki
process through an RPC call.

Other changes?

* added the `ctrl + shift + l` shortcut to [close editor tabs](https://github.com/odino/nikki/commit/40899aaeecb70c02c1c1a00e566335d190508c2f)
* once you re-open nikki, tabs that were open at the time you closed [will be open again](https://github.com/odino/nikki/commit/daa95c0efd3022b744016830e2f7995cea138a52)
* using [jQuery 2.X](https://github.com/odino/nikki/commit/7e2f2baec4eb2aec7ba2980de2a82d8ab2b1bff5)
* "[open in github](https://github.com/odino/nikki/commit/1a3fd2605ed6f325409fd8d489bd624a72d8a7af)" you can now configure nikki so that
once you use the `ctrl + g` shortcut in a file it will open it, in github, in a new broser tab
* added [filesystem icons from fontawesome](https://github.com/odino/nikki/commit/46e5c1881b6ca331b64cc470086f7af7936af69e)
* when you search for files, now, the [file path will be shown next to the filename](https://github.com/odino/nikki/commit/649106f5d491165b3e1c982cbb76e9967cb81c0d) (so if you have 3 `index.js` in your codebase...   ...no worries anymore!)
* [debug mode](https://github.com/odino/nikki/commit/7db31f927b3027dfa1408e2af84b6806a6b91d12), so that you can troubleshoot problems in an easier way

## What's fixed?

* navigation used to show [incorrect](https://github.com/odino/nikki/commit/d829129992e5e42eed54f7f13492254f3b3df08d) [paths](https://github.com/odino/nikki/commit/b463eab67816c8fa1c02d30af019e2a9628be458)
* inconsistencies with the [file search](https://github.com/odino/nikki/commit/4450b27ea477f119b3d7a32a27a37606687ccae0)
* [shortcuts conflicts](https://github.com/odino/nikki/commit/041397e71198599cc6c4a2ec06a706aff0c72623) with the ACE editor

## How to get all these changes?

As simple as running an `npm install -g nikki` if this is the first time
you hear about it: for the ones who already have it installed on their
systems simply run a `npm update -g nikki`.

Then open a terminal, type `nikki` and let the show begin!

## What's next?

I will be implementing filesystem operations in these days (delete / create
files and folders) and probably refactor some of the key frontend components, like
the keyboard shortcuts.

Keep an eye on the [github project](https://github.com/odino/nikki) and let me know your feedback!
