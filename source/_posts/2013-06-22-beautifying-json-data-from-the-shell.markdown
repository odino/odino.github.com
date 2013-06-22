---
layout: post
title: "Beautifying JSON data from the shell"
date: 2013-06-22 15:36
comments: true
categories: [JSON, shell, python]
---

Yesterday I bumped into a very
handly utility to beautify JSON
data directly from your command
line.

<!-- more -->

Let's say that, with a command, you
are retrieving some data in JSON
format{% fn_ref 1 %}:

``` bash
curl -X POST --user admin:admin \
http://localhost:2480/command/temp/sql/select%20from%20person

{"result":[{"@type":"d","@rid":"#9:2","@version":0,"@class":"person","name":"Luca"}, {"@type":"d","@rid":"#9:3","@version":0,"@class":"person"}, {"@type":"d","@rid":"#9:4","@version":0,"@class":"person"}]}
```

Of course, the result doesn't really look
readable, but thanks to a python
utility we can directly expand and beautify
our JSON by piping:

```
curl -X POST --user admin:admin \
http://localhost:2480/command/temp/sql/select%20from%20person \
| python -mjson.tool

{
    "result": [
        {
            "@class": "person",
            "@rid": "#9:2",
            "@type": "d",
            "@version": 0,
            "name": "Luca"
        },
        {
            "@class": "person",
            "@rid": "#9:3",
            "@type": "d",
            "@version": 0
        },
        {
            "@class": "person",
            "@rid": "#9:4",
            "@type": "d",
            "@version": 0
        }
    ]
}
```

That's all, folks!

{% footnotes %}
	{% fn In my case, I am retrieving data from OrientDB, a NoSQL graph=document DB which handles data in JSON format over its HTTP interface %}
{% endfootnotes %}