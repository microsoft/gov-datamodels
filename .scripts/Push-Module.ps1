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

    # select deployment configuration once at the start
    Write-Host ""
    $deploymentConfig = Select-Deployment

    # connect to the selected tenant once
    Write-Host ""
    Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
    Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

    # Start the loop for module selection and deployment
    do {
        # ask for which module to push
        Write-Host ""
        $excludeFolders = "__pycache__", ".scripts"
        $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
        $module = Select-ItemFromList $folderNames

        if ($module -ne "") {
            # determine target environment based on module
            $targetEnv = if ($module -eq "core") {
                $deploymentConfig.Environments."GOV CDM CORE"
            } elseif ($module -eq "process-and-tasking") {
                $deploymentConfig.Environments."GOV CDM UTILITY"
            } else {
                $deploymentConfig.Environments."GOV CDM MODULE"
            }

            # connect to the determined environment
            Write-Host ""
            Write-Host "Connecting to environment: $targetEnv"
            Connect-DataverseEnvironment -envName $targetEnv

            # deploy the solution
            Deploy-Solution "$baseFolder\$module" -AutoConfirm
        }
    } while ($module -ne "") # Continue looping until the input is an empty string

    Write-Host "Operation complete."
}
