---
layout: post
title: "Bundling static files within your Golang app"
date: 2016-06-30 20:23
comments: true
categories: [golang, programming]
description: Ever needed to bundle static files, like translations, in your app? go-bindata is the right tool for you
---

{% img right /images/gopher.png %}

One of the nice features of golang is that you can simply distribute
your programs through *executables*, meaning the user doesn't need to
have custom libraries to install / run your software: just download the
executable and you're set.

What Go really does is to bundle together all your `*.go` files in a single,
platform-dependent executable, that
can be run with a single click -- which works perfectly in 99% of our use cases.

All of this seems great, until you have to bundle different kind of files
in your application, for example an `.yml` config file or an `.xliff`
translation file.

How would you approach this? Enter the trick of the year.  

<!-- more -->

## The idea

The idea is that you can create a go source file which *contains all of the
non-go files you need to bundle*, something of this sort:

``` go
package something

func GetAssetContents(string asset) string {
  if asset = "file.txt" {
    return "1234"
  }

  if asset = "file.css" {
    return "hello { display: block; }"
  }

  // ...
}
```

and in your code you can then require those files
by just doing `GetAssetContents("file.txt")`; when
doing a `go build`, then, all of your assets will
be "included" in your final binary.

## Enter go-bindata

Now, you could argue that writing code like this isn't ideal,
and that is true -- that is why you'll find [go-bindata](https://github.com/jteeuwen/go-bindata)
useful, as it generates all of the code automatically:

```
go get jteeuwen/go-bindata
echo "1234" > sample.txt
go-bindata -pkg something -o sample.go ./sample.txt
```

and [here's the result](https://github.com/odino/go-bindata-example/blob/master/sample.go):
as you can see, go-bindata generated a new go file under the package `something`, and it
[embedded the contents](https://github.com/odino/go-bindata-example/blob/10e59eee28251b657991b5eead29540143d8ba71/sample.go#L71) of `sample.txt` in it.

To access the contents you now just have to import your module and call the `Asset` function:

``` go
import (
  "github.com/you/library/something";
  "fmt"
)

func main () {
  fmt.Println(Asset("sample.txt")) // 1234
}
```

Pretty neat, eh?

I wrapped all of this together in a [github repo](https://github.com/odino/go-bindata-example),
where you can see [the asset](https://github.com/odino/go-bindata-example/blob/master/sample.txt)
and how it can be [included in go code](https://github.com/odino/go-bindata-example/blob/master/sample.go) with go-bindata:
this is something I had to do in one of my libraries, [touchy](https://github.com/odino/touchy),
and that I automated through a [Makefile](https://github.com/odino/touchy/blob/060559872547c05afe1406b212445b4c6e1bbc14/Makefile#L12-L17)
(no `go-generate` for me, too lazy :)).

PS: on a side note, have you heard of [nexe](https://github.com/jaredallard/nexe)?
It's a compiling tool for node, which seems to alleviate the pain of distributing node executables.
