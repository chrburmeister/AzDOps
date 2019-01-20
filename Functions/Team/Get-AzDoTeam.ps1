Function Get-AzDoTeam{
    <#
    .SYNOPSIS
        Retrieves all teams of an Azure DevOps Project.
    .DESCRIPTION
        Retrieves all teams of an Azure DevOps Project.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoTeam -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.2"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/_apis/projects/$ProjectId/teams?api-version=$APIVersion"

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