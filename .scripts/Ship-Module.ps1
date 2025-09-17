# Common Scripts Ready 

# local managed -> online environment as managed to a single dedicated demo tenant / environment
# use this script to deploy the latest managed solution to a single dedicated demo tenant / environment

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

# ask which tenant to ship to
Connect-DataverseTenant
Connect-DataverseEnvironment

$ipType = "modules"
$baseFolder = "$projectRoot\$ipType"

# Start the loop
do {
    # ask for which module to ship
    Write-Host ""
    $excludeFolders = "__pycache__", ".scripts"
    $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
    $module = Select-ItemFromList $folderNames

    if ($module -ne "") {
        # deploy the solution
        Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm
    }
} while ($module -ne "") # Continue looping until the input is an empty string

Write-Host "Operation complete."



