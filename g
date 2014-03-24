#!/bin/bash

command=$1
# Try to grab a branch from the second param
if [ -z "$2" ]; then
   param="master"
else
   param=$2
fi

# See if we are a gerrit or git repo
remote=$(git config --get remote.origin.url)
if [[ $remote == *github.com* ]]; then
    gitType="github"
elif [[ $remote == *gerrit.wikimedia.org* ]]; then
    gitType="gerrit"
else
    gitType="unknown"
fi

case "$command" in
"co" | "checkout" )
    git checkout $param
    ;;
"pu" | "pull" )
    git pull
    ;;
"p" | "push" | "publish" )
    if [ $gitType == "github" ]; then
	    git push origin $param
	elif [ $gitType == "gerrit" ]; then
        git push origin HEAD:refs/publish/$param
	fi
    ;;
"pd" | "draft" )
    if [ $gitType == "gerrit" ]; then
	    git push origin HEAD:refs/drafts/$param
	else
	    echo "Unrecognised action for repo type!"
	fi
    ;;
"ro" )
    git reset --hard origin/$param
    ;;
"am" | "amend" | "ammend" )
    git commit -a --amend
    ;;
"d" | "dif" | "diff" )
    git diff
    ;;
*)
    echo "No command given!"
	echo ""
    echo "Allowed Commands:"
	echo "    am   = commit -a --amend"
	echo "    co   = checkout $2(default master)"
	echo "    d    = diff"
	echo "    p    = push to branch $2(default master)"
	echo "    pd   = push draft to branch $2(default master) (Gerrit only)"
	echo "    pu   = pull"
	echo "    ro   = reset --hard to origin/$2(default master)"
    ;;
esac