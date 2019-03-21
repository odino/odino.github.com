---
layout: post
title: "The ABS programming language in real life (part 1): removing 1 file from all of your GitHub repositories"
date: 2019-03-21 06:30
comments: true
categories: [abs, scripting, programming language, open source]
description: "A few weeks ago I used the ABS programming language for a fun task: removing a file from each of my GitHub repositories."
---

It's no secret I've been spending some time having fun with [ABS](https://www.abs-lang.org/),
a programming language with a terse and coincise syntax that can simplify working with shell
commands.

A few weeks ago I needed to remove a file from all of [Namshi](https://github.com/namshi)'s private GitHub repositories,
and did so with an ABS script.

Let's get to it!

<!-- more -->

## build.yml

Namshi has been running Docker builds on a tool we open-sourced, [Roger](https://github.com/namshi/roger),
until we decided to migrate to [Google Cloud Build](https://cloud.google.com/cloud-build/docs/)
as it offered a similar service without the need of having to manage the build infrastructure
ourselves -- the less we manage, the happier we are.

When you setup a build on Roger, it will infer metadata from a `build.yml` file
in the root of the repo:

``` yaml
redis: # this is the name of your project
  registry: registry.company.com # your private registry, ie. 127.0.0.1:5000
```

Now, we had pushed this file to all of our internal repositories, and with the migration
to GCB we didn't need them anymore. Time to flush them all!

## The idea

I wanted this to be as quick as possible, without having to go through
sending pull requests to each repository: who would have time to review and approve
all these trivial PRs that would simply remove one, now-useless file?

The script had to do something very simple:

* get a list of all of our repositories
* try to see if a `build.yml` exists in the root of the repo
* patch `master` with a new commit that removes the file

Easy peasy, no?

## The script

The code is quite straightforward, with the only exception of having to handle pagination
since the GitHub API won't return us a full list of repos: even with that, it's simply
a matter of keeping track of a counter and exit the `while` loop when there are no more
repositories to fetch. The whole functionality is implemented in ~30 lines of code:

``` bash
token = env("GH_TOKEN")
no_more_repos = false
page = 1

while !no_more_repos {
    repos = `curl -s -H "Authorization: token $token" "https://api.github.com/orgs/namshi/repos?page=$page&type=private"`.json()

    if !repos.len() {
        no_more_repos = true
        echo("End of repositories!")
        return null
    }
    
    for r in repos {
        repo_name = r.full_name
        echo("Processing %s...", repo_name)
        file = `curl -X GET -s -H "Authorization: token $token" "https://api.github.com/repos/$repo_name/contents/build.yml"`.json()

        if file.sha {
            sha = file.sha
            delete = `curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "Authorization: token $token" "https://api.github.com/repos/namshi/$repo_name/contents/build.yml" --data '{"message": "removed build.yml", "sha": "$sha"}'`
            echo("%s %s", delete, repo_name)
        } else {
            echo("%s does not have a build.yml, skipping it", repo_name)
        }
    }

    page += 1
}
```

Then it's just a matter of running the script:

``` bash
$ GH_TOKEN=xyz abs build-remover.abs
Processing $REPO_1...
$REPO_1 does not have a build.yml, skipping it
Processing $REPO_2...
200

[...]
```

On GitHub, each of your repos will have a commit that
removes the file you're gunning for:

{% img center /images/build-remover.png %}

This is an example of where I think ABS truly shines:
the ability to issue system commands (`` `curl ...` ``) and parse
the results like a traditional programming language: in this script,
I've used `response.json()` extensively since the GitHub API
returns JSON content, and it becomes extremely simple to turn that
response into an ABS data structure we can work with.

## What are you waiting for?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!