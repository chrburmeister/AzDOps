$script:PSModuleRoot = $PSScriptRoot

foreach ($function in (Get-ChildItem -Path "$script:PSModuleRoot/Functions/*.ps1" -Recurse)) {
    . $function.FullName
    Export-ModuleMember -Function $function.BaseName
}
