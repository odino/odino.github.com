---
layout: post
title: "Valid SSL certificates for local development"
date: 2018-09-01 12:57
comments: true
categories: [https, ssl, development, localhost]
description: "Wondering how to create valid SSL certificates for local development? mkcert is the answer."
---

A few weeks ago I bumped into [mkcert](https://github.com/FiloSottile/mkcert), a tool written by [Filippo](https://github.com/FiloSottile),
the same guy behind the popular [heartbleed test tool](https://filippo.io/Heartbleed/).

<!-- more -->

The tool in question answers one simple need:

{% img center /images/mkcert-ko.png %}

By creating a local root CA file that gets installed in your system, making all
certificates issued by `mkcert` trusted:

{% img center /images/mkcert-ok.png %}

After downloading the latest release from Github you can simply "install" it
by running `mkcert -install`. Once that is done, you can create your first,
trusted (by your own system) certificate:

```
$ mkcert somedomain.local

Using the local CA at "/home/alex/.local/share/mkcert" ✨

Created a new certificate valid for the following names 📜
 - "somedomain.local"

The certificate is at "./somedomain.local.pem" and the key at "./somedomain.local-key.pem" ✅
```

For example, here's how it would look like if you had to boot a node server with
SSL support:

``` js
const fs = require('fs')

const options = {
  key: fs.readFileSync(__dirname + '/somedomain.local-key.pem'),
  cert: fs.readFileSync(__dirname + '/somedomain.local.pem')
};

require('https').createServer(options, (req, res) => {
  res.writeHead(200)
  res.end(`Got SSL?`)
}).listen(443)
```

Pretty neat, ah? What `mkcert` does is to simply add another CA file
in your system (I guess under `/etc/ssl/certs/ca-certificates.crt`, but I'm not
entirely sure) so that browsers consider these certificates trusted -- a nice
workaround to trick any HTTP client.

Adios!