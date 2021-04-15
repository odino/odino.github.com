---
layout: post
title: "ABS 1.0.2: a small bugfix, a quick release"
date: 2019-02-02 13:09
comments: true
categories: [abs, scripting, programming language, open source]
description: "Just a quick one for a patch release of ABS, 1.0.2."
---

While getting ready for [1.0.0](https://odino.org/abs-1-dot-0-0-here-we-go/),
we merged some changes that created a very funny behaviour:

```
null == null # false
```

If you're wondering what the problem is, well, when we evaluate `null`
we always create a new [Null object](https://github.com/abs-lang/abs/blob/1.0.0/object/object.go#L82-L87) rather than re-using one (a-la singleton),
so when you end up comparing those 2 objects...well, they're different.

This was a [trivial fix](https://github.com/abs-lang/abs/pull/160) and
we've already released 1.0.2 to address the issue.  As usual:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!