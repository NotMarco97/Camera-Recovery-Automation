function GetConfiguration{
    $check = Test-Path /home/marco/Desktop/powershell/kiosk-watchdog/config/settings.json
    $content = Get-content /home/marco/Desktop/powershell/kiosk-watchdog/config/settings.json

    $configuration = $content | ConvertFrom-json

    return $configuration
}