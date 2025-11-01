# Common Scripts Ready

# Synchronizes changes from the online environment down to your local copy

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

# ask which type of ip
Write-Host ""
$ipType = "modules"
$baseFolder = "$projectRoot\$ipType"

# ask for which module to sync
Write-Host ""
$excludeFolders = "__pycache__", ".scripts"
$folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
$module = Select-ItemFromList $folderNames

# select deployment configuration
Write-Host ""
$deploymentConfig = Select-Deployment

# connect to the selected tenant
Write-Host ""
Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

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

Sync-Module "$baseFolder\$module"
Build-Solution "$baseFolder\$module"

# & "${PSScriptRoot}/../.venv/Scripts/python.exe" "${PSScriptRoot}/create_erd.py" $module
