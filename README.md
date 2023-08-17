# Tools.PortsForwarder
Powershell module to automatically create port redirects.

## Utilisation

Add a new port forward

```Powershell
New-PortForwarding -Name 'Test 4444' -LocalPort 4444 -RemotePort 4444 -RemoteAddress 192.168.1.123
```

Show all port forwarding

```Powershell
Show-PortForwarding
```

## Syntax

```Powershell
New-PortForwarding [-Name] <String> [-LocalPort] <Int32> [[-RemotePort] <Int32>]
    [-RemoteAddress] <String> [[-Protocol] <String>] [-LocalAddress <String>]
    [<CommonParameters>]
```
