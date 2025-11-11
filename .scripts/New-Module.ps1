
$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

# Ask user which type of module to create
Write-Host ""
Write-Host "Select module type:"
Write-Host "1. Use Case Module (goes in 'modules' folder, deploys to GOV CDM MODULE)"
Write-Host "2. Cross Module (goes in 'cross-module' folder, deploys to GOV CDM UTILITY)"
Write-Host ""

do {
    $moduleTypeSelection = Read-Host "Enter selection (1 or 2)"
    if ($moduleTypeSelection -notin @("1", "2")) {
        Write-Host "Invalid selection. Please enter 1 or 2." -ForegroundColor Yellow
    }
} while ($moduleTypeSelection -notin @("1", "2"))

# Set folder and environment based on selection
if ($moduleTypeSelection -eq "2") {
    $ipType = "cross-module"
    $isCrossModule = $true
    Write-Host "Creating cross module..." -ForegroundColor Cyan
} else {
    $ipType = "modules" 
    $isCrossModule = $false
    Write-Host "Creating use case module..." -ForegroundColor Cyan
}

$friendlyName = Read-Host "Enter module name (spaces allowed)"
$solutionFolderName = $friendlyName.Replace(" ", "-")
$solutionFolderName = $solutionFolderName.Replace(",", "")
$solutionFolderNameLowercase = $solutionFolderName.ToLower()
$pacFriendlyName = $friendlyName.Replace(" ", "")
$pacFriendlyName = $pacFriendlyName.Replace(",", "")
$solutionUniqueName = $pacFriendlyName.ToLower()

$prefix = "govcdm"
$publisherSchemaName = "microsoftgovcdm"
$publisherName = "Microsoft Government Common Data Model"
$friendlyPrefix = "Gov CDM"
$pacFriendlyPrefix = "Gov-CDM"

$solutionUniqueName = "${prefix}_${solutionUniqueName}"

# Ensure the target folder exists
$baseFolderPath = Join-Path -Path "$PSScriptRoot\.." -ChildPath $ipType
if (-not (Test-Path $baseFolderPath)) {
    Write-Host "Creating $ipType folder..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $baseFolderPath -Force | Out-Null
}

$solutionPath = Join-Path -Path "$PSScriptRoot\.." -ChildPath "$ipType\$pacFriendlyName"
$publisherPrefix = $prefix

pac solution init --publisher-name $publisherSchemaName --publisher-prefix $publisherPrefix -o $solutionPath

Rename-Item $solutionPath $solutionFolderNameLowercase
$solutionPath = Join-Path -Path "$PSScriptRoot\.." -ChildPath "$ipType\$solutionFolderNameLowercase"

Update-SolutionName $solutionPath/src/Other/Solution.xml "$friendlyPrefix - $friendlyName"
Update-SolutionUniqueName $solutionPath/src/Other/Solution.xml $solutionUniqueName
Update-SolutionPublisherName $solutionPath/src/Other/Solution.xml $publisherName
Update-SolutionProjectManaged "${solutionPath}\${pacFriendlyName}.cdsproj"
Rename-Item -Path "${solutionPath}\${pacFriendlyName}.cdsproj" -NewName "$pacFriendlyPrefix-${solutionFolderName}.cdsproj"

$importAnswer = Read-Host "Build and import into environment as unmanaged solution (y/n)?"

if ($importAnswer -eq 'y') {
    # Use deployment configuration system like other scripts
    Write-Host ""
    $deploymentConfig = Select-Deployment
    
    Write-Host ""
    Write-Host "Connecting to tenant: $($deploymentConfig.Tenant)"
    Connect-DataverseTenant -authProfile $deploymentConfig.Tenant

    # Determine target environment based on module type
    $targetEnv = if ($isCrossModule) {
        $deploymentConfig.Environments."GOV CDM UTILITY"
    } else {
        $deploymentConfig.Environments."GOV CDM MODULE"
    }

    Write-Host "Connecting to environment: $targetEnv"
    pac org select --environment $targetEnv
    
    # Use enhanced Deploy-Solution function
    Deploy-Solution $solutionPath -AutoConfirm
    
    Write-Host ""
    $moduleTypeText = if ($isCrossModule) { "Cross Module" } else { "Use Case Module" }
    Write-Host "$moduleTypeText '$friendlyName' created and deployed successfully to $targetEnv!" -ForegroundColor Green
}