---
layout: post
title: "Bootstrap of a Travis-CI test-machine"
date: 2012-07-26 21:16
comments: true
categories: [testing]
published: false
---

[Travis-CI]() is an awesome open source service which
makes continuos integration really easy in the context
of *github-hosted* projects.

<!-- more -->

It's not like travis is only limited to github projects
(verify), but you can get the best of it using its
github integration.

Developing Orient, I found out about Travis when one of
the 3 active guys actively collaborating to the project,
[Daniele]() created his own fork of the library to create
the CI environment on Travis.

## More than testing

Travis doesnt only provide a machine in which you can
continuosly running tests, it gives you a **free** VM
which you can freely manage in the context of testing
an application.

Ok, they don't actually give you a VM, but they provide
you an **environment** which gets bootstrapped following
your indications and executes the tasks that **you**
indicate: in that sense, Travis gives you VMs
*on-demand*.

So think about it: it's not only about testing, it's about
having an environment ready to do anything you want for
your own project.

## A real world example

For [Orient](), Daniele managed to setup a quite clever
bootstrap script.

We have a quite comprehensive test-suite which you can
execute with the single `phpunit` command, from the root
of the library, but it just executes tests which dont
directly talk to OrientDB.

To execute the full test-suite, including integration
tests, you just need to pass the test directory to the
CLI:

``` php
phpunit test/
```

but you'll need a working instance of OrientDB, with
predefined admin credentials (`admin`/`admin`) listening
to port `:2480`.

So our challenge was to use Travis being able to trigger
also the integration tests.

In the `.travis.yml` configuration file, we have:

```
language: php
php:
  - 5.3
  - 5.4
before_script:
  - sh -c ./bin/initialize-ci.sh 1.0rc6
script: phpunit test/
notifications:
  email:
    - ...@gmail.com
```

So, as you see, we have a bash script which
takes care of everything:

``` bash ./bin/initialize-ci.sh 1.0rc6
#!/bin/sh

PARENT_DIR=$(dirname $(cd "$(dirname "$0")"; pwd))
CI_DIR="$PARENT_DIR/ci-stuff/environment"

ODB_VERSION=${1:-"1.0rc6"}
ODB_PACKAGE="orientdb-${ODB_VERSION}"
ODB_DIR="${CI_DIR}/${ODB_PACKAGE}"
ODB_LAUNCHER="${ODB_DIR}/bin/server.sh"

echo "=== Initializing CI environment ==="

cd "$PARENT_DIR"

. "$PARENT_DIR/bin/odb-shared.sh"

if [ ! -d "$CI_DIR" ]; then
  # Fetch the stuff needed to run the CI session.
  git clone --quiet git://gist.github.com/1370152.git $CI_DIR

  # Download and extract OrientDB
  echo "--- Downloading OrientDB v${ODB_VERSION} ---"
  odb_download "http://orient.googlecode.com/files/${ODB_PACKAGE}.zip" $CI_DIR
  unzip -q "${CI_DIR}/${ODB_PACKAGE}.zip" -d $ODB_DIR && chmod +x $ODB_LAUNCHER

  # Copy the configuration file and the demo database
  echo "--- Setting up OrientDB ---"
  tar xf $CI_DIR/databases.tar.gz -C "${ODB_DIR}/"
  cp $PARENT_DIR/ci-stuff/orientdb-server-config.xml "${ODB_DIR}/config/"
  cp $PARENT_DIR/ci-stuff/orientdb-server-log.properties "${ODB_DIR}/config/"
else
  echo "!!! Directory $CI_DIR exists, skipping downloads !!!"
fi

# Start OrientDB in background.
echo "--- Starting an instance of OrientDB ---"
sh -c $ODB_LAUNCHER </dev/null &>/dev/null &

# Wait a bit for OrientDB to finish the initialization phase.
sleep 5
printf "\n=== The CI environment has been initialized ===\n"
```

I think the script speaks for itsef: we directly download
OrientDB from the official website, de-compress it, configure
OrientDB with our standard configuration file and launch the
ODB server, outputting in `/dev/null`.

Now, all of this happens everytime someone commits to the `master`
on Github: pretty easy, simple but so powerful.

I really recommend you to start having a look at Travi-CI
and how you can benefit of a CI server, fully configurable,
for free, for the sake of your own code.

One last note: yes, all of this comes for free, but if you use
Travis you should really consider making a donation to
show the guys behind the project [your love]().