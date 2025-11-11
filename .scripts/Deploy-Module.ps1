# Common Scripts Ready 

# local managed -> online environment as managed to downstream environments
# use this script to deploy the latest managed solution to downstream environments
# will not deploy the umanaged solution to the development environment, use Push-Module for that

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

# select deployment configuration once at the start
Write-Host ""
$deploymentConfig = Select-Deployment

# connect to the selected tenant once
Write-Host ""
Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

# Start the loop for module selection and deployment
do {
    # Ask user to select module type (modules or cross-module) for each deployment
    Write-Host ""
    $ipType = Select-ModuleType $projectRoot
    $baseFolder = "$projectRoot\$ipType"

    # ask for which module to deploy
    Write-Host ""
    $excludeFolders = "__pycache__", ".scripts"
    $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
    $module = Select-ItemFromList $folderNames

    if ($module -ne "") {
        Write-Host ""
        Write-Host "Deploying module: $module" -ForegroundColor Cyan

        if ($module -eq "core") {
            # Core module is special - deploys to GOV CDM UTILITY, GOV CDM MODULE, then downstream environments
            pac org select --environment $deploymentConfig.Environments."GOV CDM UTILITY"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!

            pac org select --environment $deploymentConfig.Environments."GOV CDM MODULE"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment $deploymentConfig.Environments."GOV UTILITY APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment $deploymentConfig.Environments."GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
        }
        elseif ($ipType -eq "cross-module") {
            # Cross modules deploy to GOV CDM MODULE, then downstream environments
            pac org select --environment $deploymentConfig.Environments."GOV CDM MODULE"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!

            pac org select --environment $deploymentConfig.Environments."GOV UTILITY APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment $deploymentConfig.Environments."GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
        }
        
        elseif ($module -eq "process-and-tasking") {
            # Cross modules deploy to GOV CDM MODULE, then downstream environments
            pac org select --environment $deploymentConfig.Environments."GOV CDM MODULE"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!

            # Process-and-tasking deploys to downstream environments only (not GOV CDM MODULE which is source)
            pac org select --environment $deploymentConfig.Environments."GOV UTILITY APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment $deploymentConfig.Environments."GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
        }
        else {
            # Regular modules deploy to downstream environments only
            pac org select --environment $deploymentConfig.Environments."GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!
        }

        Write-Host ""
        Write-Host "Completed deployment of module: $module" -ForegroundColor Green
    }
} while ($module -ne "") # Continue looping until the input is an empty string

Write-Host "All deployments complete." -ForegroundColor Green