---
layout: post
title: "Web APIs of the Future"
date: 2017-04-15 12:47
comments: true
categories: [web, api, javascript, frontend]
description: "What are the hottest, upcoming browser features we should be excited about?"
---

I generally like to think of myself as a server-side guy but, since a few
years, I've been more and more involved with the frontend -- especially
since logic, and not just UI, started to become a hot-topic for the client as
well (this is all thanks to Angular, y'all remember that thingy?).

So, more often than I admit, I keep an eye on the upcoming features of various
browsers through their *platform status* pages, and I've decided to start sharing
a bunch of the stuff you should probably be excited as well. I plan of writing
a couple articles like this one on a yearly basis, as browsers evolve quickly and
there's always lots of stuff to be looking forward to.

<!-- more -->

## First things first: sources

* [Chrome](https://www.chromestatus.com/features)
* [Edge](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/)
* [Firefox](https://platform-status.mozilla.org/)
* [Webkit](https://webkit.org/status/)

These browsers provide different functionalities on their status pages, so I
generally tend to spend more time on Chrome & Edge's since they let me filter
stuff out with ease. Webkit allows the same but, hell let's be honest, I'm not
very interested in their roadmap, as I think they're being
[strangely slow to adopt](https://arstechnica.com/information-technology/2015/06/op-ed-safari-is-the-new-internet-explorer/).

## Notable highlights

The past few days were a boom for MS Edge, which rolled out some [major updates](https://blogs.windows.com/msedgedev/2017/04/11/introducing-edgehtml-15/?utm_content=buffer9f1e8&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer#JYTlGJyKDuRVomoG.97)
including:

* [PaymentRequest API](https://developers.google.com/web/fundamentals/discovery-and-monetization/payment-request/)
* [async/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
* [Brotli](https://github.com/google/brotli)
* [CSP level 2](https://www.w3.org/TR/CSP2/)

This was personally very surprising for me, as I always considered Edge an
afterthought -- how naive of me. These guys are here to push forward, and
quickly buying into the PaymentRequest API is a huge sign for online payments. Love it!

## Upcoming stuff

{% img right /images/chrome.jpg %}

In Chrome canary:

* [Feature Policy](https://www.chromestatus.com/features/5694225681219584), a way to [selectively disable browser features](https://wicg.github.io/feature-policy/)
* [Get Installed Related Apps API](https://www.chromestatus.com/features/5695378309513216),
which will let website owners figure out [if the user has a (related) native app installed](https://github.com/WICG/get-installed-related-apps/blob/master/EXPLAINER.md)
* [Temporarily stop permission requests after 3 dismissals](https://www.chromestatus.com/features/6443143280984064),
so that annoying websites won't screw around as much

Under development:

* [Asynchronous Clipboard API](https://www.chromestatus.com/features/5861289330999296),
a modern clipboard API
* [Dynamc imports (from ESNext)](https://www.chromestatus.com/features/5684934484164608),
to dynamically load modules at runtime
* [ES6 modules](https://www.chromestatus.com/features/5365692190687232)
* [Web Authentication](https://www.chromestatus.com/features/5669923372138496),
to support serious [authentication on the client](https://w3c.github.io/webauthn/)
* [Web Share Target](https://www.chromestatus.com/features/5662315307335680), a consequence of the [Web Share API](https://developers.google.com/web/updates/2016/10/navigator-share),
so that websites can register themselves as "targets" of a share action (check this [demo of Web Share on Chrome for Android](https://blog.hospodarets.com/demos/web-share-api/))
* [WebVR](https://www.chromestatus.com/features/4532810371039232), which integrates
VR gears such as the Oculus with your browser (fun times ahead!)

{% img right /images/edge.png %}

MS Edge has previews of [Web Assembly and ES6 modules](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/?q=edge%3A%27Preview%20Release%27)
as well, but what's under development is even more exciting:

* [Background Sync API](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/backgroundsyncapi/?q=edge%3A%27In%20Development%27),
to let Service Workers know when the user's back online
* [Service Workers](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/serviceworker/?q=edge%3A%27In%20Development%27) of course :)
* [Web Push notifications](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/pushapi/?q=edge%3A%27In%20Development%27)
* [URL API](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/urlapi/?q=edge%3A%27In%20Development%27), to manipulate URLs, a feature that's there in all of the other major browsers

Looks like Edge is gaining momentum and closing the gap, which is definitely the
right direction for them. Of course, as you might notice, the road ahead is [still
long](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/consoletable/?q=edge%3A%27Under%20Consideration%27) ;-)

{% img right /images/firefox.png %}

Firefox's [focusing](https://platform-status.mozilla.org/) on:

* Background Sync
* [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Shadow_DOM)
* [Web Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
* PaymentRequest

{% img right /images/safari.gif %}

whereas [Safari is probably at its lamest](https://webkit.org/status/) with:

* [ASM.js](http://asmjs.org/)
* [Web Cryptography API](https://www.w3.org/TR/WebCryptoAPI/)
* [WebAssembly](http://webassembly.org/)

currently being developed -- or, at least, those are the features that I think
are going to impact us, common mortals, the most.

Service Workers, Web Authentication, Web App Manifest and [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity)
are all under consideration though.

## Conclusion

As usual, I think Chrome is pushing ahead, even though sometimes their ideas are
quite weird -- but that's part of trying to innovate. I'm very happy to see
Firefox working on solid stuff and Edge catching up with the biggest themes of
2016 (*aka Service Workers*).

I see the **PaymentRequest API as the clear winner of the past 6 months**, and I'm
really excited as this will mean a lot for online payments and e-commerce as well.
Browsers are becoming more of a platform rather than just a rendering engine, and
that makes it possible to create app-like experiences for your users{% fn_ref 1 %}.

Last but not least, time has come to **start shipping [Brotli](https://github.com/google/brotli) to your users**:
[Akamai supports it since few weeks](https://community.akamai.com/thread/2956#comment-15758)
and [browser support is kind of complete](https://caniuse.com/#search=brotli) (again, Safari...)
-- time to knock on your CDN provider's door!


{% footnotes %}
  {% fn And that's why, in my opinion, Safari is pushing back big time %}
{% endfootnotes %}