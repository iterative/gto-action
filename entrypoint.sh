#!/bin/sh -l
# args: ref show history
set +e

# TODO maybe we can skip ALL commits
# https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches
git tag | xargs git tag -d
for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
git fetch --all --prune --tags
git pull --all


echo "\n\n\n============ GTO ============\n"
echo "The Git tag that triggered this run: $GITHUB_REF"


export NAME=`gto check-ref $GITHUB_REF --name`
export VERSION=`gto check-ref $GITHUB_REF --version`
export EVENT=`gto check-ref $GITHUB_REF --event`


if [ "$EVENT" = "assignment" ]; then
  export STAGE=`gto check-ref $GITHUB_REF --stage`
fi


if [ $NAME ]; then
  gto show $NAME
  gto history $NAME
  export TYPE=`gto describe $NAME --type`
  export ARTIFACT_PATH=`gto describe $NAME --path`
  export DESCRIPTION=`gto describe $NAME --description`
fi


if [ "$2" = "true" ]; then
  gto show
fi


if [ "$3" = "true" ]; then
  gto history
fi


echo "::set-output name=name::$NAME"
echo "::set-output name=stage::$STAGE"
echo "::set-output name=version::$VERSION"
echo "::set-output name=event::$EVENT"
echo "::set-output name=type::$TYPE"
echo "::set-output name=path::$ARTIFACT_PATH"
echo "::set-output name=description::$DESCRIPTION"
