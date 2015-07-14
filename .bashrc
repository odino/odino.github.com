alias octopreview='rake preview'

octopost () {
  rake new_post && chown 1000:1000 source/_posts/* && octopreview;
}

octostat () {
  rake list_posts;
}

octofast () {
        rake "isolate[$@]"
}

octointegrate () {
        rake integrate
}

octodeploy () {
        git add . && git commit -m "$@" && git push origin source && rake deploy
}

octosave () {
        git add . && git commit -m "$@" && git push origin source;
}
