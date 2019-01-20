Function Disconnect-AzDo{
    <#
    .SYNOPSIS
        Disconnects the active Azure DevOps Connection.
    .DESCRIPTION
        Disconnects the active Azure DevOps Connection.
    .EXAMPLE
        Disconnect-AzDo
    #>
    [CmdletBinding()]
    param()

    try{
        Remove-Variable -Name az* -Force -ErrorAction Stop
    }catch{
        throw "$($($_.Exception).Message)"
    }
}