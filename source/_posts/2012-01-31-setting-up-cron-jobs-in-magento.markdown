---
layout: post
title: "Setting up cron jobs in Magento"
date: 2010-09-11 14:53
comments: true
categories: [PHP]
alias: "/88/setting-up-cron-jobs-in-magento"
---

Magento has a powerful built-in engine to perform cronjobs, let's see how we make them work.
<!-- more -->

First of all, we need to declare a crontab in our OS. Let's say we have Ubuntu ( or derived, or Debian ) and we want to run magento cronjobs every minute:

```
crontab -e
```

adding the line which defines that our jobs need to be scheduled for every single minute of the day:

```
# * * * * * path/to/php/binaries /path/to/magento/cron.php
* * * * * /usr/bin/php /var/www/magento/cron.php
```

So our environment in running Magento's cron script every minute, but our script produces nothing: let's do something!

Let's say that we developed a custom module, useful for sysadmins and similar, which has a table containing the references of all our development team ( name, position, email, .. ) and we regularly want to inform our team that Magento is running properly.

So let's modify the XML of our module, in app/code/local/MyCompany/MyModule/etc/config.xml adding the crontab reference:

``` xml
<config>
...
    <crontab>
        <jobs>
            <mymodule_apply_all>
                <schedule><cron_expr>* * * * *</cron_expr></schedule>
                <run><model>mymodule/modelName::modelMethod</model></run>
            </mymodule_apply_all>
        </jobs>
    </crontab>
...
</config>
```

So, you see that in the example above you need to edit everything between tags with:

* module name
* model name ( the model in which you're going to write the cronjob )
* model method name ( the function that your crontab will run )
all lowercase.

So now you have to create your method:

``` php app/code/local/MyCompany/MyModule/Model/modelName.php
<?php

public function notifyTeamEverithingIsOk() {
    ...stuff...
    ...stuff...
    ...stuff... 

    $sysadmin = Mage::getModel('mymodule/mymodel')->getCollection();

    // the following code is for fun purpose at all, I hope you don't code this way! ;-)

    foreach($sysadmin as $poor_fella){
        mail($poor_fella->getEmail(), 'Nightly report', 'Hey fella, everything's fine!');
    }
}
```
