Function New-AzDoTeam{
    <#
    .SYNOPSIS
        Creates a new team within an Azure DevOps project.
    .DESCRIPTION
        Creates a new team within an Azure DevOps project.
    .PARAMETER Name
        Specifies the Name of the Team to be created.
    .PARAMETER ProjectId
        Specifies the Azure DevOps project (as a GUID).
    .PARAMETER Description
        Specifies the team description.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        New-AzDoTeam -Name "QA Team" -ProjectId "0bad119f-011c-46f5-9861-557462ebf8fa" -Descrption "Quality Team"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$ProjectId,
        [Parameter(Mandatory = $false)][String]$Description,
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.2"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/_apis/projects/$projectId/teams?api-version=$APIVersion"

    $body = @{
        "name" = $name
        "description" = $description
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