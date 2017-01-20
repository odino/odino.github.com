---
layout: post
title: "Contributing to React Native for Android"
date: 2016-01-01 11:19
comments: true
categories: [react native, mobile, oss, github, react, android]
description: Let's see how we can run RN locally and patch it, so that we can give back to the community!
---

{% img right /images/reactjs.png %}

It is no news that we, at [Namshi](http://tech.namshi.com), like to play around with all
sorts of interesting technologies: last but not least, we're
taking a closer look at [react native](https://facebook.github.io/react-native/), the framework from Facebook
that allows you to build mobile, native apps with [React components](https://facebook.github.io/react/).

While developing a small prototype, we had a small issue with
a [WebView](http://developer.android.com/reference/android/webkit/WebView.html) that was supposed to run within our application and
wanted to enable [remote debugging on chrome](https://developer.chrome.com/devtools/docs/remote-debugging#debugging-webviews)
to troubleshoot it: since this is [turned
off by default](https://github.com/facebook/react-native/blob/e4272b456e6948c0942c610d3bc65bc29f0a7be6/ReactAndroid/src/main/java/com/facebook/react/views/webview/ReactWebViewManager.java#L77-L82), we had to recompile react native with webview
debugging enabled, and I wanted to share my brief experience with
it since, with the same approach, you can start hacking and
contributing to react native itself.

<!-- more -->

The guys have created a [small guide on how to compile RN from source](https://facebook.github.io/react-native/docs/android-building-from-source.html#content),
which can be summarized in just a couple steps: first, add the [android NDK](http://developer.android.com/tools/sdk/ndk/index.html) to
your environment and then configure the build system to build from source and
not from the [pre-built react-native packages](http://mvnrepository.com/artifact/com.facebook.react/react-native).

## Download and configure the Android NDK

Download the latest version of the NDK, make it executable
and run it: the package extracts itself in the current folder
and then you only need to set an environment variable
pointing to the NDK, so that the android build system will
be able to locate the NDK:

```
cd /somewhere
wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin
chmod a+x android-ndk-r10e-linux-x86_64.bin
./android-ndk-r10e-linux-x86_64.bin
export ANDROID_NDK=/somewhere/android-ndk-r10e
```

## Configure RN to build from source

This involves a few manual steps, but should be pretty straightforward.

In your react project, open `android/app/build.gradle`, you should see a
`dependencies` section like the following:

```
dependencies {
    compile fileTree(dir: "libs", include: ["*.jar"])
    compile "com.android.support:appcompat-v7:23.0.1"

    compile "com.facebook.react:react-native:0.17.+"
}
```

See, `compile "com.facebook.react:react-native:0.17.+"` tells the build system
to get the pre-built packages, released by facebook, rather that building react-native
from your local sources.

Now, change that line to:

```
compile project(':ReactAndroid')
```

then open `android/settings.gradle` and tell the build system how to locate
the new project that will be compiled; add, at the bottom of the file:

```
include ':ReactAndroid'

project(':ReactAndroid').projectDir = new File(
    rootProject.projectDir, '../node_modules/react-native/ReactAndroid')
```

Last but not least, you will need 1 change in `android/build.gradle`, in the
`dependencies` section:

```
classpath 'de.undercouch:gradle-download-task:2.0.0'
```

That's it!

## At the end

Now, when you run `react-native run-android`, you should notice that the
build is slightly slower, due to the fact that [gradle](http://gradle.org/)
is trying to compile RN from source rather than from the pre-built packages.

You can then open `./node_modules/react-native/ReactAndroid/src/main/java/com/facebook/react/`
and start hacking around, making your own changes and testing them with a simple
`react-native run-android`.

For us, we were eventually able to enable remote debugging on webviews and found out
why our webview wasn't running: it simply needed access to the
[localStorage](https://developer.mozilla.org/en/docs/Web/API/Window/localStorage),
which is turned off by default on android webviews{% fn_ref 1 %}.

{% footnotes %}
  {% fn We then sent a PR (https://github.com/facebook/react-native/commit/67931284350ebd2b60d1e11870690272079b1726) so that we can turn DOM storage on at will ;-) %}
{% endfootnotes %}
