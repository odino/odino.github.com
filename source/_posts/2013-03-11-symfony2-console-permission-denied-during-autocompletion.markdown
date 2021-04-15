---
layout: post
title: "Symfony2 console: permission denied during autocompletion"
date: 2013-03-11 10:11
comments: true
categories: [symfony2]
---

Yesterday I faced a pretty cryptic issue
while using the Symfony2 console (`app/console`).

<!-- more -->

I guess the error is pretty common, and it's really
easy to fix, since the problem is that
[the binary is not executable](https://github.com/hacfi/oh-my-zsh/commit/8c74d80fd6cdc7e1b48e7eb321a3e3a22674c3be):

```
chmod +x app/console
```

...and you're done.