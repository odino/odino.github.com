---
layout: post
title: "Border radius and IE 8 and previous yes we can"
date: 2010-09-11 14:51
comments: true
categories: [CSS]
alias: "/50/border-radius-and-ie-8-and-previous-yes-we-can"
---

CSS3 is the way to render a web2.0 layout without pain in the ass.
<!-- more -->

Unfortunately, IE8/7/6 doesn't support the border-radius attribute, which is one of the coolest things that CSS3 implements ( after font-face ): let's see how we can make our site look good also in crap-based browsers ( = IE X ).

We just need to download an [.htc file at Google Code project curved-corner](http://code.google.com/p/curved-corner/).

Then the CSS syntax is similar to the non-ie-compliant one:

``` css
.myPainInTheIE {
  -moz-border-radius:10px;
  -webkit-border-radius:10px;
  behaviour:url(path/to/border-radius.htc);
}
```
