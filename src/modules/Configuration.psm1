function GetConfiguration {
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "../../config/settings.json"
    $configExists = Test-Path -Path $configPath

    if (-not $configExists) {
        throw "Configuration file not found."
    }
    $configuration = LoadConfiguration $configPath
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

function LoadConfiguration{
    param(
        $configPath
    )

    $content = Get-Content $configPath

    try {
        $configuration = $content | ConvertFrom-Json
    }
    catch {
        throw "Failed to parse configuration file as JSON."
    }

    return $configuration
}

Export-ModuleMember -Function GetConfiguration