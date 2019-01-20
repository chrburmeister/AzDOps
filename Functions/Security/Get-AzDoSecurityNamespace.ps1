Function Get-AzDoSecurityNamespace{
    <#
    .SYNOPSIS
        Retrieves all available Azure DevOps security namespaces.
    .DESCRIPTION
        Retrieves all available Azure DevOps security namespaces.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        Get-AzDoSecurityNamespace
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)][String]$APIVersion = "1.0"
    )

    if(-not($azDoConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$azDoBaseUrl/_apis/securitynamespaces/00000000-0000-0000-0000-000000000000/?api-version=$APIVersion"

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