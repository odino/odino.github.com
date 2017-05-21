---
layout: post
title: "Local development with rkt containers"
date: 2017-05-15 23:21
comments: true
categories: [linux, containers, docker, rkt, development]
description: "Time to explore rkt, a fast-growing alternative to Docker."
---

{% img right /images/rkt.png %}

A few weeks ago I stumbled upon an interesting [hackernews discussion](https://news.ycombinator.com/item?id=14176191)
about setting up development environments: from what I could tell it seemed like
most people have been ditching Vagrant and VMs in order to move towards
docker containers, through [docker-compose](https://docs.docker.com/compose/)
or [minikube](https://github.com/kubernetes/minikube).

Compose, to be fair, provides a painless user experience and allows you to extend
your Dockerfiles to be able to run containers with specific "dev" settings, like
local volumes and different commands (think `node index.js` vs `nodemon index.js`).

What if we could have a similar experience with [rkt](https://coreos.com/rkt/docs/latest/)?

<!-- more -->

All in all, what you need to run docker containers locally are:

* a bunch of binaries (`docker` / `docker-compose`)
* a file to build your production image (`Dockerfile`)
* a file to extend that image with some dev settings (`docker-compose.yml`)

Since I wanted to play with rkt and I couldn't find an easy way to maintain the
same workflow I had using docker, I decided to build a small tool called [rkd](https://github.com/odino/rkd)
(*rkt dev*) that can help you achieve the same exact productivity you'd have
using docker and docker-compose. This is an early-stage experiment{% fn_ref 1 %} and, as such,
things might break here & there.

Let me recap it: like we'd do with docker, we'll first need to **download a bunch
of binaries**, then **create a file that describes our production container** and, last
but not least, **define our dev settings** in another file.

If the whole thing takes longer than 5 minutes we fail, so let's get to it!

## Step 0: our sample NodeJS app

Create a brand new folder in your fs (`path/to/my/app`), a subfolder `src` and
place an `index.js` there:

``` js path/to/my/app/src/index.js
require('http').createServer(function (req, res) {
  res.end('Hello world!')
  console.log('Request received...')
}).listen(8080)

console.log('server started...')
```

No rocket science.

## Step 1: binaries

We will need to download binaries for our platform of 3 tools:

* [rkt](https://github.com/rkt/rkt/releases), the container engine
* [acbuild](https://github.com/containers/build/releases), the tool that's used to build [ACIs](https://coreos.com/rkt/docs/latest/app-container.html#aci), which are containers images that rkt can run
* [rkd](https://github.com/odino/rkd/releases), a tool I've built to be able to automate building & running rkt containers

Once you've grabbed the binaries you can test them by running `rkt`, `acbuild` &
`rkd`.

## Step 2: writing a "Dockerfile"

In order to build ACIs we would need to run a bunch of shell commands such as:

``` bash
acbuild begin
acbuild set-name example.com/hello
acbuild dep add quay.io/coreos/alpine-sh
run -- apk add --update nodejs
...
...
...
acbuild end
```

but that's a hella lot of commands and being repetitive is no fun at all -- we
can automate this task with `rkd`.

Let's create a `prod.rkd` file:

``` bash path/to/my/app/prod.rkd
set-name example.com/node-hello
dep add quay.io/coreos/alpine-sh
run -- apk add --update nodejs
copy src /src
set-working-directory /src
set-exec -- node index.js
port add www tcp 8080
```

Here we're describing how our "production" container should look like, similarly
to what we'd do with a Dockerfile:

``` bash Dockerfile
FROM quay.io/coreos/alpine-sh
RUN apk add --update nodejs
COPY src /src
WORKDIR /src
CMD node index.js
EXPOSE 8080
```

As you see, the syntax is extremely similar, you just need to familiarize with
`acbuild`'s commands.

After writing our `prod.rkd` we are ready to extend it with our own development
settings.

## Step 3: writing a "docker-compose.yml"

Our `docker-compose.yml` will instead be named `dev.rkd`, and we just need a
couple instruction in it to mount our local code and change the executable that
is used to run the container:

``` bash path/to/my/app/dev.rkd
run -- npm install -g nodemon
mount add . src
set-exec -- nodemon index.js
```

Nothing more, nothing less: we are now ready to rock!

## Let's run our app!

In order to build the ACIs and run them in "dev" mode we simply need to type
`rkd up`:

``` bash
$ sudo rkd up
Building /root/.rkd/prod-5290facf0b502d01ba15b7de9a1b9633.aci
acbuild begin
acbuild set-name example.com/node-hello
acbuild dep add quay.io/coreos/alpine-sh
acbuild run -- apk add --update nodejs
Downloading quay.io/coreos/alpine-sh: [========================] 2.65 MB/2.65 MB
fetch http://dl-4.alpinelinux.org/alpine/v3.2/main/x86_64/APKINDEX.tar.gz
(1/4) Installing libgcc (4.9.2-r6)
(2/4) Installing libstdc++ (4.9.2-r6)
(3/4) Installing libuv (1.5.0-r0)
(4/4) Installing nodejs (0.12.10-r0)
Executing busybox-1.23.2-r0.trigger
OK: 28 MiB in 19 packages
acbuild copy src /src
acbuild set-working-directory /src
acbuild set-exec -- node index.js
acbuild port add www tcp 8080
acbuild write /root/.rkd/prod-5290facf0b502d01ba15b7de9a1b9633.aci
acbuild end
Building /root/.rkd/dev-a023872855269062eca818f2ea8c0b32.aci
acbuild begin ./prod.aci
acbuild run -- npm install -g nodemon
Downloading quay.io/coreos/alpine-sh: [========================] 2.65 MB/2.65 MB
npm WARN optional dep failed, continuing fsevents@1.1.1
/usr/bin/nodemon -> /usr/lib/node_modules/nodemon/bin/nodemon.js
nodemon@1.11.0 /usr/lib/node_modules/nodemon
├── ignore-by-default@1.0.1
├── undefsafe@0.0.3
├── es6-promise@3.3.1
├── debug@2.6.6 (ms@0.7.3)
├── touch@1.0.0 (nopt@1.0.10)
├── minimatch@3.0.4 (brace-expansion@1.1.7)
├── ps-tree@1.1.0 (event-stream@3.3.4)
├── lodash.defaults@3.1.2 (lodash.restparam@3.6.1, lodash.assign@3.2.0)
├── chokidar@1.7.0 (path-is-absolute@1.0.1, inherits@2.0.3, async-each@1.0.1, glob-parent@2.0.0, is-binary-path@1.0.1, is-glob@2.0.1, readdirp@2.1.0, anymatch@1.3.0)
└── update-notifier@0.5.0 (is-npm@1.0.0, semver-diff@2.1.0, chalk@1.1.3, string-length@1.0.1, repeating@1.1.3, configstore@1.4.0, latest-version@1.0.1)
acbuild mount add src src
acbuild set-exec -- nodemon index.js
acbuild write /root/.rkd/dev-a023872855269062eca818f2ea8c0b32.aci
acbuild end
rkt --insecure-options=image --net=host run --interactive --volume src,kind=host,source=/home/odino/projects/go/src/github.com/odino/rkd/example/src /root/.rkd/dev-a023872855269062eca818f2ea8c0b32.aci
[nodemon] 1.11.0
[nodemon] to restart at any time, enter `rs`
[nodemon] watching: *.*
[nodemon] starting `node index.js`
server started...
```

Then open [localhost:8080](http://localhost:8080) on your browser and...

{% img center /images/rkd-server.png %}

Hell yeah.

## Conclusion

I hope you enjoyed this article and are excited about the progress made by rkt
in order to provide a viable alternative to docker. I wrote rkd in a few hours
and it really is just a wrapper around acbuild & rkt, so kudos to those guys.

In my opinion, rkt is still quite behind docker but they're filling the gaps,
getting closer as the days go by -- it won't be long until we'll be realistically
able to switch over without "feeling" the difference.

{% footnotes %}
  {% fn I've been working on rkd during weekends, at conferences and over public WiFis, so you can imagine... :) %}
{% endfootnotes %}
