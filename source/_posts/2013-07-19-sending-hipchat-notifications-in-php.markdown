---
layout: post
title: "Sending HipChat notifications in PHP"
date: 2013-07-19 14:20
comments: true
categories: [HipChat, Notificator, Namshi, PHP, OSS]
---

This morning I added a couple handlers to
[Notificator](https://github.com/namshi/notificator), one for
RabbitMQ and another for [HipChat](https://hipchat.com): in
this post I would like to show you how easy is to integrate
HipChat within your systems.

<!-- more -->

The handler takes advantage of the
[PHP SDK](https://github.com/hipchat/hipchat-php) that the HipChat
team built, which is very, very good and
[available through packagist](https://packagist.org/packages/hipchat/hipchat-php).

First thing you will need to do, is to create an instance of a
notification manager and adding the handler to it, with
an HipChat client and the API token you can generate from the HipChat
admin interface:

``` php
<?php

use Namshi\Notificator\Manager;
use Namshi\Notificator\Notification\Handler\HipChat as HipChatHandler;
use HipChat\HipChat;
use Namshi\Notificator\Notification\HipChat\HipChatNotification;

$hipChatClient  = new HipChat('YOUR_API_TOKEN_HERE');
$hipChatHandler = new HipChatHandler(%hipChatClient);
$manager 		= new Manager();
$manager->addHandler($hipChatHandler);
```

Then you only need to define a notification with a few, HipChat-specific,
properties and trigger it:

``` php
<?php

$notification = new HipChatNotification(
	'YOLO!', // message
	'Alex',  // sender
	'room1', // name of the room you want this message to appear
	array(
		'hipchat_notify' 			=> true, // optional: should send notifications to everyone?
		'hipchat_color'  			=> HipChat::COLOR_GREEN, // optional: background color of the notification
		'hipchat_message_format'  	=> HipChat::FORMAT_TEXT, // optional: text or html
	)
);

$manager->trigger($notification);

```

The result is pretty self-explanatory:

{% img center /images/hipchat-php.png %}

Kind of the [same code](https://github.com/namshi/notificator/blob/master/examples/hipchat.php)
is also available, as an example,
on the [notificator repository](https://github.com/namshi/notificator),
under the [examples](https://github.com/namshi/notificator/tree/master/examples) folder.

The greatness of Notificator are its handlers, so if you feel
we should add another, useful handler, just shout out!
Even better, you can contribute to the project by sending
a [pull request](https://github.com/namshi/notificator/pulls?direction=desc&page=1&sort=created&state=closed)
like [Alessandro](https://twitter.com/cirpo),
[Pascal](https://twitter.com/pborreli) and
[Luis](https://twitter.com/cordoval) already did!

{% footnotes %}
  {% fn The sad truth is that capistrano has an hipchat gem/extension, but you cant really plug it the way you want (at least this happens to non-rubiers) %}
{% endfootnotes %}