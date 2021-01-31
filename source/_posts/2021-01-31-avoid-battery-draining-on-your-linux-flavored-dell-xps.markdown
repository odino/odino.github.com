---
layout: post
title: "Avoid battery draining on your Linux-flavored Dell XPS"
date: 2021-01-31 14:40
comments: true
categories: [linux, XPS]
description: "One easy kernel parameter to make sure your battery doesn't drain overnight."
---

{% img right /images/dell.png %}

Over the past few months my 2.5yo Dell XPS 13 has started showing signs of age,
and I had to worry both about my keyboard as well as the battery.

I haven't really managed to replace the keyboard yet (I'm too scared of doing
it on my own, so I'll wait to go back to the office and ask the IT folks
to do it for me), though I managed to replace the battery (got it from [Noon](https://www.noon.com/uae-en/replacement-battery-for-dell-xps-13-9360-black/N32141819A/p?o=a03e5f5f47c3ba5b)) since my old one was at <40% capacity.

A factor that contributed to the battery's demise was definitely the fact that,
through a recent kernel update, the laptop started shutting down in [s2idle](https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/pm/sleep-states.rst#suspend-to-idle)
sleep mode, which is short for "no bueno" -- it basically means that the system
will use a pure software implementation of energy savings.

<!-- more -->

The fix is generally fairly easy -- you can see what sleep state your
system is going to use by:

```sh
$ cat /sys/power/mem_sleep
[s2idle] deep
```

and a quick and easy fix is to switch to the [deep](https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/pm/sleep-states.rst#suspend-to-ram) state:

```sh
sudo bash -c "echo deep > /sys/power/mem_sleep"
```

Et-voila:

```sh
$ cat /sys/power/mem_sleep
s2idle [deep]
```

Now, as usual, this change is not going to be permanent, as we need to
register the kernel parameter either in systemd or grub, depending on what your system is running
on.

Remember: a battery will only last you ~500 charges, so making sure you save as much
energy as possible while the system is resting will allow you to defer a purchase by
months or years.

Adios!