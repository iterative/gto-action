#!/bin/sh -l
# args: ref show history

set -eu

git config --global --add safe.directory /github/workspace

# TODO maybe we can skip ALL commits
# https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches
git tag | xargs git tag -d
for remote in `git branch -r`; do 
     git branch --track ${remote#origin/} $remote || \
       echo "Failed to track `$remote` brach: already tracked or doesn't exist."
done
git pull --all --prune --tags


echo "\n\n============ GTO ============\n"
echo "The Git tag that triggered this run: $GITHUB_REF"


export NAME=`gto check-ref $GITHUB_REF --name`
export VERSION=`gto check-ref $GITHUB_REF --version`
export EVENT=`gto check-ref $GITHUB_REF --event`


if [ "$EVENT" = "assignment" ]; then
  export STAGE=`gto check-ref $GITHUB_REF --stage`
else
  export STAGE=""
fi


if [ $NAME ]; then
  export TYPE=$(python /read_annotation.py type)
  export DESC=$(python /read_annotation.py desc)
  export ARTIFACT_PATH=$(python /read_annotation.py path)
else
  export TYPE=""
  export DESC=""
  export ARTIFACT_PATH=""
fi


if [ $NAME ]; then
  gto show $NAME
  gto history $NAME
fi


if [ "$2" = "true" ]; then
  gto show
fi


if [ "$3" = "true" ]; then
  gto history
fi


echo "name=$NAME" >> $GITHUB_OUTPUT
echo "stage=$STAGE" >> $GITHUB_OUTPUT
echo "version=$VERSION" >> $GITHUB_OUTPUT
echo "event=$EVENT" >> $GITHUB_OUTPUT
echo "type=$TYPE" >> $GITHUB_OUTPUT
echo "path=$ARTIFACT_PATH" >> $GITHUB_OUTPUT
echo "description=$DESC" >> $GITHUB_OUTPUT


if [ "$4" = "true" ]; then
  echo "\nAfter Git tag parsing, the following outputs are set:"
  cat $GITHUB_OUTPUT
  echo "\n"
fi

if [ "$5" = "true" ]; then
  if [ -z "$ARTIFACT_PATH" ]; then
    echo "\nAnnotation is not found, can't `dvc pull` the artifact. Exiting the action."
    exit 1
  fi
  dvc pull $ARTIFACT_PATH || exit 1
  echo "\nThe artifact now can be found at its path. Use action outputs to find it out."
fi
