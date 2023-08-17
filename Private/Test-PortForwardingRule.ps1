<#
.SYNOPSIS
Test if a port forwarding rule exists.

.DESCRIPTION
Test if a port forwarding rule exists.

.PARAMETER LocalPort
Local port on which the rule is listening.

.PARAMETER RemotePort
Remote port on which the rule is forwarding.

.PARAMETER RemoteAddress
Remote address on which the rule is forwarding.

.PARAMETER LocalAddress
Local address on which the rule is listening. By default, it is 0.0.0.0

.EXAMPLE
Test-PortForwardingRule -LocalPort 3389 -RemotePort 3389 -RemoteAddress '1.2.3.4'

#>
function Test-PortForwardingRule {
    [CmdletBinding()]
    param (
        # Local port
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateRange(1,65535)]
        [int]
        $LocalPort,

        # Remote port
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateRange(1,65535)]
        [int]
        $RemotePort,

        # Remote address
        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $RemoteAddress,

        # Local address
        [Parameter(Mandatory = $false)]
        [string]
        $LocalAddress = '0.0.0.0'
    )
    
    # Recover the port forwarding rule
    $portForwardingList = netsh.exe interface portproxy show v4tov4

    # Test if the rule exists
    $result = $portForwardingList | Select-String -Pattern "$LocalAddress.*$LocalPort.*$RemoteAddress.*$RemotePort"

    # Return the result
    if ($result) {
        return $true
    }
    else {
        return $false
    }
}