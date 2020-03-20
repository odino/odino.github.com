---
layout: post
title: "Magento's request doesn't collect GET and POST"
date: 2010-10-25 10:59
comments: true
categories: [php]
alias: "/226/magento-s-request-doesn-t-collect-get-and-post"
---
<!-- more -->
[[UPDATE: found out the real problem]](http://www.odino.org/230/php-s-pcre-extension-may-harm-your-preg-replace)

Recently, we had to move an application from the staging environment to pre-production ( where stage means *we show it to the customer* and pre-production is *the customer hosts it waiting for the go-live* ) without the possibility of replicating the whole VM due to incompatibility issues for the VM conversion ( VMware to Xen, if I correctly rembember ).

After setting up the new environment we experienced serious issue on the search engine and other minor components related with `GET` and `POST` parameters: after a while we compared the installations of PHP to find out the problem and it came out that the PCRE extension used in the new environment ( CentOS, if I - again - correctly remember ) was released in 2006 ( version `6.something` ).

You can check it from the `phpinfo()` looking for:

* PCRE (Perl Compatible Regular Expressions) Support 
* PCRE Library Version

After updating ( version 7.8 ) it everything got normal.