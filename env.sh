#!/bin/bash
export PATH_HXX=$(pwd)

alias gopost="cd \"$PATH_HXX\"/_posts"
alias godraft="cd \"$PATH_HXX\"/_drafts"
alias goasset="cd \"$PATH_HXX\"/_assets"
alias start="jekyll serve &"
alias build="jekyll build &"
alias kill="ps aux | grep jekyll | awk '{print \$2}' | xargs kill -9"

echo "HXX ENV SETUP ********************************************"
echo "gopost  : go to _posts"
echo "godraft : go to _drafts"
echo "goasset : go to _assets"
echo "start   : jekyll serve"
echo "build   : jekyll build"
echo "kill    : kill localhost server"
echo "**********************************************************"
