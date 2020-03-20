---
layout: post
title: "Securing your HTTP API with JavaScript Object Signing and Encryption"
date: 2013-06-04 00:31
comments: true
categories: [javascript, api, http, ajax, php]
---

One thing that is always difficult, enough to
deserve [its own book](http://www.amazon.com/Ajax-Security-Billy-Hoffman/dp/0321491939),
is to **secure HTTP API** that interact with client-side
applications: today, after a discussion about how to face
the problem in our company, we bumped into the
[JOSE](http://datatracker.ietf.org/doc/draft-ietf-jose-json-web-signature/?include_text=1)
- JavaScript Object Signing and Encryption -
specification.

<!-- more -->

Basically, the specification defines 4 entities:

* JWS, [JSON Web Signature](http://tools.ietf.org/html/draft-jones-json-web-signature-04),
a signed representation of data
* JWT, [JSON Web Token](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html),
a representation of data
(it differs from JWS as JWT is not signed)
* JWE, [JSON Web Encryption](http://self-issued.info/docs/draft-ietf-jose-json-web-encryption.html),
an encrypted JSON representation of data
* JWA, [JSON Web Algorithms](http://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-00),
a list of safe algorithms to be used with JWS and JWE

For the sake of basic knowledge, we will only have a look
at JWS and JWT / JWE now: the specifications about these
entities are quite extensive and not very straightforward,
so for further details you should **really** give them
a look.

{% img right /images/jws.png %}

## JWT

Basically, the token (JWT) is the simplest structure
that you will deal with while implementing JOSE in our
architecture; it is a string representation of some data
base64 encoded (other types of encoding might be applied, but
this is not madatory): the JWT differs from raw base64-encoded
data since it also includes informations about the encoding
itself, in the token's header; by concatenating the base64-encoded
version of the token header and payload (the actual data) you
obtain what the specification calls **signature input**, which will
then be used to create the signature (JWS).

## JWS and JWE

After the JWT comes the JWS, which is a signed representation
of the JWT; it differs from the token just because of the
signature; on an higher step of the ladder comes the JWE instead,
which lets you encrypt the data in order to achieve an higher security
level: the [examples in the ietf draft](http://self-issued.info/docs/draft-ietf-jose-json-web-encryption.html#JWEExamples)
show you how to create JWEs with a pair of private /
public keys.

## Use case: how to authenticate stateless AJAX calls?

{% img left /images/jsw-auth.png %}

One of the needs that you might have is to,
from JavaScript, make authenticated HTTP calls to
one of your webservices: since you don't want to
expose the WS credentials on the JS service (the
credentials would be readable by any client) a good
solution might be to generate a JWS with a private
OpenSSL key in your webservice, store it into a cookie
accessible to the JS service, which would execute
those calls including that cookie{% fn_ref 1 %}, which you can then
verify while authenticating the call.

This workflow is pretty easy to understand, but the actual
implementation is more than tricky, since the
specification is quite abundant - especially about
encryption algorithms.

In PHP we can use at least 3 libraries: one of them,
[Akita_JOSE](https://github.com/ritou/php-Akita_JOSE),
is pretty old (since the last commit was more than
7 months ago) but is very understandable and quite
easy to use; another one, [gree/jose](https://packagist.org/packages/gree/jose),
has itw own package on packagist and can be easily
installed via composer: from a fast look at the
[source code on GitHub](https://github.com/gree/jose) it looks good,
even though it needs the [phpsec](http://phpseclib.sourceforge.net/)
library to be able to work{% fn_ref 2 %}.

The third option, which is the one that [I built in the last couple of hours](https://github.com/namshi/jose),
is [namshi/jose](https://packagist.org/packages/namshi/jose),
which is very, very easy to use{% fn_ref 3 %}: it currently only
supports the [RSA algorithm](https://github.com/namshi/jose/blob/master/src/Namshi/JOSE/Signer/RS256.php)
with `sha256` hashing, but I guess that implementing other
algorithms is less than trivial.

For example, let's see how you would generate the JWS
to be stored in a cookie:

``` php Generating a JWS after authentication and storing it into a cookie
<?php

use Namshi\JOSE\JWS;

if ($username == 'correctUsername' && $pass = 'ok') {
    $user = Db::loadUserByUsername($username);

    $jws  = new JWS('RS256');
    $jws->setPayload(array(
        'uid' => $user->getid(),
    ));

    $privateKey = openssl_pkey_get_private("file://path/to/private.key");
    $jws->sign($privateKey);
    setcookie('identity', $jws->getTokenString());
}
```

and then the apps that want to execute authenticated
calls on behalf of the user by using this cookie just need
to include it in these calls; the server will just need
to verify that the JWS in the cookie is valid:

``` php 
<?php

use Namshi\JOSE\JWS;

$jws        = JWS::load($_COOKIE['identity']);
$public_key = openssl_pkey_get_public("/path/to/public.key");

if ($jws->verify($public_key)) {
    $paylod = $jws->getPayload();

    echo sprintf("Hey, my JS app just did an action authenticated as user #%s", $payload['id']);
}
```

That's it: far from being a stable library, this is more a
proof of concept that we, an Namshi, would like to see developing
in the next weeks / months.

As always, comments, rants or - even better - pull requests are
**more than welcome**!

{% footnotes %}
	{% fn One of the disadvantages of this approach is that it relies on cookies, only available in the HTTP protocol. If you want to use another protocol for you application - a very rare and extreme use case - this wouldn't work for you. %}
	{% fn I honestly never heard of this library before, so I can't really say what it does and why it's needed %}
	{% fn Since I'm not an expert in encryption and security, I would suggest to give it a look and come up with feedbacks %}
{% endfootnotes %}