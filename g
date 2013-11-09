#!/bin/bash

case "$1" in
"p" | "push" | "publish")
    git push origin HEAD:refs/publish/master
    ;;
"pd" | "draft" )
    git push origin HEAD:refs/drafts/master
    ;;
"cp" | "cherry" | "cherry-pick" )
    git fetch ssh://gerrit.wikimedia.org:29418/mediawiki/extensions/Wikibase refs/changes/$2 && git cherry-pick FETCH_HEAD
    ;;
"c" | "co" | "checkout" | "check-out" )
    git fetch ssh://gerrit.wikimedia.org:29418/mediawiki/extensions/Wikibase refs/changes/$2 && git checkout FETCH_HEAD
    ;;
"am" | "amend" | "ammend" )
    git commit -a --amend
    ;;
*)
    echo You did it wrong, use one of,  p pd cp c
    ;;
esac