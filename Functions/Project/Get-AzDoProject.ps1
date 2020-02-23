Function Get-AzDoProject{
    <#
    .SYNOPSIS
        Retieves all available Azure DevOps projects.
    .DESCRIPTION
        Retieves all available Azure DevOps projects from the connected organization.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoProject
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.3"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$AzDOpsModuleBaseUrl/_apis/projects?api-version=$($APIVersion)"

    $restParam = @{
        "URI" = $uri
        "Headers" = $AzDOpsModuleAuthHeader
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