#!/bin/sh
#
echo "输入tag:"
read tag

# tag=$1

if [[ -n $tag ]];then
    echo "当前tag: ${tag} "
else
    echo "请输入tag"
    exit;
fi


git add --all
git commit -m "build:${tag}"
git push github master

git tag $tag
git push github --tags

#pod trunk push MEDToast.podspec --allow-warnings
#pod repo push edoctor MEDToast.podspec --verbose --use-libraries --allow-warnings
pod trunk push MEDToast.podspec --allow-warnings --verbose --use-libraries