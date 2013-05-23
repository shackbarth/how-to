#!/bin/bash
# Update all git repos from xtuple branch

echo "******Updating xtuple******"
cd ~/Devel/git/xtuple
git checkout xtuple
git pull
git checkout master
git merge xtuple
git submodule update --recursive
npm install

echo "******Updating private-extensions******"
cd ~/Devel/git/private-extensions
git checkout xtuple
git pull
git checkout master
git merge xtuple

echo "******Remember to refresh your databases if you have see activity in the database repo******"
