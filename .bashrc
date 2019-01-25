alias octopreview='rake preview'

octopost () {
  rake new_post && chmod -R 777 source/_posts && octopreview;
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
