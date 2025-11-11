<#
.SYNOPSIS
Deploy all modules as managed solutions to a selected Dataverse tenant/environment.

.DESCRIPTION
This script connects to a Dataverse tenant and environment using the shared
functions in `Util.ps1`, then deploys every folder inside the `modules`
directory as a managed solution. The deployment order ensures `core` is
installed first, followed by `process-and-tasking`, and then the remaining
modules in alphabetical order.

.NOTES
Uses: Connect-DataverseTenant, Connect-DataverseEnvironment, Deploy-Solution
from `.scripts\Util.ps1` (same helpers used by `Ship-Module.ps1`).
#>

[CmdletBinding(SupportsShouldProcess=$true)]

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

Write-Host "Connecting to Dataverse tenant and environment..." -ForegroundColor Cyan

# select deployment configuration
Write-Host ""
$deploymentConfig = Select-Deployment

# connect to the selected tenant
Write-Host ""
Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

# allow user to select target environment from the deployment config
Write-Host ""
Write-Host "Available Environments:"
$envNames = $deploymentConfig.Environments.PSObject.Properties.Name
$selectedEnvKey = Select-ItemFromList $envNames
$targetEnv = $deploymentConfig.Environments.$selectedEnvKey

Write-Host ""
Write-Host "Connecting to environment: $targetEnv"
Connect-DataverseEnvironment -envName $targetEnv

# Ask user to select module type (modules or cross-module)
Write-Host ""
$ipType = Select-ModuleType $projectRoot
$baseFolder = Join-Path $projectRoot $ipType

$excludeFolders = '__pycache__', '.scripts'

# Ensure deployment order: core first, then process-and-tasking, then the rest
$orderedFirst = @('core', 'process-and-tasking')

Write-Host "Collecting modules from: $baseFolder" -ForegroundColor Cyan
if (-not (Test-Path $baseFolder)) {
    Write-Host "Modules folder not found: $baseFolder" -ForegroundColor Red
    return
}

$allModules = Get-ChildItem -Path $baseFolder -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name

# Build final list preserving the required order
$toDeploy = @()
foreach ($m in $orderedFirst) {
    if ($allModules -contains $m) {
        $toDeploy += $m
    } else {
        Write-Host "Note: ordered module '$m' not found in $baseFolder; skipping." -ForegroundColor Yellow
    }
}

$remaining = $allModules | Where-Object { $orderedFirst -notcontains $_ } | Sort-Object
$toDeploy += $remaining

Write-Host "Deployment order:" -ForegroundColor Green
$toDeploy | ForEach-Object { Write-Host " - $_" }

foreach ($module in $toDeploy) {
    Write-Host "`nDeploying module: $module" -ForegroundColor Cyan
    $modulePath = Join-Path $baseFolder $module
    if (-not (Test-Path $modulePath)) {
        Write-Host "Module folder missing: $modulePath" -ForegroundColor Yellow
        continue
    }

    # Use Deploy-Solution helper from Util.ps1 (same as Ship-Module.ps1)
    # Guard against $PSCmdlet being $null (can happen when dot-sourced); default to proceeding
    $shouldProceed = $true
    if ($PSCmdlet) {
        $shouldProceed = $PSCmdlet.ShouldProcess($module, "Deploy managed solution")
    }

    if ($shouldProceed) {
        Deploy-Solution $modulePath -Managed -AutoConfirm
    }
}

Write-Host "All deployments processed." -ForegroundColor Green
