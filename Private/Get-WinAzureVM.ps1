function Get-WinAzureVM {
    [CmdletBinding()]
    param(
        [string] $Prefix,
        [switch] $Formatted,
        [string] $Splitter = ', '
    )

    #$VirtualMachines = Get-AzureRmVM
    $VirtualMachines = & "Get-$($Prefix)AzureRmVM"
    foreach ($_ in $VirtualMachines) {

        $Storage = @(
            $OSDisk = [PSCustomObject] @{
                Name                    = $_.StorageProfile.OsDisk.Name
                Type                    = 'System'
                EncryptionSetttings     = $_.StorageProfile.OsDisk.EncryptionSetttings
                VHD                     = $_.StorageProfile.OsDisk.VHD

                Image                   = $_.StorageProfile.OsDisk.Image
                Caching                 = $_.StorageProfile.OsDisk.Caching
                WriteAcceleratorEnabled = $_.StorageProfile.OsDisk.WriteAcceleratorEnabled
                DiskSizeGB              = $_.StorageProfile.OsDisk.DiskSizeGB
                StorageAccountType      = $_.StorageProfile.OSDisk.Manageddisk.StorageAccountType

                Id                      = $_.StorageProfile.OSDisk.Manageddisk.Id
                CreateOption            = ''
                DiffDiskSettings        = $_.StorageProfile.OsDisk.DiffDiskSettings
                Lun                     = ''
            }
            $OSDisk

            foreach ($Disk in $_.StorageProfile.DataDisks) {
                $DataDisk = [PSCustomObject] @{
                    Name                    = $Disk.Name
                    Type                    = 'Data'
                    EncryptionSetttings     = ''
                    VHD                     = $Disk.Vhd

                    Image                   = $Disk.Image
                    Caching                 = $Disk.Caching
                    WriteAcceleratorEnabled = $Disk.WriteAcceleratorEnabled
                    DiskSizeGB              = $Disk.DiskSizeGB
                    StorageAccountType      = $Disk.ManagedDisk.StorageAccountType

                    Id                      = $Disk.ManagedDisk.Id
                    CreateOption            = $Disk.CreateOption
                    DiffDiskSettings        = ''
                    Lun                     = $Disk.Lun
                }
                $DataDisk
            }
        )

        if ($Formatted) {

            [PSCustomObject]@{
                'ComputerName'                  = $_.OSProfile.ComputerName
                'System'                        = (Format-AddSpaceToSentence -Text "$($_.StorageProfile.ImageReference.Offer)".Replace('-', '') ) + " ($($_.StorageProfile.ImageReference.Sku))"


                #Name                          = $_.Name - Identical to ComputerName
                #Type                          = $_.Type - Microsoft.Compute/virtualMachines
                'Location'                      = $_.Name
                'Type'                          = $_.HardwareProfile.VmSize
                'OsType'                        = $_.StorageProfile.OsDisk.OsType
                'NIC'                           = $_.NIC

                'ResourceGroupName'             = $_.ResourceGroupName
                'StatusCode'                    = $_.StatusCode
                'ProvisioningState'             = $_.ProvisioningState
                'AdminUsername'                 = $_.OSProfile.AdminUsername

                'EnableAutomaticUpdates'        = $_.OSprofile.WindowsConfiguration.EnableAutomaticUpdates
                'ProvisionVMAgent'              = $_.OSprofile.WindowsConfiguration.ProvisionVMAgent
                'TimeZone'                      = $_.OSprofile.WindowsConfiguration.TimeZone
                'AdditionalUnattendContent'     = $_.OSprofile.WindowsConfiguration.AdditionalUnattendContent
                'WinRM'                         = $_.OSprofile.WindowsConfiguration.WinRM

                'DisablePasswordAuthentication' = $_.OSprofile.LinuxConfiguration.DisablePasswordAuthentication
                'ProvisionVMAgentLinux'         = $_.OSprofile.LinuxConfiguration.ProvisionVMAgent
                'Ssh'                           = $_.OSprofile.LinuxConfiguration.ProvisionVMAgent

                'Tags'                          = $_.Tags.Values -join $Splitter

                'SystemPublisher'               = $_.StorageProfile.ImageReference.Publisher
                'SystemOffer'                   = $_.StorageProfile.ImageReference.Offer
                'SystemSku'                     = $_.StorageProfile.ImageReference.Sku
                'SystemVersion'                 = $_.StorageProfile.ImageReference.Version
                'SystemID'                      = $_.StorageProfile.ImageReference.ID

                'Storage'                       = $Storage

                'BootDiagnosticsEnabled'        = $_.DiagnosticsProfile.BootDiagnostics.Enabled
                'BootDiagnosticsStorageUri'     = $_.DiagnosticsProfile.BootDiagnostics.StorageUri

                'NetworkInterfacePrimary'       = $_.Networkprofile.NetworkInterfaces.Primary
                'NetworkInterfaceID'            = $_.Networkprofile.NetworkInterfaces.Id

                'Id'                            = $_.Id
                'VmId'                          = $_.VmId
                'Plan'                          = $_.Plan
                'DisplayHint'                   = $_.DisplayHint
                'LicenseType'                   = $_.LicenseType

            }
        } else {
            [PSCustomObject]@{

                ComputerName                  = $_.OSProfile.ComputerName
                'System'                      = (Format-AddSpaceToSentence -Text "$($_.StorageProfile.ImageReference.Offer)".Replace('-', '') ) + " ($($_.StorageProfile.ImageReference.Sku))"

                #Name                          = $_.Name - Identical to ComputerName
                #Type                          = $_.Type - Microsoft.Compute/virtualMachines
                Location                      = $_.Name
                Type                          = $_.HardwareProfile.VmSize
                OsType                        = $_.StorageProfile.OsDisk.OsType
                NIC                           = $_.NIC
                'ResourceGroupName'           = $_.ResourceGroupName
                'StatusCode'                  = $_.StatusCode
                'ProvisioningState'           = $_.ProvisioningState
                AdminUsername                 = $_.OSProfile.AdminUsername

                EnableAutomaticUpdates        = $_.OSprofile.WindowsConfiguration.EnableAutomaticUpdates
                ProvisionVMAgent              = $_.OSprofile.WindowsConfiguration.ProvisionVMAgent
                TimeZone                      = $_.OSprofile.WindowsConfiguration.TimeZone
                AdditionalUnattendContent     = $_.OSprofile.WindowsConfiguration.AdditionalUnattendContent
                WinRM                         = $_.OSprofile.WindowsConfiguration.WinRM

                DisablePasswordAuthentication = $_.OSprofile.LinuxConfiguration.DisablePasswordAuthentication
                ProvisionVMAgentLinux         = $_.OSprofile.LinuxConfiguration.ProvisionVMAgent
                Ssh                           = $_.OSprofile.LinuxConfiguration.ProvisionVMAgent

                Tags                          = $_.Tags.Values #-join ','

                SystemPublisher               = $_.StorageProfile.ImageReference.Publisher
                SystemOffer                   = $_.StorageProfile.ImageReference.Offer
                SystemSku                     = $_.StorageProfile.ImageReference.Sku
                SystemVersion                 = $_.StorageProfile.ImageReference.Version
                SystemID                      = $_.StorageProfile.ImageReference.ID

                Storage                       = $Storage

                BootDiagnosticsEnabled        = $_.DiagnosticsProfile.BootDiagnostics.Enabled
                BootDiagnosticsStorageUri     = $_.DiagnosticsProfile.BootDiagnostics.StorageUri

                NetworkInterfacePrimary       = $_.Networkprofile.NetworkInterfaces.Primary
                NetworkInterfaceID            = $_.Networkprofile.NetworkInterfaces.Id

                Id                            = $_.Id
                VmId                          = $_.VmId
                Plan                          = $_.Plan
                DisplayHint                   = $_.DisplayHint
                LicenseType                   = $_.LicenseType

            }
        }
    }
}