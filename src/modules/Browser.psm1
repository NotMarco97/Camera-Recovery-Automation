function StartBrowser{
    param(
        $configuration
    )

    $browserScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../scripts/launchBrowser.js"

    try{
        $json = $configuration | ConvertTo-Json -Compress
        & node $browserScriptPath $json
    }
    catch{
        throw "Failed to start the browser."
    }
}

function CloseBrowser{

}

Export-ModuleMember -Function StartBrowser
Export-ModuleMember -Function CloseBrowser
