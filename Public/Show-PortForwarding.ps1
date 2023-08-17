<#
.SYNOPSIS
Displays the current port forwarding rules

.DESCRIPTION
Displays the current port forwarding rules

.EXAMPLE
Show-PortForwarding

#>
function Show-PortForwarding {
    [CmdletBinding()]
    param (
    )
    
    netsh interface portproxy show v4tov4
}