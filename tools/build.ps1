$env:IDF_PATH = "G:\esp\esp-idf"
$env:IDF_TOOLS_PATH = "G:\esp\.espressif"
. G:\esp\esp-idf\export.ps1
Set-Location (Join-Path $PSScriptRoot "..\fw")
idf.py build
