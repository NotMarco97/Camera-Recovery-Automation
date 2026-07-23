function StartBrowser{
    param(
        $configuration
    )

    $browserScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../scripts/launchBrowser.js"
    $bundledNodePath = Join-Path -Path $PSScriptRoot -ChildPath "../../runtime/node.exe"

    if (Test-Path -Path $bundledNodePath) {
        $nodeExecutable = $bundledNodePath
    }

    else {
        $nodeExecutable = "node"
    }

    try{

    $json = $configuration | ConvertTo-Json -Compress
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    $encodedConfiguration = [Convert]::ToBase64String($jsonBytes)
    & $nodeExecutable $browserScriptPath $encodedConfiguration

    }
    catch{
        throw "Failed to start the browser."
    }
}

Export-ModuleMember -Function StartBrowser
