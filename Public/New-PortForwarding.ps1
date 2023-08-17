<#
.SYNOPSIS
This function will create a new port forwarding rule and open the port on the firewall.

.DESCRIPTION
This function will create a new port forwarding rule and open the port on the firewall.

.PARAMETER Name
Name of the port forwarding rule

.PARAMETER LocalPort
Port on listening side

.PARAMETER RemotePort
Port on destination side

.PARAMETER RemoteAddress
Address of destination side

.PARAMETER Protocol
Protocol to use. Default is TCP

.PARAMETER LocalAddress
Local address. Default is 0.0.0.0

.EXAMPLE
New-PortForwarding -Name 'RDP' -Protocol 'TCP' -LocalPort 3389 -RemotePort 3389 -RemoteAddress '127.0.0.1'

#>
function New-PortForwarding {
    [CmdletBinding()]
    param (
        # Name of the port forwarding rule
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Name,

        # Port on listening side
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateRange(1, 65535)]
        [int]
        $LocalPort,

        # Port on destination side
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateRange(1, 65535)]
        [int]
        $RemotePort = $LocalPort,

        # Address of destination side
        [Parameter(Mandatory = $true, Position = 3)]
        [string]
        $RemoteAddress,

        # Protocol to use
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateSet('TCP', 'UDP')]
        [string]
        $Protocol = 'TCP',

        # Local address
        [Parameter(Mandatory = $false)]
        [string]
        $LocalAddress = '0.0.0.0'
    )

    Write-Host "Creating port forwarding rule $Name"
    
    # Create the port forwarding rule
    netsh.exe interface portproxy add v4tov4 listenport=$LocalPort listenaddress=$LocalAddress connectport=$RemotePort connectaddress=$RemoteAddress

    # Open the port on the firewall
    $description = "Port forwarding rule for $Name. Made with the module Tools.PortsForwarder."
    New-NetFirewallRule -DisplayName "Tools.PortsForwarder - $Name" -Direction Outbound -LocalPort $LocalPort -Action Allow -Protocol $Protocol -Description $description | Out-Null
    New-NetFirewallRule -DisplayName "Tools.PortsForwarder - $Name" -Direction Inbound -LocalPort $LocalPort -Action Allow -Protocol $Protocol -Description $description | Out-Null

    # Test the port forwarding rule
    if (Test-PortForwardingRule -LocalPort $LocalPort -RemotePort $RemotePort -RemoteAddress $RemoteAddress) {
        Write-Host "$LocalAddress`:$LocalPort --> $RemoteAddress`:$RemotePort" -ForegroundColor Cyan
        Write-Host "Port forwarding rule $Name created successfully" -ForegroundColor Green
    }
    else {
        Write-Host "Port forwarding rule $Name creation failed" -ForegroundColor Red
    }
}