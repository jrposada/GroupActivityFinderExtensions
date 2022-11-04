param ([Parameter(Mandatory = $true)][String]$version)

$output = './build/GroupActivityFinderExtensions'

if (Test-Path $output) {
    Remove-Item $output -Recurse
} 

New-Item $output -ItemType Directory

$files = @("./src", "./GroupActivityFinderExtensions.txt", "./main.lua", "./vars.lua", "./settings-menu.lua")
$files | Copy-Item  -Destination $output -Recurse

Compress-Archive $output -DestinationPath "./build/GroupActivityFinderExtensions-$version.zip"

Remove-Item $output -Recurse