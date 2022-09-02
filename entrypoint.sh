#!/bin/sh -l
# args: ref show history
set +e

# TODO maybe we can skip ALL commits
# https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches
git tag | xargs git tag -d
for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
git fetch --all --prune --tags
git pull --all


if [ "$2" = "true" ]; then
  gto show
fi

if [ "$3" = "true" ]; then
  gto history
fi


export NAME=`gto check-ref $1 --name`
export VERSION=`gto check-ref $1 --version`
export EVENT=`gto check-ref $GITHUB_REF --event`


if [ "$EVENT" = "assignment" ]; then
  export STAGE=`gto check-ref $GITHUB_REF --stage`
fi

echo "::set-output name=name::$NAME"
echo "::set-output name=stage::$STAGE"
echo "::set-output name=version::$VERSION"
echo "::set-output name=event::$EVENT"