---
layout: post
title: "Enable remote debugging on chrome for React Native's webviews"
date: 2016-01-02 09:00
comments: true
categories: [react native, android, chrome, webview]
---

{% img right /images/android.jpg %}

In my [last post](/contributing-to-react-native-for-android/) I explained how
you can hack on react native for android locally, so that if you need any
change to the java packages{% fn_ref 1 %} you can do it yourself, with
immediate feedback upon a `react-native run-android`.

One thing I immediately patched was the ability to
[enable remote debugging on webviews](https://developer.chrome.com/devtools/docs/remote-debugging#debugging-webviews),
which is turned off in react native -- and here's
how you can do the same.

<!-- more -->

If you look at the `ReactWebViewManager.java` you immediately notice that
[debugging is commented](https://github.com/facebook/react-native/blob/master/ReactAndroid/src/main/java/com/facebook/react/views/webview/ReactWebViewManager.java#L79-L80): this is because
it needs to be enabled on the [UI thread](http://stackoverflow.com/questions/3652560/what-is-the-android-uithread-ui-thread), else android is funny enough to [crash the application through a RuntimeException](https://android.googlesource.com/platform/frameworks/webview/+/3e9cdbe3fe00ef50eff256e7b5f4b6a1ae796ec5/chromium/java/com/android/webview/chromium/WebViewChromiumFactoryProvider.java#343).
Putting it in a static initializer makes it run on any thread that requires
this class, which is [why is disabled](https://github.com/facebook/react-native/issues/4857).

At the same time, you can just move it around to have it enabled in your dev environment;
just place the line that enables debugging in the `onPageStarted` method:

```java
@Override
public void onPageStarted(WebView webView, String url, Bitmap favicon) {
  super.onPageStarted(webView, url, favicon);
  mLastLoadFailed = false;

  ReactContext reactContext = (ReactContext) ((ReactWebView) webView).getContext();

  WebView.setWebContentsDebuggingEnabled(true);

  ...
```

and, after re-running `react native run-android`, you should be good to go:

{% img center /images/webview-remote-debugging.png %}

Other stuff like live screencasting work as expected:

{% img center /images/webview-remote-debugging-screencast.jpg %}

Sweet!

{% footnotes %}
  {% fn BTW hey, it's 2016 and Java is still a thing! %}
{% endfootnotes %}
