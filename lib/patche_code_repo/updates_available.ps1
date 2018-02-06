Import-Module C:\Temp\patche_code_repo\PSWindowsUpdate\Get-WUInstall.ps1
#Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d

function updates-available{
if(Test-Path C:\Temp\patche_code_repo\output_files){
    Write-Output ""
}
else{
    New-Item -ItemType Directory "C:\Temp\patche_code_repo\output_files"
}

    #listing updates available
    $Updates_available = Get-WUInstall -MicrosoftUpdate -ListOnly
    if($?){
        $Updates_available |select KB,Title,Description,RebootRequired | Export-Csv "C:\Temp\patche_code_repo\output_files\available.csv" -NoTypeInformation
    }
    else{
        Write-Error "`nError:Failed to Contact Microsoft Updates repository."
    }
}
updates-available
