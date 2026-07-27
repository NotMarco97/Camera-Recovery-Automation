function StartBrowser{
    param(
        $configuration
    )

    $browserScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../scripts/launchBrowser.js"

    try{
        $json = $configuration | ConvertTo-Json -Compress
        $json | & node $browserScriptPath
    }
    catch{
        throw "Failed to start the browser."
    }
}

Export-ModuleMember -Function StartBrowser
