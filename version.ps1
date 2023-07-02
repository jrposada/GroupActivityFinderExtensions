param (
    [Parameter(Mandatory = $true)][ValidateSet("major", "minor", "patch")][String]$mode
)

git add . > $null
git stash > $null

$filePath = "./GroupActivityFinderExtensions.txt";

[System.Collections.ArrayList]$file = [System.Collections.ArrayList]::New();

foreach ($line in [System.IO.File]::ReadLines($filePath)) {
    if ($line.StartsWith("## AddOnVersion:")) {
        $version = $line.Split(" ")[2]
        $major = [int]$version.Substring(0, 2)
        $minor = [int]$version.Substring(2, 2)
        $patch = [int]$version.Substring(4, 2)

        switch ($mode) {
            "major" {
                $major += 1
                $minor = 0
                $patch = 0
            }
            "minor" {
                $minor += 1 
                $patch = 0 
            }
            "patch" { $patch += 1 }
            Default {}
        }

        $major = $major.ToString().PadLeft(2, "0") 
        $minor = $minor.ToString().PadLeft(2, "0") 
        $patch = $patch.ToString().PadLeft(2, "0")

        $line = "## AddOnVersion: $major$minor$patch" 
    }
    
    if ($line.StartsWith("## Version:")) {
        $version = $line.Split(" ")[2].Split(".")
        $major = [int]$version[0]
        $minor = [int]$version[1]
        $patch = [int]$version[2]

        switch ($mode) {
            "major" {
                $major += 1
                $minor = 0
                $patch = 0
            }
            "minor" {
                $minor += 1 
                $patch = 0 
            }
            "patch" { $patch += 1 }
            Default {}
        }

        $line = "## Version: $major.$minor.$patch"
    }

    $file.Add($line) > $null
}

Set-Content -Path $filePath -Encoding UTF8 -Value $file

$version = [String]::Join(".",$version)
git add . > $null
git commit -m "Version $version" > $null

Write-Host "Update to version: $version"

git stash pop > $null