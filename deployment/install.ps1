$ErrorActionPreference = "Stop"

$payloadPath = Join-Path `-Path $PSScriptRoot -ChildPath "payload"

$cameraRecoveryPath = Join-Path -Path $env:ProgramData -ChildPath "Camera-Recovery-Automation"

$checkPayloadPath = Test-Path -Path $payloadPath

if (-not $checkPayloadPath) {
    throw "The payload path does not exist."
}

New-Item -ItemType Directory -Path $cameraRecoveryPath -Force | Out-Null

Copy-Item -Path $payloadPath\* -Destination $cameraRecoveryPath -Recurse -Force