---
layout: post
title: "Finding where that IP address is from with iploc"
date: 2018-07-07 16:45
comments: true
description: "Get location information of an IP address with iploc, a small tool I just open-sourced"
categories: [golang, ip, open source, github]
---

Today I spend some time to build [iploc](https://github.com/odino/iploc), a small CLI utility that lets you retrieve
geographical information of an IP address.

<!-- more -->

First and foremost, I'd like to clarify that this library is nothing but a CLI
wrapper for the [ip-api.com](http://ip-api.com/), which does the actualy heavy-lifting
for us.

Long story short, `iploc` is a very small utility that let's you lookup geographical
information of an IP address directly from the CLI -- you simply give it the address
you want to "reverse geocode" and it will print out a bunch of information:

```
iploc 12.34.56.78
{"as":"AS7018 AT\u0026T Services, Inc.","city":"Columbus","country":"United States","countryCode":"US","isp":"AT\u0026T Services","lat":39.9653,"lon":-83.0235,"org":"AT\u0026T Services","query":"12.34.56.78","region":"OH","regionName":"Ohio","status":"success","timezone":"America/New_York","zip":"43215"}
```

Indulging my passion for [gluttony](https://en.wikipedia.org/wiki/Seven_deadly_sins#Gluttony),
I've added a *pretty-print* option for humans:

```
iploc 12.34.56.78 -p
{
    "as": "AS7018 AT\u0026T Services, Inc.",
    "city": "Columbus",
    "country": "United States",
    "countryCode": "US",
    "isp": "AT\u0026T Services",
    "lat": 39.9653,
    "lon": -83.0235,
    "org": "AT\u0026T Services",
    "query": "12.34.56.78",
    "region": "OH",
    "regionName": "Ohio",
    "status": "success",
    "timezone": "America/New_York",
    "zip": "43215"
}
```

but you'd really be better off with tools such as [jq](https://stedolan.github.io/jq/):

```
iploc 12.34.56.78 | jq -r .city
Columbus
```

Installing iploc is fairly straighforward, as you can simply grab the right binary
from the release page on GitHub:

```
/tmp ᐅ wget https://github.com/odino/iploc/releases/download/v1.0.0/iploc_linux_amd64_v1.0.0.tar.gz
--2018-07-07 16:35:12--  https://github.com/odino/iploc/releases/download/v1.0.0/iploc_linux_amd64_v1.0.0.tar.gz
Resolving github.com (github.com)... 192.30.253.113, 192.30.253.112
Connecting to github.com (github.com)|192.30.253.113|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/140064185/ae86980c-81dd-11e8-86f7-510d153790f8?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20180707%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20180707T123513Z&X-Amz-Expires=300&X-Amz-Signature=32b345f28416ae597379622a361e9f01347cfac31984125353ba4801d147473e&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Diploc_linux_amd64_v1.0.0.tar.gz&response-content-type=application%2Foctet-stream [following]
--2018-07-07 16:35:13--  https://github-production-release-asset-2e65be.s3.amazonaws.com/140064185/ae86980c-81dd-11e8-86f7-510d153790f8?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20180707%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20180707T123513Z&X-Amz-Expires=300&X-Amz-Signature=32b345f28416ae597379622a361e9f01347cfac31984125353ba4801d147473e&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Diploc_linux_amd64_v1.0.0.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.96.227
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.96.227|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2977802 (2.8M) [application/octet-stream]
Saving to: ‘iploc_linux_amd64_v1.0.0.tar.gz.1’

iploc_linux_amd64_v1.0.0.tar.gz.1                     100%[======================================================================================================================>]   2.84M   362KB/s    in 10s     

2018-07-07 16:35:24 (287 KB/s) - ‘iploc_linux_amd64_v1.0.0.tar.gz.1’ saved [2977802/2977802]

/tmp ᐅ tar -xzf iploc_linux_amd64_v1.0.0.tar.gz                                                    
/tmp ᐅ ./iploc_linux_amd64_v1.0.0 12.34.56.78
{"as":"AS7018 AT\u0026T Services, Inc.","city":"Columbus","country":"United States","countryCode":"US","isp":"AT\u0026T Services","lat":39.9653,"lon":-83.0235,"org":"AT\u0026T Services","query":"12.34.56.78","region":"OH","regionName":"Ohio","status":"success","timezone":"America/New_York","zip":"43215"}
```

...that's it: there's nothing else the tool does (rightfully, I would say).

[As opposed to last time](/mssqldump-a-small-utility-to-dump-ms-sql-server-data/#a-couple-surprises),
today I opted to use [cobra](https://github.com/spf13/cobra) as I wanted to see what overhead
it would introduce in a tool this small: from my perspective, setting up the CLI app
with cobra was fairly quick and straightforward, even though the binaries are a bit
chubbier (the amd64 linux bin is 2.8mb vs 2.5mb, so nothing crazy to be honest).
Definitely recommended.

That's it for today!
