---
layout: post
title: "WiFi not connecting or being wonky on a Dell XPS in Ubuntu 13.04"
date: 2013-08-18 23:51
comments: true
categories: [ubuntu, linux, wifi, hardware, xps]
---

Today, even though I come from a weekend
of barely sleeping, I decided, after an entire
day unable to connect to the WiFi of the office,
to try to fix this issue that seems to be affecting
the Dell XPS harder than other laptops.

<!-- more -->

After googling for a while and realizing that
even at home I got no luck with my wireless,
I decided to go on with my own usual solution,
which means **downgrading the kernel or grub**.

You can get a list of the *installables* from
any terminal:

```
 dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d'
```

And since I'm currently using `3.8.0-27-generic`
I decided to give a slightly previous one a try;
let's edit grub:

```
sudo /etc/kernel/postrm.d/zz-update-grub 3.8.0-19-generic /boot/vmlinuz-3.8.0-19-generic
```

This solved the issue, at least for me ;-)