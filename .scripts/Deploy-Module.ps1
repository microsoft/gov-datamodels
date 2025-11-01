# Common Scripts Ready 

# local managed -> online environment as managed to downstream environments
# use this script to deploy the latest managed solution to downstream environments
# will not deploy the umanaged solution to the development environment, use Push-Module for that

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

$baseFolder = "$projectRoot\modules"
$ipType = "modules"

# select deployment configuration once at the start
Write-Host ""
$deploymentConfig = Select-Deployment

# connect to the selected tenant once
Write-Host ""
Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

# Start the loop for module selection and deployment
do {
    # ask for which module to deploy
    Write-Host ""
    $excludeFolders = "__pycache__", ".scripts"
    $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
    $module = Select-ItemFromList $folderNames

    if ($module -ne "") {
        Write-Host ""
        Write-Host "Deploying module: $module" -ForegroundColor Cyan

        if ($module -eq "core") {

            pac org select --environment $deploymentConfig.Environments."GOV CDM UTILITY"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!

            pac org select --environment $deploymentConfig.Environments."GOV CDM MODULE"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            # Additional deployment targets can be configured here based on your config.json structure
            # For now, keeping the hardcoded values for environments not in config.json
            
            pac org select --environment "GOV UTILITY APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment "GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            # pac org select --environment "GOV ENTERPRISE APPS"
            # Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            # pac org select --environment "GOV DYNAMICS"
            # Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
        }
        elseif ($module -eq "process-and-tasking") {

            pac org select --environment $deploymentConfig.Environments."GOV CDM MODULE"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm # build the first time!

            # Additional deployment targets
            pac org select --environment "GOV UTILITY APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            pac org select --environment "GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            # pac org select --environment "GOV ENTERPRISE APPS"
            # Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm

            # pac org select --environment "GOV DYNAMICS"
            # Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
        }
        else {

            pac org select --environment "GOV APPS"
            Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm

            # if (($module -eq "legal-operations") -or ($module -eq "investigations")) {
            #     pac org select --environment "GOV DYNAMICS"
            #     Deploy-Solution "$baseFolder\$module" -Managed -SkipBuild -AutoConfirm
            # }

            # pac org select --environment "GOV ENTERPRISE APPS"
            # Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm -SkipBuild # Build was completed above for GOV APPS

            # add additional modules here if you need them for FED ENT(erprise) APPS
            # if (($module -eq "Task-Management") -or ($module -eq "Process-and-Tasking")) {
            #     pac org select --environment "FED ENT APPS"
            #     Deploy-Solution "$baseFolder\$module" -Managed  -SkipBuild -AutoConfirm
            # }

            # if (($module -eq "Records-Management") -or ($module -eq "Training-and-Certification")) {
            #     pac org select --environment "FED ENT APPS"
            #     Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm
            # }

            # special case - push the Investigations data model to GOV CDM | ICM D365
            # if ($module -eq "investigations") {
            #     Connect-DataverseTenant -authProfile "GOV APPS"
            #     pac org select --environment "GOV DYNAMICS"
            #     Deploy-Solution "$baseFolder\$module" -Managed -AutoConfirm
            # }
        }

        Write-Host ""
        Write-Host "Completed deployment of module: $module" -ForegroundColor Green
    }
} while ($module -ne "") # Continue looping until the input is an empty string

Write-Host "All deployments complete." -ForegroundColor Green