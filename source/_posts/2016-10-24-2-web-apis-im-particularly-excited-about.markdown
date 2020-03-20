---
layout: post
title: "2 Web APIs I'm particularly excited about"
date: 2016-10-25 01:02
comments: true
categories: [web, api, chrome, web payments, push notifications]
description: Web Push Notifications and Payment Requests are exciting, as they open up new frontiers in web development.
---

In the past few months we have seen Google and Apple push in 2
very different directions -- as much as Apple has been steady
pushing publishers to embrace their app market, Google has been
working on a bunch of initiatives to improve the "web platform",
rolling out projects like [AMP](http://tech.namshi.com/blog/2016/09/20/embracing-amp-for-the-speed-and-profit/) and giving a lot of coverage to
technologies like [PWAs](https://developers.google.com/web/progressive-web-apps/).

I'm particularly excited about the work that Google is putting
on the web as they're slowly bridging the gap with the native experience,
and there are 2 Web APIs I can't really wait to use in
production to give [our users](https://www.namshi.com/) an enhanced
experience on the web.

<!--  more -->

As much as these aren't coming just from Google, I need to tribute them
to big G as they're the ones who are throwing them onto the mainstream:
I'm talking about [Web Payments](https://www.w3.org/TR/payment-request/) and
[Web Push Notifications](https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/).

## Web Push Notifications

You can start adding push notifications to your web app today: they involve
installing a [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers)
which "lives" in background and is capable of listening for push events.

{% img center https://blog.kissmetrics.com/wp-content/uploads/2015/11/push-notifications-desktop-mobile.png %}

Let's test it out real quick on Chrome:

* if you're reading this article from a **desktop machine**:
  * head [here](https://gauntface.github.io/simple-push-demo/)
  * accept permissions
  * copy the curl command
  * close that webpage
  * open a terminal and run that curl
  * be amazed
* if you're reading this article from a **mobile device**:
  * head [here](https://gauntface.github.io/simple-push-demo/)
  * accept permissions
  * copy that curl command and send it to a friend
  * close the browser
  * ask your friend to run it
  * be amazed

If you close your browser (at least on android) the service worker
keeps living, making it possible to reach your users until the SW dies,
which generally happens when the app (chrome) crashes or the phone
is rebooted, which are unlikely to happen on a frequent basis{% fn_ref 1 %}.

You will need a good understanding of service workers but the code
to implement push notifications is [really trivial](https://github.com/GoogleChrome/samples/blob/gh-pages/push-messaging-and-notifications/service-worker.js)
and the "backend" implementation is very well explained by - again - the [Google guys](https://developers.google.com/web/fundamentals/getting-started/codelabs/push-notifications/), which use
Firebase Cloud Messaging (formerly known as GCM) to deliver pushes
to the subscribed clients.

Web Push requires [service workers](http://caniuse.com/#feat=serviceworkers), and support
is currently limited to [Chrome / Firefox / Opera](http://caniuse.com/#feat=push-api).

## Payment Request API

This one isn't as immediate as Web Pushes, especially since it [landed in Chrome just a few weeks back](https://9to5google.com/2016/08/08/chrome-53-beta-features/), so support is
pretty experimental -- but have a look at the following video to get an idea
of how checkouts could be much simpler through a native way of collecting payment
details:

<iframe width="760" height="415" src="https://www.youtube.com/embed/hmqZxP6iTpo" frameborder="0" allowfullscreen></iframe>

This API isn't a payment solution but rather a sophisticated way to collect payment
data from your users, without needing to implement payment forms on your own -- you
simply create a payment request and the browser does the rest:

``` js
// is this real?
if (window.PaymentRequest) {
  // what kind of payments are we accepting?
  let methodData = [
    {
      supportedMethods: ['visa', 'mastercard']
    }
  ];

  // what is the user purchasing?
  let details = {
    displayItems: [
      {
        label: 'Argo, Blue-Ray movie',
        amount: { currency: 'USD', value : '15.00' }
      },
      {
        label: 'Power customer discount',
        amount: { currency: 'USD', value : '-10.00' }
      }
    ],
    total:  {
      label: 'Total',
      amount: { currency: 'USD', value : '5.00' }
    }
  };

  let request = new window.PaymentRequest(methodData, details, {});

  // start the fun!
  request.show().then(function(result) {
    result.complete('success');
    // example of result.details:
    //  - cardNumber
    //  - cardSecurityCode
    //  - expiryMonth
    //  - expiryYear

    return apiCallToThePaymentGateway(result.details).then(res => {
      return result.complete('success');
    }).catch(result => {
      return result.complete('fail');
    })
  });
}
```

You simply need to create a `PaymentRequest` and `.show()` it -- the browser
will then show the native UI and you'll eventually receive the details once
the user is done entering his / her details: it's pretty neat since it's a very
simple yet powerful way of offloading this kind of annoying "feature" to the
browser (who's really happy to write a new credit card form in 2016? anyone who actually likes [luhn](https://en.wikipedia.org/wiki/Luhn_algorithm)?).

As I said, this is pretty experimental, meaning that support is... ...well,
you're [on your own for now](http://caniuse.com/#feat=payment-request), as
the **only** browser that supports it is chrome for mobile{% fn_ref 2 %}.

## So?

Who could have though things like these could actually happen in a browser
3 years ago?

I bet most of us didn't, which is why I'm excited to see the
web growing and adding capabilities that make the browsing experience
better day after day.

And with things like [Ambient Light Sensor API](https://www.chromestatus.com/feature/5298357018820608),
[CompositorWorkers](https://www.chromestatus.com/feature/5762982487261184) (worker threads that can respond to input and update visuals)
and [WebVR](https://www.chromestatus.com/feature/4532810371039232) in the pipeline,
the future of browsers looks yummier than ever!

{% footnotes %}
  {% fn How many times do you reboot your phone daily? Sorry, what? You have a Samsung? Oh... %}
  {% fn What's  scary, though, is that "Apple provides an equivalent proprietary API called Apple Pay JS" (http://caniuse.com/#feat=payment-request) %}
{% endfootnotes %}