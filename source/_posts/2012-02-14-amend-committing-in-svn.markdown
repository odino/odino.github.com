---
layout: post
title: "Amend committing in SVN"
date: 2010-10-30 11:06
comments: true
categories: [svn]
alias: "/239/amend-committing-in-svn"
---

Amending, in Git, is one of my favourite features: it basically lets you modify your local history ( unpushed ) to correct mistakes. Or, more often, to **add the missing file**.
<!-- more -->

**Obviously**, in SVN there isn't something like the amend, and we're forced to double-commit to send an atomic and consistent software ( merged with our last changes ).

I've seen lot of devs, in **amend situations**, committing with messages like:

* repeated last commit
* added a file I forgot on last commit

or leaving the message blank, or, worse, repeating the commit message.

None of these types of messages are significant.

## Why?

Repeating commit messages drives other people nuts, while leaving blank messages can be a bad practice others in the team do. Although it's an ugly practice we need to differentiate.

Explicative messages, suck the the two on the list above, are a waste of time: our last commit message was already describing the whole changes, although we forgot to phisically add/delete files or whatever.

So, SVNers, add a message like `amend` or `amend r:64` to your amends, nothing more!