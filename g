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

#copy pull all commands
HIGHLIGHT="\e[01;33m"
NORMAL='\e[00m'

function update {
  local d="$1"
  if [ -d "$d" ]; then
    if [ -e "$d/.ignore" ]; then 
      echo -e "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
    else
      cd $d > /dev/null
      if [ -d ".git" ]; then
        echo -e "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
        git pull &
      else
        scan *
      fi
      cd .. > /dev/null
    fi
  fi
  #echo "Exiting update: pwd=`pwd`"
}

function scan {
  echo -e "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
  git pull &
  for x in $*; do
    update "$x"
  done
}

case "$command" in
"co" | "checkout" )
    git checkout $param
    ;;
"c" | "commit" )
    git commit -a
    ;;
"pu" | "pull" )
    git pull
    ;;
"pa" | "pullall" )
	if [ "$2" != "" ]; then cd $2 > /dev/null; fi
	echo -e "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
	scan *
	wait
	echo Everything pulled
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
"re" )
    git rebase origin/$param
    ;;
"ro" )
    git reset --hard origin/$param
    ;;
"am" | "amend" | "ammend" )
    if [ $param == "now" ] || [ $param == "n" ]; then
        git commit -a --amend --no-edit
    else
        git commit -a --amend
    fi
    ;;
"d" | "dif" | "diff" )
    git diff
    ;;
"ha" | "hash" )
    git rev-parse HEAD
    ;;
"msg" )
    if [ $param == "master" ]; then
        gitUser="addshore"
    else
        gitUser=$param
    fi
    scp -P 29418 $gitUser@gerrit.wikimedia.org:hooks/commit-msg .git/hooks/commit-msg
    ;;
*)
    echo "No command given!"
    echo ""
    echo "Allowed Commands:"
    echo "    am   = commit -a --amend (use 'am n' or 'am now' to skip editing the msg)"
    echo "    c    = commit commit -a"
    echo "    co   = checkout $2(default master)"
    echo "    d    = diff"
    echo "    ha   = git rev-parse HEAD"
    echo "    p    = push to branch $2(default master)"
    echo "    pd   = push draft to branch $2(default master) (Gerrit only)"
    echo "    pu   = pull"
    echo "    re   = rebase"
    echo "    ro   = reset --hard to origin/$2(default master)"
    echo "    msg  = scp -P 29418 PARAM@gerrit.wikimedia.org:hooks/commit-msg .git/hooks/commit-msg"
	echo "	  pa   = pull all down the directory tree"
    ;;
esac
