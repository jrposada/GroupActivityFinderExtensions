
# Read current version from manifest
$manifestPath = "./GroupActivityFinderExtensions.txt";
foreach ($line in [System.IO.File]::ReadLines($manifestPath)) {
    if ($line.StartsWith("## Version:")) {
        $version = $line.Split(" ")[2]
    }
}

$output = './builds/GroupActivityFinderExtensions'

# Clear last build
if (Test-Path $output) {
    Remove-Item $output -Recurse
} 

New-Item $output -ItemType Directory

$files = @(
    "./src",
    "./GroupActivityFinderExtensions.txt",
    "./LICENSE",
    "./main.lua",
    "./settings-menu.lua",
    "./vars.lua"
)
$files | Copy-Item  -Destination $output -Recurse

Compress-Archive $output -DestinationPath "$output-$version.zip"

Remove-Item $output -Recurse