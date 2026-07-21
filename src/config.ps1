function GetConfiguration {
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "../config/settings.json"
    $configExists = Test-Path -Path $configPath

    if (-not $configExists) {
        throw "Configuration file not found."
    }

    $content = Get-Content $configPath
    $configuration = $content | ConvertFrom-Json

    ValidateConfiguration $configuration

    return $configuration
}

function ValidateConfiguration {
    param(
        $configuration
    )

    $isUsernameInvalid = [string]::IsNullOrEmpty($configuration.username)
    $isPasswordInvalid = [string]::IsNullOrEmpty($configuration.password)

    if ($isUsernameInvalid -or $isPasswordInvalid) {
        throw "Username or password is not valid."
    }
}