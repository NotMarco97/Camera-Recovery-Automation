function GetConfiguration{
    $check = Test-Path 
    $content = Get-content 

    $configuration = $content | ConvertFrom-json

    return $configuration
}