Function Get-AzDoProjectProperties{
    <#
    .SYNOPSIS
        Connect to Azure DevOps
    .DESCRIPTION
        Long description
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoProjectProperties -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.1"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/_apis/projects/$ProjectId/properties?api-version=$($APIVersion)"

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