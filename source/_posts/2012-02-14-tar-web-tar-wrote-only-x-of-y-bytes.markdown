---
layout: post
title: "tar: web.tar: Wrote only X of Y bytes"
date: 2011-02-02 12:16
comments: true
categories: [linux]
alias: "/278/tar-web-tar-wrote-only-x-of-y-bytes"
---

So you are trying to compress a directory or whatever file on your disk, probably from SSH, and experience no useful errors?
<!-- more -->

I **really hate** this kind of error reports:

```
tar: web.tar: Wrote only 6144 of 10240 bytes
tar: Error is not recoverable: exiting now
```

That's *tar*.

If you try Gzip, it will say that there's not enough disk space: but if you have no clue about that, or can't use Gzip, try a

```
df -h
```

to find out that it really is a disk space issue.