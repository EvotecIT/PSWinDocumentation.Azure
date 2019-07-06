function Get-WinAzureNetwork {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $NetworksHashes
    )
    if (-not $NetworksHashes) {
        $NetworksHashes = @{ }
    }
    $Networks = Get-AzureRmNetworkInterface
    foreach ($_ in $Networks) {
        [PSCustomObject]@{
            ResourceGroupName           = $_.ResourceGroupName
            Name                        = $_.Name
            Location                    = $_.Location
            MacAddress                  = $_.MacAddress
            Primary                     = $_.Primary
            EnableAcceleratedNetworking = $_.EnableAcceleratedNetworking
            EnableIPForwarding          = $_.EnableIPForwarding
            ProvisioningState           = $_.ProvisioningState

            IpName                      = $_.IpConfigurations.Name
            IpType                      = $_.IpConfigurations.PrivateIpAddressVersion
            IpPrimary                   = $_.IpConfigurations.Primary
            IpAddress                   = $_.IpConfigurations.PrivateIpAddress
            IpAllocationMethod          = $_.IpConfigurations.PrivateIpAllocationMethod
            #IpAddressPublic             = $_.IpConfigurations.PublicIpAddress
            IpProvisioningState         = $_.IpConfigurations.ProvisioningState
            Etag                        = $_.IpConfigurations.Etag
            Id                          = $_.IpConfigurations.Id
        }
    }
    # We're creating hashtable to provide speedy gonzales speed
    foreach ($_ in $Networks) {
        $NetworksHashes[$_.Id] = $_
    }

}