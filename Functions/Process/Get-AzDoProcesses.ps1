Function Get-AzDoProcesses{
    <#
    .SYNOPSIS
        Retrieves all Azure DevOps processes.
    .DESCRIPTION
        Retrieves all Azure DevOps processes.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoProcesses
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)][String]$APIVersion = "1.0"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$AzDOpsModuleBaseUrl/_apis/process/processes?api-version=$APIVersion"

    $restParam = @{
        "URI" = $uri
        "Headers" = $AzDOpsModuleAuthHeader
        "Method" = "GET"
        "ErrorAction" = "Stop"
    }

    try{
        $Processes = Invoke-RestMethod @restParam
        Return $Processes.Value
    }catch{
        throw "$($($_.Exception).Message)"
    }
}