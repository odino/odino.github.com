---
layout: post
title: "Installing and configuring Varnish on Ubuntu"
date: 2011-02-09 02:29
comments: true
categories: [linux, varnish]
---

On a brand new debian/*ubuntu distro, there are only a couple steps to do in order to make Varnish ~~act as a proxy~~ do its job in front of apache.
<!-- more -->

Installation:

```
sudo apt-get install varnish
```

then you need to configure it to listen to the `:80` port, editing `/etc/default/varnish`:

```
DAEMON_OPTS="-a :80 \
             -T localhost:6082 \
             -f /etc/varnish/default.vcl \
             -S /etc/varnish/secret \
             -s file,/var/lib/varnish/$INSTANCE/varnish_storage.bin,1G"
```

and telling it to forward requests to apache ( we're gonna make it listen to the `8090` ), into the `/etc/varnish/default.vcl`:

```
backend apache {
        .host = "127.0.0.1";
        .port = "8090";
}
sub vcl_fetch {
        remove req.http.X-Forwarded-For;
        set    req.http.X-Forwarded-For = req.http.rlnclientipaddr;
        return(deliver);
}
```

Then it's time to tell apache it has to listen to a new port, in `/etc/apache2/ports.conf`:

```
NameVirtualHost *:8090
Listen 127.0.0.1:8090
```

Make sure the hosts in your `/etc/apache2/httpd.conf` listen to `:*` or `:8090`, then you can start the services:

```
/etc/init.d/apache2 start
/etc/init.d/varnish start
```

Now you have varnish responding to all the hosts on the `:80`: if you experience some troubles try to go deeper with this [extended guide](http://www.howtoforge.com:8080/putting-varnish-in-front-of-apache-on-ubuntu-debian).