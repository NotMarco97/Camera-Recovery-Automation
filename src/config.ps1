function GetConfiguration{
    $check = Test-Path /home/marco/Desktop/powershell/kiosk-watchdog/config/settings.json
    
    if($check){
        $content = Get-content /home/marco/Desktop/powershell/kiosk-watchdog/config/settings.json
        $configuration = $content | ConvertFrom-json
    }else {
        throw "Configuration file not found."
    }

    $isUsernameInvalid = [string]::IsNullOrEmpty($configuration.username)
    $isPasswordInvalid = [string]::IsNullOrEmpty($configuration.password)
    
    if($isUsernameInvalid -or $isPasswordInvalid){

        throw "Username or Password is not valid."
    }

    return $configuration
}