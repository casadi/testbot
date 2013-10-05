#!/bin/bash

git fetch $1 tested
git checkout -b tested FETCH_HEAD
git merge develop -Xtheirs -m "automatic casadibot merge" --no-ff
git push $1 tested
git checkout develop
git branch -D tested
