Import-Module .\PSWinDocumentation.Azure.psd1 -Force

$Azure = Get-WinAzure -Verbose -Formatted
$Azure.VirtualMachines | Format-Table -a *