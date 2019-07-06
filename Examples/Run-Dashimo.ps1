Dashboard -Name 'Azure Dashboard' -FilePath $PSScriptRoot\Output\Dashboard.html {
    Tab -Name 'Azure Virtual Machines' -IconBrands black-tie {
        Section -Invisible {
            Section -Name 'Azure VM List' {
                Table -DataTable $Azure.VirtualMachines -Filtering {
                    #TableHeader -Title 'Teams Settings' -Color Black -BackGroundColor Gray
                }
            }
        }

    }
} -Show