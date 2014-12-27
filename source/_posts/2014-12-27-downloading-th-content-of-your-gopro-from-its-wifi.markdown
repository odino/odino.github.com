---
layout: post
title: "Downloading the content of your GoPro from its WiFi"
date: 2014-12-27 20:55
comments: true
categories: [hardware]
---

During my last vacation I had some troubles
making my [GoPro](http://gopro.com/) visible
to Ubuntu through the USB charger so I decided
to go for a different approach.

<!-- more -->

Turns out that the camera itself exposes an HTTP
server, which lists the contents of the camera, at
[10.5.5.9:8080](http://10.5.5.9:8080), so after
turning on the WiFi hotspot on the camera and
connecting my laptop to it I just needed to:

```
wget -r http://10.5.5.9:8080/
```

Thanks to [Lucio](https://www.linkedin.com/in/unlucio)
for suggesting the `-r`!