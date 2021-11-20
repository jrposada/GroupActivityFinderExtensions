while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG:?Need value};;
    esac
done

# version=$(awk '/^## AddOnVersion/{print $NF}' GroupActivityFinderExtensions.txt)

mkdir GroupActivityFinderExtensions

cp -r Business GroupActivityFinderExtensions
cp -r Infrastructure  GroupActivityFinderExtensions
cp -r lang  GroupActivityFinderExtensions
cp -r Ui  GroupActivityFinderExtensions
cp GroupActivityFinderExtensions.txt  GroupActivityFinderExtensions
cp Main.lua  GroupActivityFinderExtensions
cp SettingsMenu.lua  GroupActivityFinderExtensions

zip GroupActivityFinderExtensions-$version.zip -r GroupActivityFinderExtensions
rm -rf GroupActivityFinderExtensions