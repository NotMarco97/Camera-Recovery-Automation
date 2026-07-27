$ErrorActionPreference = "Stop"

$payloadPath = Join-Path -Path $PSScriptRoot -ChildPath "payload"

$cameraRecoveryPath = Join-Path -Path $env:ProgramData -ChildPath "Camera-Recovery-Automation"

$logsDirectory = Join-Path -Path $cameraRecoveryPath -ChildPath "scripts/logs"


$checkPayloadPath = Test-Path -Path $payloadPath

if (-not $checkPayloadPath) {
    throw "The payload path does not exist."
}

$kioskUsername = "KioskUser0"
$kioskAccount = $env:COMPUTERNAME + "\" + $kioskUsername

Get-LocalUser -Name $kioskUsername | Out-Null

New-Item -ItemType Directory -Path $cameraRecoveryPath -Force | Out-Null

Copy-Item -Path $payloadPath\* -Destination $cameraRecoveryPath -Recurse -Force

New-Item -ItemType Directory -Path $logsDirectory -Force | Out-Null


$logsPermission = "${kioskAccount}:(OI)(CI)M"

Get-Process $logsPermission
