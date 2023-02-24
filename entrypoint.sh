#!/bin/sh -l
# args: ref show history
set +e

# TODO maybe we can skip ALL commits
# https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches
git tag | xargs git tag -d
for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done
git fetch --all --prune --tags
git pull --all


echo "\n\n============ GTO ============\n"
echo "The Git tag that triggered this run: $GITHUB_REF"


export NAME=`gto --tb check-ref $GITHUB_REF --name`
export VERSION=`gto --tb check-ref $GITHUB_REF --version`
export EVENT=`gto --tb check-ref $GITHUB_REF --event`


if [ "$EVENT" = "assignment" ]; then
  export STAGE=`gto --tb check-ref $GITHUB_REF --stage`
fi


if [ $NAME ]; then
  export TYPE=`gto --tb describe $NAME --type`
  export ARTIFACT_PATH=`gto --tb describe $NAME --path`
  export DESCRIPTION=`gto --tb describe $NAME --description`
fi


if [ $NAME ]; then
  gto --tb show $NAME
  gto --tb history $NAME
fi


if [ "$2" = "true" ]; then
  gto --tb show
fi


if [ "$3" = "true" ]; then
  gto --tb history
fi


echo "name=$NAME" >> $GITHUB_OUTPUT
echo "stage=$STAGE" >> $GITHUB_OUTPUT
echo "version=$VERSION" >> $GITHUB_OUTPUT
echo "event=$EVENT" >> $GITHUB_OUTPUT
echo "type=$TYPE" >> $GITHUB_OUTPUT
echo "path=$ARTIFACT_PATH" >> $GITHUB_OUTPUT
echo "description=$DESCRIPTION" >> $GITHUB_OUTPUT


if [ "$4" = "true" ]; then
  echo "\nAfter Git tag parsing, the following outputs are set:"
  cat $GITHUB_OUTPUT
  echo "\n"
fi
