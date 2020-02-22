Function Remove-AzDoTeam{
    <#
    .SYNOPSIS
        Removes an Azure DevOps team from a project.
    .DESCRIPTION
        Removes an Azure DevOps team from a project.
    .PARAMETER Name
        Specifies the name  of the team to remove.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Remove-AzDoTeam -Name "QA Team" -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.2"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $teamId = Get-AzDoTeam -ProjectId $ProjectId | Where-Object {$_.Name -eq $Name} | Select-Object -Property id -ExpandProperty id

    if(-not($teamId)){
        throw "could not find team $name"
    }

    $uri = "$AzDOpsModuleBaseUrl/_apis/projects/$ProjectId/teams/$($teamId)?api-version=$APIVersion"

    $restParam = @{
        "URI" = $uri
        "Headers" = $AzDOpsModuleAuthHeader
        "Method" = "DELETE"
        "ContentType" = "application/json"
        "ErrorAction" = "Stop"
    }

    try{
        $Response = Invoke-RestMethod @restParam
        Return $Response
    }catch{
        throw "$($($_.Exception).Message)"
    }
}