Function Disconnect-AzDo {
    <#
    .SYNOPSIS
        Disconnects the active Azure DevOps Connection.
    .DESCRIPTION
        Disconnects the active Azure DevOps Connection.
    .EXAMPLE
        Disconnect-AzDo
    .NOTES
        Updated by Steven Judd on 2020/02/21:
            Specified the exact variables to remove (more friendly user experience)
            Used Write-Error instead of throw to show which variable removal failed
    #>
    [CmdletBinding()]
    param()

    try {
        Remove-Variable -Name AzDOpsModuleAuthHeader -Scope Global -Force -ErrorAction Stop
    }
    catch {
        Write-Error "$_"
    }
    try {
        Remove-Variable -Name AzDOpsModuleConnectionStatus -Scope Global -Force -ErrorAction Stop
    }
    catch {
        Write-Error "$_"
    }
    try {
        Remove-Variable -Name AzDOpsModuleBaseUrl -Scope Global -Force -ErrorAction Stop
    }
    catch {
        Write-Error "$_"
    }
}
