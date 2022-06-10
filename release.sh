while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG:?Need value};;
    esac
done

# version=$(awk '/^## AddOnVersion/{print $NF}' GroupActivityFinderExtensions.txt)

$output = build/GroupActivityFinderExtensions

mkdir $output

cp -r src $output
cp Main.lua  $output
cp Vars.lua  $output
cp SettingsMenu.lua  $output

zip $output-$version.zip -r $output
rm -rf $output
