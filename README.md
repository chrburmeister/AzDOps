# Azure DevOps PowerShell Module
PowerShell Module for interacting with Azure DevOps using the Rest-API in the Background.
Currently, you have to use an personal access token to connect. In the future, you'll also will be able to use the interactive authentication window.

## Create personal access token
Read the following [Microsoft Docs page](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts) to create your token.

## Install
```powershell
Install-Module -Name AzDOps
```

## Connect
```powershell
$token = "token"
$organizationName = "orgName"

Connect-AzDo -PersonalAccessTokens $token -OrganizationName $organizationName
```

## Get all cmdlets
```powershell
Get-Command -Module AzDOps
```

## Contribute
This Module is by far not complete - there are still a lot of functions missing - feel free to contribute (I even encourage you to do so :) ). If you do, please have a look at some of the existing function to get an understanding of the sctructure.

You can also just hit me up on Twitter [@chrburmeister](https://twitter.com/chrburmeister)
