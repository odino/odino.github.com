---
layout: post
title: "Convert a password the Magento way"
date: 2010-09-11 14:56
comments: true
categories: [php]
alias: "/112/convert-a-password-the-magento-way"
---

Here's how to convert passwords from plain text to the alghorithm used by Magento.
<!-- more -->

This can result useful when you need to import users from an external application which was managing passwords with no encryption.

First of all a bad news: if you want to import encrypted password ( for example MD5 ), if you don't have a secure reverse lookup DB you won't be able to import the customers in the Magento store without resetting their password.

So, let's assume we already imported the customers from magento import tool and they can't login because their password don't fit Magento's way, which is defined this way ( read it as a PHP developer ):

```
md5(salt.password):salt
```

So, to convert all customers passwords you only need to login into mysql and run a single query:

``` sql
mysql -u root -e "UPDATE customer_entity_varchar SET value = CONCAT( MD5(CONCAT('salt', value)), ':salt') WHERE attribute_id = '12'"
-- don't care about my local config ;-)
```

That's it!