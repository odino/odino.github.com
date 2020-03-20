---
layout: post
title: "Using gists like git repositories"
date: 2015-07-14 17:27
comments: true
categories: [gist, github, git]
description: "A hidden feature of gists is the ability to act as a git repository: here's how to take advantage of it"
---

In the past couple of years I've been using [gist](https://gist.github.com/)
to take notes and stash around small utility scripts I've had to run
once in a while.

For all of this time, though, I didn't really take advantage
of the fact that [each gist is an actual git repo](https://help.github.com/articles/about-gists/), which
gives you a lot of flexibility the online interface doesn't
bring to the table.

<!-- more -->

Once you create a gist, you can simply note down its id and
clone it locally:

```
git clone git@github.com:YOUR_GIST_ID.git that-infamous-script
```

and after applying your changes and committing, you can simply
push the changes to the gist (with a good old fashioned `git push origin master`)
and you will see them at
`https://gist.github.com/YOUR_USERNAME/YOUR_GIST_ID`.

Never underestimate the power of gists!