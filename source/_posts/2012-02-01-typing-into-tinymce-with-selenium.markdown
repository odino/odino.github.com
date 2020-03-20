---
layout: post
title: "Typing into TinyMCE with Selenium"
date: 2010-09-11 13:48
comments: true
categories: [testing]
alias: "/325/typing-into-tinymce-with-selenium"
---

Since TinyMCE has a questionable behaviour, because it creates an iframe to render the editor, SeleniumIDE has some problems with it.
<!-- more -->

If you record a test typing into the editor, then, when you'll run it, it will miserably fail: that's because, when recording the test, Selenium isn't able to detect that you have typed in a iframe.

So, if your form's textarea has the `myTextarea` id, the iframe TinyMCE will output in order to enrich the textarea will have the same id, with a `_ifr` suffix.

So you need to tell selenium to focus on that iframe:

``` html
<tr>
	<td>focus</td>
	<td>myTextarea_ifr</td>
	<td></td>
</tr>
```

then you'll need to type into the iframe body:

``` html
<tr>
	<td>type</td>
	<td>tinymce</td>
	<td>My text into TinyMCE</td>
</tr>
```