---
layout: post
title: "Import a Google spreadsheet into a MySQL table with docsql"
date: 2018-05-18 13:05
comments: true
categories: [MySQL, database, open source, github]
description: "A quick run-through docsql, a small piece of software I wrote to import Google spreadsheets into MySQL."
---

{% img right /images/google-docs.jpg %}

There's a lot of open-source software I'm not proud of; probably, though, nothing
compares to [docsql](https://github.com/odino/docsql), as this rare piece of
Golang qualifies as one of the weirdest of my creations.

<!-- more -->

At Namshi, we've been using spreadsheets as a mean of configuration for quite some
time -- you tell the stakeholder "hey, here's a google doc, if you need to change
one of the translations just edit the doc and wait 5 mins" and the bets are down.

Sometimes we actually need to import this data into MySQL (could be a *una-tantum*
import as well as a scheduled job) and we traditionally did this manually,
by pulling down a `.tsv` export from Google docs, amending it and running something
such as `LOAD DATA LOCAL INFILE`.

One evening, I found myself wifeless and with a strong desire to try out
[cobra](https://github.com/spf13/cobra) and [viper](https://github.com/spf13/viper),
so I started to look into automating the process of importing a spreadsheet hosted
on Google Docs into a MySQL table: the result was [docsql](https://github.com/odino/docsql), a small piece of
weird software that simply:

* [downloads a spreadsheet](https://github.com/odino/docsql/blob/bdfd6deeaf5dfb34ee1e00f23c48e0f1658c6d17/gdocs/gdocs.go#L13-L46) in [TSV format](/tsv-better-than-csv/)
* creates a [tmp table](https://github.com/odino/docsql/blob/bdfd6deeaf5dfb34ee1e00f23c48e0f1658c6d17/db/mysql.go#L51-L67)
* [imports the TSV](https://github.com/odino/docsql/blob/bdfd6deeaf5dfb34ee1e00f23c48e0f1658c6d17/db/mysql.go#L70-L86) in the tmp table
* [swaps the tmp table with the original table](https://github.com/odino/docsql/blob/bdfd6deeaf5dfb34ee1e00f23c48e0f1658c6d17/db/mysql.go#L90-L111) you want to import the spreadsheet to (this allows [atomic operations](https://stackoverflow.com/a/34391961/934439) on the DB)

and turns this:

{% img center https://raw.githubusercontent.com/odino/docsql/master/images/doc.png %}

into this:

{% img center https://raw.githubusercontent.com/odino/docsql/master/images/docsql.png %}

Considering this was a funny experiment to try to automate a task I do quite
infrequently{% fn_ref 1 %}, I don't think I'm going to spend a lot more time
expanding it or adding random features{% fn_ref 2%}, but I'm happy to share the
source code as I was pleasantly surprised with how straightforward it was to build
such a small, isolated CLI tool.

{% footnotes %}
  {% fn Even if infrequent, it's still a pain %}
  {% fn Especially considering my good old love for the Unix philosophy of "do one thing and do it well..." %}
{% endfootnotes %}
