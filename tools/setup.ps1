param(
    [string]$Target = ""
)

$env:IDF_PATH = "G:\esp\esp-idf"
$env:IDF_TOOLS_PATH = "G:\esp\.espressif"
. G:\esp\esp-idf\export.ps1
Set-Location (Join-Path $PSScriptRoot "..\fw")

if ($Target) {
    idf.py set-target $Target
    Write-Host "Target set to $Target. Run .\tools\build.ps1 to build."
} else {
    Write-Host "ESP-IDF environment ready. Set target with: idf.py set-target <esp32|esp32c6|...>"
}
