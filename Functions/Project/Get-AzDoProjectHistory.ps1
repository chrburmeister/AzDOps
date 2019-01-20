Function Get-AzDoProjectHistory{
    <#
    .SYNOPSIS
        Retieves the history for all Azure DevOps projects.
    .DESCRIPTION
        Retieves the history for all Azure DevOps projects.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoProjectHistory
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.2"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/_apis/projecthistory?api-version=$($APIVersion)"

    $restParam = @{
        "URI" = $uri
        "Headers" = $azDoAuthHeader
        "Method" = "GET"
        "ErrorAction" = "Stop"
    }

    try{
        $response = Invoke-RestMethod @restParam
        Return $response.Value
    }catch{
        throw "$($($_.Exception).Message)"
    }
}