#!/bin/bash

command=$1
# Try to grab a branch from the second param
if [ -z "$2" ]; then
   param="master"
else
   param=$2
fi

case "$command" in
"co" | "checkout" )
    git checkout $param
    ;;
"pu" | "pull" )
    git pull
    ;;
"p" | "push" | "publish" )
    git push origin HEAD:refs/publish/$param
    ;;
"pd" | "draft" )
    git push origin HEAD:refs/drafts/$param
    ;;
"ro" )
    git reset --hard origin/$param
    ;;
"am" | "amend" | "ammend" )
    git commit -a --amend
    ;;
*)
    echo "Allowed Commands: p pd am ro pu co"
    echo "Allowed Param: string, defaults to 'master'"
    ;;
esac