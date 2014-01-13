---
layout: post
title: "Drop OpenJDK and upgrade Java to the Oracle packages"
date: 2013-11-10 08:59
comments: true
categories: [Java, Ubuntu]
---

A few weeks back I started noticing some performance
issues on my [IDE](http://www.jetbrains.com/phpstorm/) and decided to investigate a bit more
on it: turns out that they recommended to 1) upgrade to
the latest JDK (7) and stop using [OpenJDK](http://openjdk.java.net/), as it has
some performance gotchas.

<!-- more -->

{% img left /images/java.png %}

Turns out to be a no-brainer thanks to the [apt repository manager provided by flexiondotorg](https://github.com/flexiondotorg/oab-java6):

```
cd ~/
wget https://github.com/flexiondotorg/oab-java6/raw/0.3.0/oab-java.sh -O oab-java.sh
chmod +x oab-java.sh
sudo ./oab-java.sh
```

After running it you just need to re-install all the packages:

```
sudo apt-get install oracle-java7-jdk oracle-java7-jre oracle-java7-plugin
```

and tell ubuntu that the JDK version and location has changed:

```
sudo update-alternatives --config java
```

A quick check with `java -version` and then enjoy it!