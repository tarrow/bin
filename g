#!/bin/bash

case "$1" in
"p" | "push" | "publish")
    git push origin HEAD:refs/publish/master
    ;;
"pd" | "draft" )
    git push origin HEAD:refs/drafts/master
    ;;
"pp" )
    git push origin HEAD:refs/publish/production
    ;;
"ppd" )
    git push origin HEAD:refs/drafts/production
    ;;
"am" | "amend" | "ammend" )
    git commit -a --amend
    ;;
*)
    echo You did it wrong, use one of, p pd pp ppd am
    ;;
esac