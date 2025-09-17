# Common Scripts Ready 

# local managed -> online environment as UNMANAGED to DEV environment
# use this script to deploy the latest umanaged solution to dev environment
# will not deploy the umanaged solution to the development environment, use Push-Module for that

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

Write-Host "Warning - This operation will overwrite the unmanaged solution in your environment."
if ($true -eq (Confirm-Next "Proceed (y/n)?")) {

    # ask which type of ip
    $ipType = "modules"
    $baseFolder = "$projectRoot\$ipType"

    # ask for which module to push
    Write-Host ""
    $excludeFolders = "__pycache__", ".scripts"
    $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
    $module = Select-ItemFromList $folderNames

    Connect-DataverseTenant
    Connect-DataverseEnvironment

    if ($module -eq "core") {
        Deploy-Solution "$baseFolder\$module" -AutoConfirm
    }
    elseif ($module -eq "process-and-tasking") {
        Deploy-Solution "$baseFolder\$module" -AutoConfirm
    }
    else {
        Deploy-Solution "$baseFolder\$module" -AutoConfirm
    }
}
