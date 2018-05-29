---
layout: post
title: "mssqldump, a small utility to dump MS SQL Server data"
date: 2018-05-22 14:56
comments: true
categories: [open source, oss, SQL, sql server, mssql]
description: "Let me introduce you a small utility I wrote to automate some tasks: mssqldump, mysqldump, for MS SQL Server."
---

{% img right /images/mssql-logo.png %}

In the past few months I found myself busier with moving data here and there, so
much that scripts ending with `load(transform(extract()))` have become my bread
and butter -- sad life, some say!

Last night I wanted to import a bunch of data stored in SQL Server
into a MySQL database, but didn't want to get my hards dirty with a GUI or PowerShell
because, well, [PowerShell](https://www.google.ae/search?q=powershell+sucks&oq=powershell+sucks&aqs=chrome..69i57j69i61j0l4.3713j0j7&sourceid=chrome&ie=UTF-8).

The result was [mssqldump](https://github.com/odino/mssqldump), a small utility
- similar to `mysqldump` - to export data into [TSV](/tsv-better-than-csv/).

<!-- more -->

## Usage

`mssqldump` does one thing -- and hopefully well -- run a query against the
database and export the results as TSV to the stdout:

```
./mssqldump -q "SELECT Name, 1 as ID, RAND() as thing from sys.Databases"
master    1    0.4318099474883688
tempdb    1    0.4318099474883688
model     1    0.4318099474883688
msdb      1    0.4318099474883688
test      1    0.4318099474883688
```

You can also include headings (column names) with the `-c` option:

```
./mssqldump -q "SELECT Name, 1 as ID, RAND() as thing from sys.Databases"
Name      ID   thing
master    1    0.4318099474883688
tempdb    1    0.4318099474883688
model     1    0.4318099474883688
msdb      1    0.4318099474883688
test      1    0.4318099474883688
```

If you want to print `mssqldump`'s version information you can just specify `v`
or `version` as the query parameter:

```
./mssqldump -qversion
1.0.0
```

If you want to use `mssqldump` simply download the [latest release from github](https://github.com/odino/mssqldump/releases)
and start dumping data around!

## A couple surprises

Building `mssqldump` was an experience on its own, as I discovered a couple useful
things:

* Microsoft is killing it lately -- I wanted to test this out and was resigned to
spinning up a SQL Server instance on Azure. Turns out a simple `docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password123!' --net host -d --name mssql --rm microsoft/mssql-server-linux`
does the trick!
* knowing I was developing a CLI tool in Golang, I thought I would *need* to resort
to [cobra](https://github.com/spf13/cobra) -- wanting to try to simplify things
up I instead opted for [go-flags](https://github.com/jessevdk/go-flags), which has way less
features but is also less opinionated and faster to setup (cobra is probably overkill
for a CLI app with only one command)

Adios!
