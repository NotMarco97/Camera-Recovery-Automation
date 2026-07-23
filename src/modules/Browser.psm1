function StartBrowser{
    param(
        $configuration
    )

    $browserScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../scripts/launchBrowser.js"

    try{
        $json = $configuration | ConvertTo-Json -Compress
$jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
$encodedConfiguration = [Convert]::ToBase64String($jsonBytes)

& node $browserScriptPath $encodedConfiguration
    }
    catch{
        throw "Failed to start the browser."
    }
}

Export-ModuleMember -Function StartBrowser
