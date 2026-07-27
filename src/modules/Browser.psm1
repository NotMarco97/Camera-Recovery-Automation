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
        $json | & $nodeExecutable $browserScriptPath
    }
    catch{
        throw "Failed to start the browser."
    }
}

Export-ModuleMember -Function StartBrowser
