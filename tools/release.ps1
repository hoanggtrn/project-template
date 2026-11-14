param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$env:IDF_PATH = "G:\esp\esp-idf"
$env:IDF_TOOLS_PATH = "G:\esp\.espressif"
. G:\esp\esp-idf\export.ps1
Set-Location (Join-Path $PSScriptRoot "..\fw")

# Read project name from CMakeLists.txt
$cmake = Get-Content "CMakeLists.txt" -Raw
if ($cmake -match 'project\(([^)]+)\)') {
    $projName = $Matches[1]
} else {
    Write-Error "Could not read project name from CMakeLists.txt"
    exit 1
}

$tag = "$projName-fw-v$Version"

Write-Host "Building firmware..."
idf.py build
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Tagging: $tag"
git tag -a $tag -m "Firmware v$Version"
git push origin $tag

$binPath = "build\$projName.bin"
if (-not (Test-Path $binPath)) {
    $binPath = "build\firmware.bin"
}

$title = "$($projName.ToUpper()) Firmware v$Version"
gh release create $tag $binPath "build\bootloader\bootloader.bin" "build\partition_table\partition-table.bin" "build\flash_args" --title $title --notes "Firmware v$Version"

Write-Host "Release created: $title"
