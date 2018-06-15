---
layout: post
title: "Emit a beeping sound with JavaScript"
date: 2018-06-15 07:35
comments: true
categories: [JavaScript, browser, frontend]
description: "Writing an application where users do repetitive tasks? Nothing better than emitting a sound whenever something happens."
---

{% img right /images/cashier.png %}

When you go to your favorite grocery store and the cashier processes your products,
he or she will most likely scan them through a barcode scanner which will emit a
sound -- a sound that's only there to signal that the scan was successful, and
he or she can move onto the next product.

When you develop user interfaces for repetitive tasks, and especially when some sort
of scanning is required, it might make a lot of sense to think of giving your
users additional feedback so that they don't have to go back and look at the screen
every time they process an action -- they can probably simply *hear* a confirmation
sound, or *feel* an alarming buzz.

Let's dig a bit deeper.

<!-- more -->

## Bzzzzzz

If you're giving your users a mobile device, the [vibration API](https://developer.mozilla.org/en-US/docs/Web/API/Vibration_API)
is a low-hanging fruit: by just `navigator.vibrate(1000)` you'll have a device
that buzzes for a second. Want to create interesting patterns? Then do something
such as:

* `navigator.vibrate(200)`, a short buzz indicating the action went fine
* `navigator.vibrate(2000)`, a long buzz indicating there was some sort of error
* `navigator.vibrate([300, 300, 300])`, 3 short buzzes indicating a task is completed

...and so on and so forth: the vibration API is absurdly easy, so I'm simply leaving
it for you to experiment with it.

## BEEP! BEEP! BEEP! BOOP!

Something a tad better is a snippet I found today, which simplifies audio feedback
quite significantly:

``` js
a=new AudioContext() // browsers limit the number of concurrent audio contexts, so you better re-use'em

function beep(vol, freq, duration){
  v=a.createOscillator()
  u=a.createGain()
  v.connect(u)
  v.frequency.value=freq
  v.type="square"
  u.connect(a.destination)
  u.gain.value=vol*0.01
  v.start(a.currentTime)
  v.stop(a.currentTime+duration*0.001)
}
```

<script type="text/javascript">
a=new AudioContext()
function beep(vol, freq, duration){
  v=a.createOscillator()
  u=a.createGain()
  v.connect(u)
  v.frequency.value=freq
  v.type="square"
  u.connect(a.destination)
  u.gain.value=vol*0.01
  v.start(a.currentTime)
  v.stop(a.currentTime+duration*0.001)
}
</script>

This snippet can be used to generate interesting sounds such as:

<button style="width: 30%; height: 150px; font-size: 2em" onclick="beep(100, 520, 200)">Beep</button>
<button style="width: 30%; height: 150px; font-size: 2em" onclick="beep(999, 220, 300)">Boop</button>
<button style="width: 30%; height: 150px; font-size: 2em" onclick="beep(999, 210, 800); beep(999, 500, 800);">Cool noise</button>

You can actually [create songs with this kind of stuff](https://www.beepbox.co) ([proof](https://www.beepbox.co/#6n42s6k7l02e0zt9m0a7g0Dj9i1r1o323200T1d0c2AbF0B0V7Q2500Pd4c0E7171T1d1c0A2F1B7V1Q4000Pf700E8911T0w4f1d1c0h8v1T0w1f1d1c0h0v0T0w2f3d1c0h0v2T1d1c0A2F1B8V1Q4000Pa600E8901T1d1c0A3F0B8V1Q5310Pcda0E0631T1d1c0A1F0B0V1Q7300Pebc0E06b1T2w1d1v3T2w1d1v2T2w4d1v4T2w4d1v4b4x8i4w004xgB88smAa2g04q74x4i4N8j51ci4M844N0k4Ngk4xck4g830w430Al0kxdUxh8N4z4264kh8i4x8k5h8O438i4x820C8k9h8h40018h4N4h4N4j4h4hgR0i0g4g4g018y8i8y8x8x8y4w020h80404hp288kPUj7gM7bN74cyRCfeXJjJOe8VKlBVEqMQxYHaOI_fPYyTpTtGqWMTkQxLFF38QQxA6W2F31xBE6AdwraWWlevMgVop2Addmjgswd58mCOSUdBBA3tpnnjpmYlljARpdejjCddapAFHB4TpGStICGqWoAoRFH84idFIa9QKh8YBhpIp5O0rntuw0C5ctM96CC2GFFwkPQllkQRFFHHFFwtc_sgM71chN38JpzPKXlWD9UxwelBVMqMRxVE39zwhOFxQj_ifXyu9KOqsCD4fbwo233tpp0TSlRQSlwFBF0j7i7uelcbByOxMgWwQ1j2w2gt0i7NUGAdl8qp4dcA6UyTn1FLGJ3m3r3N0dC6j6i2VlEqraHgFxU2h1i2CzdKH2CdcVoK0aoCmm1G3i6CGEdgqgGpCi0rgS5Rj20ySMdllwqgRwi0gOGhFzUOGUdgqgJdlgqwQCk04NFwpho2Cyw58aqa0kwqqagkQk0F1jhg2A5d58aqa0kwFEE1i1jc0H3m6AK000)).

The [WebAudio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API) is [widely supported](https://caniuse.com/#search=AudioContext), so you shouldn't have too many problems
rolling it out across platforms:

{% img center /images/webaudio.png %}

At [Namshi](https://www.namshi.com), we have provided our warehouse agents with devices to store, locate and
move inventory -- needless to say, combining these 2 APIs (vibration + sound) allows
our efficiency to increase while working on more repetitive tasks.
