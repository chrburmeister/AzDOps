Function Get-AzDoGitRepository {
    <#
    .SYNOPSIS
        Retrieves all Git repositories from the specified Azure DevOps project.
    .DESCRIPTION
        Retrieves all Git repositories from the specified Azure DevOps project.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoGitRepository -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.1"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$AzDOpsModuleBaseUrl/$($ProjectId)/_apis/git/repositories?api-version=$APIVersion"

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