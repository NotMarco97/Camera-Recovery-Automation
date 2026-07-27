$ErrorActionPreference = "Stop"

$taskName = "Camera Kiosk Recovery"
$scheduledTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue 

if ($null -ne $scheduledTask) {
    Stop-ScheduledTask -TaskName $taskName
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$cameraRecoveryPath = Join-Path -Path $env:ProgramData -ChildPath "Camera-Recovery-Automation"

$removalTargets = @(
    "config"
    "runtime"
    "node_modules"
    "src"
    "scripts\launchBrowser.js"
    "package.json"
    "package-lock.json"
)

foreach ($target in $removalTargets) {
    # process this target
    $targetPath = Join-Path -Path $cameraRecoveryPath -ChildPath $target
    if (Test-Path -Path $targetPath) {
        Remove-Item -Path $targetPath -Recurse -Force
    }
}

exit 0