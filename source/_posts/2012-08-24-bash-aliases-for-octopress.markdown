---
layout: post
title: "Shell aliases for Octopress"
date: 2012-08-24 11:02
comments: true
categories: [octopress, shell, ZSH]
published: true
---

A few days ago I moved to [ZSH](http://en.wikipedia.org/wiki/Z_shell) 
from bash, since my friend David was pushing me to try it:
after a few days I really have to say
that there is no reason not to switch
- mainly for the git integration and
double-tab behaviour - and I also
created a few *aliases* that work like
a charm in Octopress.

<!-- more -->

The majority of them would also work in
bash, but I remember I had to make
[some changes](https://github.com/imathis/octopress/issues/117)
to make Octopress work with ZSH, so
you may want to have a look at that discussion first.

Bare in mind that all of this aliases need to be put in
the `~/.zshrc` file.

## octopreview

``` bash
alias octopreview='rake preview'
```

Starts Octopress' preview mode:

``` bash
~/Sites/odino.github.com (source ✘)✹✭ ᐅ octopreview

Starting to watch source with Jekyll and Compass. Starting Rack on port 4000
```

## octopost

``` bash
octopost () {
  rake new_post && octopreview;
}
```

This task let's you create a new post and
automatically launches Octopress' preview mode:

``` bash
~/Sites/odino.github.com (source ✘)✹ ᐅ octopost

Enter a title for your post: bash aliases for octopress
mkdir -p source/_posts
Creating new post: source/_posts/2012-08-24-bash-aliases-for-octopress.markdown
Starting to watch source with Jekyll and Compass. Starting Rack on port 4000
```

## octostat

``` bash
octostat () {
  rake list_posts;
}
```

Based on this [rake task](http://tonytonyjan.github.com/2012/05/02/list-all-posts-rake-task-for-octopress/)
that I [slightly modified for ZSH](https://github.com/odino/odino.github.com/blob/source/Rakefile#L388),
this lets you find out which posts are published/unpublished
in your blog:

``` bash
~/Sites/odino.github.com (source ✘)✹✭ ᐅ octostat

(pub|unpub): unpub
2012-08-24-bash-aliases-for-octopress.markdown
```

## octosave

``` bash
octosave () {
        git add . && git commit -m "$@" && git push origin source;
}
```

Saves all your local changes committing
and pushing everything on the remote `source`
branch:

``` bash
~/Sites/odino.github.com (source ✘)✹✭ ᐅ octosave "partial article"

[source 572b571] partial article
 62 files changed, 159 insertions(+), 61 deletions(-)
 create mode 100644 source/_posts/2012-08-24-bash-aliases-for-octopress.markdown
Counting objects: 255, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (129/129), done.
Writing objects: 100% (129/129), 12.45 KiB, done.
Total 129 (delta 64), reused 0 (delta 0)
To git@github.com:odino/odino.github.com.git
   35d5d41..572b571  source -> source
```

## octodeploy

``` bash
octodeploy () {
        git add . && git commit -m "$@" && git push origin source && rake generate && rake deploy
}
```

Same as `octosave`, but - additionally - it deploys
all of your changes via `rake deploy`.

This task is useful when you're locally done and
want to publish your changes:

``` bash
~/Sites/odino.github.com (source ✔) ᐅ octodeploy "publishing changes"

[source 43e08b3] publishing changes
 1 files changed, 27 insertions(+), 1 deletions(-)
Counting objects: 9, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 848 bytes, done.
Total 5 (delta 4), reused 0 (delta 0)
To git@github.com:odino/odino.github.com.git
   572b571..43e08b3  source -> source
## Generating Site with Jekyll
unchanged sass/screen.scss
/Users/odino/.rvm/gems/ruby-1.9.3-p194/gems/maruku-0.6.0/lib/maruku/input/parse_doc.rb:22:in `<top (required)>': iconv will be deprecated in the future, use String#encode instead.
Configuration from /Users/odino/Sites/odino.github.com/_config.yml
Building site: source -> public
AliasGenerator loading...
Processing 120 post(s) for aliases...
Processing 18 page(s) for aliases...
Successfully generated site: source -> public
## Found posts in preview mode, regenerating files ...
## Generating Site with Jekyll
unchanged sass/screen.scss
/Users/odino/.rvm/gems/ruby-1.9.3-p194/gems/maruku-0.6.0/lib/maruku/input/parse_doc.rb:22:in `<top (required)>': iconv will be deprecated in the future, use String#encode instead.
Configuration from /Users/odino/Sites/odino.github.com/_config.yml
Building site: source -> public
AliasGenerator loading...
Processing 120 post(s) for aliases...
Processing 18 page(s) for aliases...
Successfully generated site: source -> public
## Deploying branch to Github Pages 

## copying public to _deploy
cp -r public/. _deploy
cd _deploy

## Commiting: Site updated at 2012-08-24 07:22:23 UTC
[master 3151733] Site updated at 2012-08-24 07:22:23 UTC
 70 files changed, 70 insertions(+), 70 deletions(-)

## Pushing generated _deploy website
Counting objects: 284, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (143/143), done.
Writing objects: 100% (143/143), 12.25 KiB, done.
Total 143 (delta 70), reused 0 (delta 0)
To git@github.com:odino/odino.github.com.git
   78287e6..3151733  master -> master

## Github Pages deploy complete
cd -
```