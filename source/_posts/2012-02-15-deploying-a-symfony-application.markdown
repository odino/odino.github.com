---
layout: post
title: "Deploying a symfony application"
date: 2010-10-11 23:17
comments: true
categories: [symfony]
alias: "/206/deploying-a-symfony-application"
---
<!-- more -->

## Define your target server

Edit `/config/properties.ini`:

```
[stage]
  host=192.168.xx.yyy
  port=22
  user=myuser
  dir=/the/project/root
```

## Test your deployment configuration

`php symfony project:deploy stage`

## Preserve the production data

`php symfony doctrine:data-dump data/production.yml`

I would do it in a successive step, but, deploying, you could upload a different model schema: then, when dumping the data, Doctrine won't be able to map the data in the database and your model schema.

## Deploy

`php symfony project:deploy stage --go`

## Test target server configuration

```
ssh myuser@192.168.xx.yyy

cd /the/project/root

php lib/vendor/symfony/data/bin/check_configuration.php 
```

## Re-configure the DBs

```
php symfony configure:database "mysql:host=localhost;dbname=production_test" user pwd --env=test

php symfony configure:database "mysql:host=localhost;dbname=production" user pwd
```

## Build the environments

```
php symfony doctrine:build --all --and-load --env=test
php symfony doctrine:build --all
```

## Load production data on production DB ( if a migration is needed... migrate! )

`php symfony doctrine:data-load data/production.yml`

## Test the environment

`php symfony test:all`

## Heal the environment

```
php symfony cc

php symfony project:permissions

php symfony project:optimize frontend prod 
```

I'm pretty sure something is missing here, hope to see some replies.