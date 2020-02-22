Function Connect-AzDo {
    <#
    .SYNOPSIS
        Connect to Azure DevOps.
    .DESCRIPTION
        Establishes a connection to the specified Azure DevOps organization.
    .PARAMETER OrganizationName
        Name of the Azure DevOps organization to which the connection is to be established.
    .PARAMETER PersonalAccessToken
        Enter a Personal Access Token created from the Azure DevOps portal. This value
        must be entered as a secure string value. This value is mandatory and will
        prompt for the value if one is not passed.
    .PARAMETER Credential
        Enter a PSCredential object with the Personal Access Token as the password
        value. The username is not used to make the connection, so enter any value as
        the username. This parameter accepts pipeline input so you can pass a stored
        Credential object into this parameter.
    .NOTES
        Create Accesstoken: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts

        Updated by Steven Judd on 2020/02/21:
            Changed the $PersonalAccessTokens param to be singular and to be a SecureString type
            Put the New-Variable/Set-Variable commands in the Connect function and removed them from the PSM1 file
            Added a parameter set to allow the passing of a credential object for the PAT
            Updated the help block examples

        Feature requests:
            Configure to not use the global scope for storing the AzDOpsModuleAuthHeader value (polluting the Global scope)
    .EXAMPLE
        Connect-AzDo -OrganizationName "<organizationname>"

        This command will prompt for the PAT to connect to the Azure DevOps organization
        specified.
    .EXAMPLE
        Connect-AzDo -OrganizationName "<organizationname>" -PersonalAccessToken (Read-Host -AsSecureString)

        This example shows that you can pass a secure string to the PersonalAccessToken
        parameter.
    .EXAMPLE
        Connect-AzDo -OrganizationName "<organizationname>" -Credential (Get-Credential)

        This example shows that you can pass a credential object to the Credential
        parameter. The PAT is entered as the password value. The usename is not used so
        the value entered is not important.
    .EXAMPLE
        Get-Credential -UserName "PAT" | Connect-AzDo -OrganizationName "<organizationname>"

        This example shows that you can pass a credential object to the Credential
        parameter via the pipeline. The PAT is entered as the password value. The
        usename is not used so the value entered is not important. Passing the username
        via Get-Credential keeps the user from having to enter this value.
    #>
    [CmdletBinding(DefaultParameterSetName = 'PAT')]
    param(
        [Parameter(
            Position = 0,
            Mandatory
        )]
        [String]$OrganizationName,

        [Parameter(
            Position = 1,
            Mandatory,
            ParameterSetName = "PAT"
        )]
        [SecureString]$PersonalAccessToken,

        [Parameter(
            Position = 1,
            Mandatory,
            ParameterSetName = "Credential",
            ValueFromPipeline
        )]
        [PSCredential]$Credential #= (Get-Credential -UserName "PAT")
    )

    if ($PersonalAccessToken) {
        $PasswordPointer = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PersonalAccessToken)
        $PasswordFromObject = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($PasswordPointer)
    }
    else {
        $PasswordFromObject = $Credential.GetNetworkCredential().Password
    }
    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$PasswordFromObject"))
    $authHeader = @{
        "Authorization" = "Basic $encodedPat"
    }

    $VariableHash = @{
        "AzDOpsModuleAuthHeader"       = $authHeader
        "AzDOpsModuleConnectionStatus" = $true
        "AzDOpsModuleBaseUrl"          = "https://dev.azure.com/$OrganizationName"
    }

    foreach ($key in $VariableHash.keys) {
        if (Get-Variable -Name $key -ErrorAction SilentlyContinue) {
            Set-Variable -Name $key -Value $VariableHash[$key] -Scope Global
        }
        else {
            New-Variable -Name $key -Value $VariableHash[$key] -Scope Global -Visibility Private
        }
        Write-Verbose "Variable '$key' set to '$($VariableHash[$key])'"
    }

    try {
        $null = Get-AzDoProject -ErrorAction Stop
        Write-Host "Connection to Azure DevOps organization '$OrganizationName' established"
        Write-Verbose "Base URL: $AzDOpsModuleBaseUrl"
    }
    catch {
        Disconnect-AzDo -ErrorAction SilentlyContinue
        Write-Error "Could not connect to Azure DevOps"
    }
}
