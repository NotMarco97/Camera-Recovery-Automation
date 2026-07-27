$ErrorActionPreference = "Stop"

$payloadPath = Join-Path -Path $PSScriptRoot -ChildPath "payload"

$cameraRecoveryPath = Join-Path -Path $env:ProgramData -ChildPath "Camera-Recovery-Automation"

$logsDirectory = Join-Path -Path $cameraRecoveryPath -ChildPath "scripts/logs"

$checkPayloadPath = Test-Path -Path $payloadPath

if (-not $checkPayloadPath) {
    throw "The payload path does not exist."
}

$payloadMainPath = Join-Path -Path $payloadPath -ChildPath "src\main.ps1"

$checkPayloadMainPath = Test-Path -Path $payloadMainPath

if (-not $checkPayloadMainPath) {
    throw "The payload entry point does not exist."
}

$kioskUsername = "KioskUser0"
$kioskAccount = $env:COMPUTERNAME + "\" + $kioskUsername

Get-LocalUser -Name $kioskUsername | Out-Null

New-Item -ItemType Directory -Path $cameraRecoveryPath -Force | Out-Null

Copy-Item -Path $payloadPath\* -Destination $cameraRecoveryPath -Recurse -Force

New-Item -ItemType Directory -Path $logsDirectory -Force | Out-Null


$logsPermission = "${kioskAccount}:(OI)(CI)M"

& icacls.exe $logsDirectory /grant $logsPermission

if ($LASTEXITCODE -ne 0) {
    throw "Failed to set permissions on the logs directory."
}

$cameraMainPath = Join-Path -Path $cameraRecoveryPath -ChildPath "src/main.ps1"
$powershellPath = Join-Path -Path $env:SystemRoot -ChildPath "System32\WindowsPowerShell\v1.0\powershell.exe"

$taskArguments = "-NoProfile -ExecutionPolicy Bypass -File `"$cameraMainPath`""

$taskAction = New-ScheduledTaskAction -Execute $powershellPath -Argument $taskArguments

$taskTrigger = New-ScheduledTaskTrigger -AtLogon -User $kioskAccount

$taskPrincipal = New-ScheduledTaskPrincipal -UserId $kioskAccount -LogonType Interactive -RunLevel Limited

$taskSettings = New-ScheduledTaskSettingsSet -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 3 -MultipleInstances IgnoreNew -ExecutionTimeLimit ([TimeSpan]::zero)

$taskName = "Camera Kiosk Recovery"

Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -Settings $taskSettings -Force | Out-Null

exit 0