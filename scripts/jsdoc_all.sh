#!/bin/bash
# Update all git repos from xtuple branch

echo '******Documenting enyo-x******'
rm -rf ~/Devel/tools/jsdoc/out
~/Devel/tools/jsdoc/jsdoc -r ~/Devel/git/enyo-x/source
rm -rf ~/Devel/git/enyo-x/docs
cp -r ~/Devel/tools/jsdoc/out ~/Devel/git/enyo-x/docs
rm -rf ~/Devel/tools/jsdoc/out
cd ~/Devel/git/enyo-x
git status docs

#echo '******Documenting backbone-x******'
#rm -rf ~/Devel/tools/jsdoc/out
#~/Devel/tools/jsdoc/jsdoc -r ~/Devel/git/backbone-x/source
#rm -rf ~/Devel/git/backbone-x/docs
#cp -r ~/Devel/tools/jsdoc/out ~/Devel/git/backbone-x/docs
#rm -rf ~/Devel/tools/jsdoc/out
#cd ~/Devel/git/backbone-x
#git status docs
