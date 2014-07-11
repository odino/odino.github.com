---
layout: post
title: "Nikki 0.25.1: let's play with the filesystem!"
date: 2014-07-11 17:40
comments: true
categories: [nikki, OSS, open source, NodeJS, JavaScript]
---

In the last 24 hours I rolled out some changes
I actually personally needed to get way more
productive than ever on nikki, and leave my old-school
IDE turned off.

<!-- more -->

> If you are new to nikki, you might want to read
> [this introductory post](/last-weekend-i-wrote-an-ide-in-javascript/) I wrote a while ago.

## What's new?

Probably the most needed feature, at least by me,
is to be able to look for a text in files, and
it has been [rudimentally implemented](https://github.com/odino/nikki/commit/6e6540147d6c0d165ab0aad3d4ed7bd267eb9f5f)
while  I will focus, in the next days, on how to
make this much more user-friendly: in any case,
by activating the search bar through `ctrl + shift + g`
you are going to search in `grep` mode, which means
that instead of looking by file name we are gonna
grep the content of those files.

{% img center /images/nikki-0.25.1.png %}

As you see in the screenshot above, Nikki then
returns you a list of files and highlights the matches:
what I  want to work on, then, is to be able to
click on those matches and open that file
at that specific line.

How about other changes?

* we are [watching the FS now](https://github.com/odino/nikki/commit/704927c369ef156d3d03d90af68853657328c5f4), so if you touch a file
from your terminal you'll magically see it appear in nikki!
* when searching for files with `ctrl + shift +f` you are now gonna be able to also [look for directories](https://github.com/odino/nikki/commit/bae2c1b51617551bf814869e815a2eea1246a8cb)
* generally improved the search: now `proj gu .js` will match `/path/to/projects/test/gulpfile.js`
* nikki will now show the current focus (filesystem / search / editor) right [above the editor](https://github.com/odino/nikki/commit/fb1d05f2eac3370348d41158a2e55c337d28a874)
* added the [awesome nikki logo](https://github.com/odino/nikki/commit/17a4dd7a7c53a7fa5a6c360818857e35eb246143)
* you can configure the [keyboard shortcuts](https://github.com/odino/nikki/commit/5f2b680750bccac228e471fdb7b81762df8bde0c)
* you can now [delete files and directories](https://github.com/odino/nikki/commit/79f37e158417a9ea6b6dfa7a50f06b25a046cf4f): simply hover on a file and press `delete`

## What's fixed?

* when you move between tabs, now nikki will [remember the position of the cursor](https://github.com/odino/nikki/commit/d294446cc089207db143324a192827bcb636b65c) on each tab
* issues while [focusing on the filesystem](https://github.com/odino/nikki/commit/a38be0e0c14cab6036d52a585c165bcd34baf4dd)
* nikki [would epically crash](https://github.com/odino/nikki/commit/36a820025db61a30e55735e733888d25fa2fe2c1) if you have an open tab that points to a file, you delete it, and then refresh nikki, as it couldn't  find the file
* fixed [a crash](https://github.com/odino/nikki/commit/1bce21bb0b60d7bbca1a3993d0b652cfff27178f) when re-opening a tab after closing all tabs
* small, informative [fixes](https://github.com/odino/nikki/commit/81c197f655cf4d06402ab5c930fc0bdb08e0bbd0)

## How do I get all this awesomeness?

As simple as running an `npm install -g nikki` if this is the first time
you hear about it: for the ones who already have it installed on their
systems simply run a `npm update -g nikki`.

Then open a terminal, type `nikki` and let the show begin!

## What's  next?

I'm giving 100% priority to bugs before implementing new features:
given I'm using nikki on a daily basis I usually find [gotchas](https://github.com/odino/nikki/issues?direction=desc&labels=bug&page=1&sort=updated&state=open)
and fix them straight away.

If there are not gonna be too many fixes to do I will focus
on making the editor "smarter", by improving the search in files
and adding find / find & replace functionalities (the ACE editor
has built-in support for them, so shouldn't be that much of
a problem).

Keep an eye on the [github project](https://github.com/odino/nikki) and let me know your feedback!
