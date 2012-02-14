---
layout: post
title: "FFMPEG: get a thumbnail from a video with PHP"
date: 2010-09-11 10:28
comments: true
categories: [PHP, ffmpeg]
alias: "/72/ffmpeg-get-a-thumbnail-from-a-video-with-php"
---

Here's a simple tutorial in order to **extract a thumbnail from a video** using FFMPEG and PHP.
<!-- more -->

First of all let's install FFMPEG ( you probably already got it if you know what kind of kick-ass video manipulator it is ):

``` bash
sudo apt-get install ffmpeg
```

Then let's set up our script: the main problem is the use of the `shell_exec()` function, in order to run a shell command inside PHP.

If you don't know anything about `cmd()`, `shell_exec()` or shell escaping please don't use this tecnique and go ahed to [php.net](http://php.net) to read some documentation about it.

At least, you also need to have `shell_exec()` enabled in your server, so shared hosting won't fit your requirements.

Here's the way:

``` php
<?php

$video = 'path/to/video.flv';
$thumbnail = 'path/to/thumbnail.jpg';

// shell command [highly simplified, please don't run it plain on your script!]
shell_exec("ffmpeg -i $video -deinterlace -an -ss 1 -t 00:00:01 -r 1 -y -vcodec mjpeg -f mjpeg $thumbnail 2>&1");
```

so you'll be able to see your thumbnail of the video at the location you specified.
