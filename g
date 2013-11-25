#!/bin/bash

case "$1" in
"p" | "push" | "publish")
    git push origin HEAD:refs/publish/master
    ;;
"pd" | "draft" )
    git push origin HEAD:refs/drafts/master
    ;;
"am" | "amend" | "ammend" )
    git commit -a --amend
    ;;
*)
    echo You did it wrong, use one of, p pd am
    ;;
esac