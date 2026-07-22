$configurationModulePath = Join-Path $PSScriptRoot "modules/Configuration.psm1"
$browserModulePath       = Join-Path $PSScriptRoot "modules/Browser.psm1"

Import-Module $configurationModulePath -Force
Import-Module $browserModulePath -Force

$config = GetConfiguration
$config | Format-List *
Write-Host "URL = '$($config.Url)'"
startBrowser -url $config.Url

