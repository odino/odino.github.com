---
layout: post
title: "Local k8s development in 2020"
date: 2019-12-31 15:45
comments: true
categories: [k8s, kubernetes, open source]
description: "This is how you can easily setup a local development workflow on a local kubernetes cluster."
---

{% img right /images/kubernetes-logo.png %}

This decade's about to wrap up, so I decided to spend some time
describing my development workflow as the year nears its end.

What I find interesting in my setup is that it entertains
working on a local k8s cluster -- mainly to keep in touch
with the systems that run in production. 

Running k8s locally isn't what
you'd want to do to begin with, but rather a natural path
once you start wanting to replicate the environment that runs
your live applications. Again, you don't need a local k8s
cluster just 'cause, so make sure you have a good reason
before going through the rest of this article.

<!-- more -->

## Cluster setup

Once a monstrous task, setting up a local k8s cluster is
now as simple as installing a package on your system:
Docker for Win/Mac allow you to run this very easily, and
Canonical has made it possible on Linux through [microk8s](https://microk8s.io/)
(that's my boy!).

One of the funny things about running on microk8s
(or snaps, in general) is how it will automagically
upgrade under your nose -- sometimes with breaking changes.
There was a recent change that [swapped docker for containerd
as microk8s' default container runtime](https://github.com/ubuntu/microk8s/issues/382), and it broke some
local workflows (more on that later, as it's easy to fix).
In general, you can always force a snap to use a particular
revision, so if anything's funky just downgrade and let others
figure it out :)

I'd be keen to try [k3s](https://k3s.io/) out, as it seem to provide an even more
lightweight way to run the local cluster. Built mainly for
IoT and edge computing, k3s is interesting as running
microk8s is sometime resource-intesive -- once I'm done
working on code, I usually prefer to `sudo snap disable microk8s`
in order to preserve RAM, CPU and battery life ([proof here](https://github.com/odino/dev/commit/20749dd50c590ec376b7eed2db558615f1ef6fda)).

In the past, I've also tried to work on a remote k8s cluster
in the GKE from my local machine, but that proved to be too
much of a hassle -- the beauty of `kubectl` is that you don't
really care where the cluster is running, but your IDE and
other tools work best when everything is present and running
locally.

## Development tool

This has been fairly stable until late this year, when I
decided to switch things around.

I've historically used helm and a bunch of shell magic
to run apps locally: you would clone a repo and expect
an `helm/` folder to be available, with the chart being
able to install a whole bunch of k8s resources on your
cluster. Then, a bash script run simply apply the chart
with a bunch of pre-configured values: you would run `dev up`
and what the script would do would simply be something
along the lines of:

``` 
docker build -t $CURRENT_FOLDER .
helm install --name $CURRENT_FOLDER ./helm/ --set mountPath=/home/alex/path/to/$CURRENT_FOLDER --set image=$CURRENT_FOLDER
kubectl logs -f deploy/$CURRENT_FOLDER --tail=100
```

Nothing too crazy...but with a few downsides:

* I started off with Helm 2, and v3 brought in a few changes I didn't want to go through
* helm is perfect if I want to package a generic app made up of multiple resources (service, ingress, etc) and release it to the outside world. Locally, I probably don't need all of that verbosity (`chart.yaml` and so on)
* most of the templating I did on development was `{% raw %}{{ .Release.name }}{% endraw %}`. What's the point then?

Towards the end of this year I went back to the drawing board
and started to think what if there was anything else I could
use that was simple enough and gave me enough flexibility.
I knew I could use simple k8s manifests but it wasn't clear
to me how I could integrate it into my workflow in a way
that made it simpler than using a chart -- and that's when I
gave [skaffold](https://skaffold.dev/) another chance.

Skaffold is an interesting tool, promoted by Google, that
supposedly handles local k8s development -- and I say "supposedly"
because I've tried it in the past and have been extremely
underwhelmed by its workflow.

Let me explain: whenever a chance is detected in your codebase, skaffold
wants to redeploy your manifests but, rather than simply
working on an application-reload logic, is instead happy
to:

* re-build your local image
* push it to a registry
* update the k8s deployment so a brand new pod comes up

If you've made it so far you probably realized that
the whole operation doesn't either come cheap nor fast
-- you could be waiting several seconds for your changes
to take effect...

That was, until skaffold introduced [file sync](https://skaffold.dev/docs/pipeline-stages/filesync/)
to avoid the need to rebuild, redeploy and restart pods.
This feature is currently in beta, but it's already working
well enough that I've decided to give it a shot, with very
positive results.

Now, rather than having an entire chart to mantain locally,
my development setup has a simple `skaffold.yaml` that
looks like:

```yml
apiVersion: skaffold/v1
kind: Config
build:
  artifacts:
  - image: my_app
    context: .
    sync:
      manual:
        - src: "**"
          dest: "/src"
deploy:
  kubectl:
    manifests:
      - skaffold/*.yaml
```

and I reduced the manifests to a simple k8s manifest
containing multiple resources, separated by `---`:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my_app
  labels:
    app: my_app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my_app
  template:
    metadata:
      name: my_app
      labels:
        app: my_app
    spec:
      restartPolicy: Always
      containers:
      - image: my_app
        name: my_app
        imagePullPolicy: IfNotPresent
        tty: true
        stdin: true
        env:
        - name: ENV
          value: dev
      terminationGracePeriodSeconds: 1
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my_app
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
    - hosts:
        - my-app.dev
  rules:
  - host: my-app.dev
    http:
      paths:
      - path: /
        backend:
          serviceName: my_app
          servicePort: http
  - host: my-app.dev
    http:
      paths:
      - path: /
        backend:
          serviceName: my_app
          servicePort: http
---
apiVersion: v1
kind: Service
metadata:
  name: my_app
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: my_app

```

That's about it. Now my `dev up` is mapped to a simple
`skaffold dev`, and skaffold takes care of re-building
the image when needed, syncing changes locally and so on.
One of the advantages of using this tool is that it automatically 
detects changes to the manifests and the Dockerfile, so
it re-builds the image without you having to trigger the
process manually (which wasn't possible with Helm alone).

Another interesting benefit of using skaffold is the support
for base registries as well as build stages. The former
allows you to run a registry at any given URL, and tell
skaffold to prepend that URL to any image that's being pushed
to the k8s cluster.

As I mentioned, I use microk8s, which doesn't play very well
with [locally-built images](https://microk8s.io/docs/registry-images),
so I simply run the built-in registry on port `32000`. Others
in my team simply run Docker for Mac which doesn't need a registry
as any image built locally is automatically available to k8s.

This would mean that I would have to update the `image` field
of my deployments, manually, to `localhost:32000/my_app`, a
tedious and annoying operation (and I'd also have to make sure
those changes aren't pushed to git). Skaffold frees you from the
drama with a simple `skaffold config set default-repo localhost:32000`,
a trick that will tell skaffold to parse all the manifests it deploys
and replace the `image` fields, prepending the URL of your own registry.
The feature is documented extensively [here](https://skaffold.dev/docs/environment/image-registries/),
and it's a life saver!

The support for build stages is another great trick up in
skaffold's sleeve, as it allows to use the power of Docker's
multi-stage builds in your development environment.

If you have a Dockerfile that looks like:

```
FROM golang:1.13 as dev

RUN go get -v github.com/codegangsta/gin
WORKDIR /src
COPY go.mod /src
COPY go.sum /src
RUN go mod download
COPY . /src

RUN go build -o my_go_binary main.go
CMD gin run main.go

FROM gcr.io/distroless/base as prod
COPY --from=dev /src /
CMD ["/my_go_binary"]
```

You can tell skaffold that, locally, it should simply stop at the
`dev` stage:

```yml
apiVersion: skaffold/v1
kind: Config
build:
  artifacts:
  - image: my_go_app
    docker:
      target: dev
    context: .
    sync:
      manual:
        - src: "**"
          dest: "/src"
deploy:
  kubectl:
    manifests:
      - skaffold/*.yaml
```

As you see, the `target` field does the trick.

Believe me, skaffold has made my life so much easier and it's a tool
I would gladly recommend. Before introducing file syncing I didn't
want to get my hads dirty with it, as I did not find the development
workflow sustainable (re-build and re-deploy at every file change),
but right now it works much better than anything I could have come
up with on my own.

## Hands on the code

Last but not least, we went over running a cluster as well as our
application -- but how do we actually debug our code or run tests?

Ideally, we'd like a script that would be able to:

* build and run your app (`up`)
* execute commands inside the container (`exec`)
* jump inside the container (`in`)
* execute tests (`test`)

Wouldn't it be nice to simply open a shell and run your tests with `dev test`?

Turns out, creating a simple wrapper over our wokflow is very
straightforward, and here's a sample of the code one could write:

```bash
#!/bin/bash

# dev $command
arg=$1
command="cmd_$1"

# Boot the app through skaffold.
cmd_up(){
    skaffold dev
}

# Deletes the app
cmd_delete(){
    skaffold delete
}

# This will drop you inside the container.
# We use bash, if available, else "sh"
cmd_in(){
    app=$(get_app_name)
    kubectl exec -ti deploy/$app -- sh -c "command -v bash && bash || sh"
}

# Read the app name based on the image we
# build inside the skaffold.yaml
get_app_name(){
  echo $(yq read skaffold.yaml build.artifacts.0.image)
}

# Main function: if a command has been passed,
# check if it's available, and execute it. If
# the command is not available, we print the
# default help.
main(){
    declare -f $command > /dev/null

    if [ $? -eq 0 ]
    then
        $command $@
    else
        printf "'$arg' is not a recognized command.\n\n"
        exit 1
    fi
}

shift
main $@
```

All this script does is to read the command passed to it
and run it as a bash function. As you see, `up` is mapped
to `skaffold dev`, and `in` is mapped to `kubectl exec ... -- bash`
(so that you can jump into the container and run whatever
command you'd like).

The actual `dev` I run locally is on github, under [odino/k8s-dev](https://github.com/odino/k8s-dev),
and I believe I should credit [Hisham](https://www.linkedin.com/in/hzarka/) for the original idea
-- this is a script we've been using (and polishing) since ages.

If you're wondering how does it look on the
terminal, here's an asciicast where tests
are run succesfully (`dev test`), we update
the code to make the tests fail and then 
we jump into the container (`dev in`), before
cleaning up (`dev delete`):

<script id="asciicast-07QLv6MRWkgurAu7uHxYfA421" src="https://asciinema.org/a/07QLv6MRWkgurAu7uHxYfA421.js" async></script>

## That's a wrap

Oh boy, right on time to close 2019 with a splash!

Developing on a local k8s cluster isn't super straightforward,
and I hope that by sharing my toolbox it should be easier for
you to set your environment up for a productive day.

Happy new decade!