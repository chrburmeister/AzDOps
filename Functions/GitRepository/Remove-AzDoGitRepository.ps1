Function Remove-AzDoGitRepository{
    <#
    .SYNOPSIS
        Removes a Git repository from the specified Azure DevOps project.
    .DESCRIPTION
        Removes a Git repository from the specified Azure DevOps project.
    .PARAMETER Name
        Specifies the name of the Git repository to be deleted.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Remove-AzDoGitRepository -Name "nft" -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.1"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $repoGuid = Get-AzDoGitRepository -ProjectId $ProjectId | Where-Object {$_.Name -eq $Name} | Select-Object -ExpandProperty id

    if(-not($repoGuid)){
        throw "could not find a team with name $name"
    }

    $uri = "$AzDOpsModuleBaseUrl/$ProjectId/_apis/git/repositories/$($repoGuid)?api-version=$APIVersion"

    $restParam = @{
        "URI" = $uri
        "Headers" = $AzDOpsModuleAuthHeader
        "Method" = "DELETE"
        "ErrorAction" = "Stop"
    }

    try{
        $response = Invoke-RestMethod @restParam
        Return $response
    }catch{
        throw "$($($_.Exception).Message)"
    }
}