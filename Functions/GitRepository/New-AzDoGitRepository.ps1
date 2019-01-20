Function New-AzDoGitRepository {
    <#
    .SYNOPSIS
        Creates a new Git repository for the specified Azure DevOps project.
    .DESCRIPTION
        Creates a new Git repository for the specified Azure DevOps project.
    .PARAMETER Name
        Specifies the name of the Git repository to be created.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        New-AzDoGitRepository -Name "nft" -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.1"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/$($ProjectId)/_apis/git/repositories/?api-version=$APIVersion"

    $body = @{
        "name" = $Name
        "project" = @{
            "id" = $ProjectId
        }
    }

    $restParam = @{
        "URI" = $uri
        "Headers" = $azDoAuthHeader
        "Method" = "POST"
        "ContentType" = "application/json"
        "Body" = (ConvertTo-Json -InputObject $body)
        "ErrorAction" = "Stop"
    }

    try{
        $response = Invoke-RestMethod @restParam
        Return $response
    }catch{
        throw "$($($_.Exception).Message)"
    }
}