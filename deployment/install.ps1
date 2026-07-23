$ErrorActionPreference = "Stop"

$applicationName = "CameraKioskRecovery"
$sourceDirectory = Join-Path -Path $PSScriptRoot -ChildPath $applicationName
$installDirectory = Join-Path -Path $env:ProgramData -ChildPath $applicationName

if (-not (Test-Path -Path $sourceDirectory)) {
    throw "Application source directory not found."
}

New-Item `
    -ItemType Directory `
    -Path $installDirectory `
    -Force | Out-Null

Copy-Item `
    -Path "$sourceDirectory/*" `
    -Destination $installDirectory `
    -Recurse `
    -Force

$logsDirectory = Join-Path -Path $installDirectory -ChildPath "logs"

New-Item `
    -ItemType Directory `
    -Path $logsDirectory `
    -Force | Out-Null

    $kioskUsername = "KioskUser0"

$kioskUser = Get-LocalUser `
    -Name $kioskUsername `
    -ErrorAction SilentlyContinue

if ($null -eq $kioskUser) {
    throw "Required local kiosk account '$kioskUsername' was not found."
}

$accountName = "$($env:COMPUTERNAME)\$kioskUsername"
$logsPermission = "${accountName}:(OI)(CI)M"

& icacls.exe `
    $logsDirectory `
    /grant $logsPermission `
    | Out-Null

if ($LASTEXITCODE -ne 0) {
    throw "Failed to grant kiosk account permission to the logs directory."
}