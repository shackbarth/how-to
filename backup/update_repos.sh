#!/bin/bash
# Update all git repos from XTUPLE 

echo "******Updating xtuple******"
cd ~/git/xtuple
git checkout master
git fetch XTUPLE
git merge XTUPLE/master
git checkout XTUPLE/4_5_x

echo "******Updating private-extensions******"
cd ~/git/private-extensions
git checkout master
git fetch XTUPLE
git merge XTUPLE/master
git checkout XTUPLE/4_5_x

echo "******Updating xtuple-extensions******"
cd ~/git/xtuple-extensions
git checkout master
git fetch XTUPLE
git merge XTUPLE/master
git checkout XTUPLE/4_5_x
