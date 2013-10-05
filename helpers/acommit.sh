#!/bin/bash

git diff
git diff-files --quiet
dirty=$?
if [ $dirty -ne 0 ]; then
  git commit -a -m "$1"
else
  echo "Nothing to commit"
fi
