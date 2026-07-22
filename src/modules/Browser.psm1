function StartBrowser{
    param(
        [string]$url
    )

    $browserScriptPath = Join-Path -Path $PSScriptRoot -ChildPath "../../scripts/launchBrowser.js"

    try{
        & node $browserScriptPath $url
    }
    catch{
        throw "Failed to start the browser."
    }
}

function CloseBrowser{

}

Export-ModuleMember -Function StartBrowser
Export-ModuleMember -Function CloseBrowser
