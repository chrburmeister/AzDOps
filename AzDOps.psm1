$script:PSModuleRoot = $PSScriptRoot

foreach ($function in (Get-ChildItem -Path "$script:PSModuleRoot/Functions/*.ps1" -Recurse)) {
    . $function.FullName
    Export-ModuleMember -Function $function.BaseName
}

New-Variable -Name "azDoAuthHeader" -Value "" -Scope Global -Visibility Private
New-Variable -Name "azDoOrganization" -Value "" -Scope Global -Visibility Private
New-Variable -Name "azDoConnectionStatus" -Value "" -Scope Global -Visibility Private
New-Variable -Name "azDoBaseUrl" -Value "" -Scope Global -Visibility Private