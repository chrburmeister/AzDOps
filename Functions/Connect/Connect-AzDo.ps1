Function Connect-AzDo{
    <#
    .SYNOPSIS
        Connect to Azure DevOps.
    .DESCRIPTION
        Establishes a connection to the specified Azure DevOps organization.
    .PARAMETER PersonalAccessTokens
        Personal access token created from the Azure DevOps portal.
    .PARAMETER OrganizationName
        Name of the Azure DevOps organization to which the connection is to be established.
    .NOTES
        Create Accesstoken: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts
    .EXAMPLE
        Connect-AzDo -personalAccessTokens "<generated user token>" -OrganizationName "<organizationname>"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$PersonalAccessTokens,
        [Parameter(Mandatory = $true)][String]$OrganizationName
    )

    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$personalAccessTokens"))
    $authHeader = @{
        "Authorization" = "Basic $encodedPat"
    }

    Set-Variable -Name "azDoAuthHeader" -Value $authHeader -Scope Global -ErrorAction Stop
    Set-Variable -Name "azDoConnectionStatus" -Value $true -Scope Global -ErrorAction Stop
    Set-Variable -Name "azDoBaseUrl" -Value "https://dev.azure.com/$OrganizationName" -Scope Global -ErrorAction Stop

    try{
        $response = Get-AzDoProject -ErrorAction Stop
        Write-Verbose "Connection to Azure DevOps organization $OrganizationName established"
        Write-Verbose "Base URL: $azDoBaseUrl"
    }catch{
        Disconnect-AzDo -ErrorAction SilentlyContinue
        Write-Error "could not connect to Azure DevOps"
    }
}