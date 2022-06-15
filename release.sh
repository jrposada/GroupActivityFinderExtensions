#!/bin/sh
while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG:?Need value};;
    esac
done

# version=$(awk '/^## AddOnVersion/{print $NF}' GroupActivityFinderExtensions.txt)

# output = build/GroupActivityFinderExtensions


mkdir build/GroupActivityFinderExtensions

cp -r src build/GroupActivityFinderExtensions
cp GroupActivityFinderExtensions.txt  build/GroupActivityFinderExtensions
cp main.lua  build/GroupActivityFinderExtensions
cp vars.lua  build/GroupActivityFinderExtensions
cp settings-menu.lua  build/GroupActivityFinderExtensions

# zip ./build/GroupActivityFinderExtensions-$version.zip -r ./build/GroupActivityFinderExtensions
rm -rf build/GroupActivityFinderExtensions
