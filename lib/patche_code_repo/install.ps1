#install patch
Import-Module C:\Temp\patche_code_repo\PSWindowsUpdate\Get-WUInstall.ps1

Write-Output $args[0]
Get-WUInstall -MicrosoftUpdate -KBArticleID $args[0] -Confirm:$false -IgnoreRebootRequired -Verbose
