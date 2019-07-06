function Get-WinAzure {
    [CmdletBinding()]
    param(
        [switch] $Formatted,
        [string] $Prefix
    )

    $PSDefaultParameterValues["Get-DataInformation:Verbose"] = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent


    $TimeToGenerate = Start-TimeLog

    if ($null -eq $TypesRequired) {
        Write-Verbose 'Getting Azure information - TypesRequired is null. Getting all.'
        $TypesRequired = Get-Types -Types ([PSWinDocumentation.Azure])
    } # Gets all types

    if ($SkipAvailability) {
        $Commands = Test-AvailabilityCommands -Commands "Connect-$($Prefix)AzureRmAccount",
        if ($Commands -contains $false) {
            Write-Warning "Getting Azure information - One of commands Connect-$($Prefix)AzureRmAccount is not available. Make sure connectivity to Azure exists."
            return
        }
    }

    $Data = @{ }

    $Data.VirtualMachines = Get-DataInformation -Text "Getting Azure information - VirtualMachines" {
        Get-WinAzureVM -Formatted:$Formatted -Prefix $Prefix
    } -TypesRequired $TypesRequired -TypesNeeded @(
        [PSWinDocumentation.Azure]::VirtualMachines
    ) -Verbose:$true

    $EndTime = Stop-TimeLog -Time $TimeToGenerate
    Write-Verbose "Getting Azure information - $Domain - Time to generate: $EndTime"
    return ConvertTo-OrderedDictionary -HashTable $Data #-Verbose
}