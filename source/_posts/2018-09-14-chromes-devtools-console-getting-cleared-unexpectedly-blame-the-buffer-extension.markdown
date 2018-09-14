---
layout: post
title: "Chrome's DevTools console getting cleared unexpectedly? Blame the Buffer extension!"
date: 2018-09-14 13:11
comments: true
categories: [chrome, buffer, devtools]
---

{% img right /images/devtools.png %}

This was a funny one! After weeks thinking the Chrome team might have messed up,
I finally got frustrated and looked for an solution to one of the weirdest problems
I had encountered: the DevTool's console getting cleared unexpectedly.

<!-- more -->

I use the console on a daily basis to be able to debug applications,
so it was fairly annoying to see the logs being wiped out unless I ticked the
"*Preserve log*" checkbox -- an error would occur, I would open the console only
to find it blank. To make the matter worse, if I'd try to reload the page, I could
see the error blink on the console for a fraction of a second, only for it to be
cleared under mysterious circumstances.

Eventually, after a few weeks of enabling "*Preserve log*", I bumped into [this
thread on Chrome's forum](https://productforums.google.com/forum/#!topic/chrome/NIdgxE4UnGQ)
and realized I had Buffer installed as well: turning off the extension magically
gave me my console back. Don't ask why, don't ask how -- all that matters to me
is that I got my DevTools back :)

Adios!
