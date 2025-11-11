# This script will build a module in GovCDM or Solution-Accelerators
# and then copy the unmanaged and managed solution artifacts
# into a solution folder in the Dist folder in this project

# This allows us to create distribution copies of the solution artifacts
# for anyone who does not want to or cannot perform the builds via the repo
# aka "The easy button"

# Be sure to set the version number you want in your online copy first,
# then synchronize that down to your local copy here
# and then run this script to create the solution artifacts

$projectRoot = Join-Path $PSScriptRoot ".."
. (Join-Path $projectRoot ".scripts\Util.ps1")

function Get-NewFileName ($originalName, $newVersion, $moduleName) {
    if (-not [string]::IsNullOrEmpty($newVersion)) {
        $extension = [System.IO.Path]::GetExtension($originalName)
        
        # Convert module name to title case for consistent formatting
        $formattedModuleName = (Get-Culture).TextInfo.ToTitleCase($moduleName.ToLower())
        $formattedModuleName = $formattedModuleName -replace '-', '-'  # Keep hyphens as-is
        
        # Check if this is a managed solution
        if ($originalName -like "*_managed*") {
            return "MSGov-DataModels-{0}_managed - {1}{2}" -f $formattedModuleName, $newVersion, $extension
        } else {
            return "MSGov-DataModels-{0} - {1}{2}" -f $formattedModuleName, $newVersion, $extension
        }
    }
    return $originalName
}

function Copy-SolutionArtifact($sourceArtifact, $newVersion, $moduleName) {

    $sourceFile = Join-Path $artifactFolder $sourceArtifact
    $targetFile = Get-NewFileName $sourceFile $newVersion $moduleName

    $versionFolder = Join-Path -Path $releasesFolder -ChildPath "v$newVersion"
    $destinationPath = Join-Path -Path $versionFolder -ChildPath $targetFile
    
    # Retry logic for file copy in case of file locking issues
    $maxRetries = 5
    $retryCount = 0
    $copySuccessful = $false
    
    while (-not $copySuccessful -and $retryCount -lt $maxRetries) {
        # Check if source file is in use
        if (Test-FileInUse $sourceFile) {
            Write-Host "Source file $sourceArtifact is currently in use (attempt $($retryCount + 1) of $maxRetries)..." -ForegroundColor Yellow
            if ($retryCount -eq 0) {
                Get-FileUsingProcesses $sourceFile
            }
            Start-Sleep -Seconds (3 + $retryCount * 2) # 3s, 5s, 7s, 9s, 11s
            $retryCount++
            continue
        }
        
        try {
            if ($retryCount -gt 0) {
                Write-Host "Retrying copy operation for $sourceArtifact (attempt $($retryCount + 1) of $maxRetries)..."
            }
            
            Copy-Item -Path $sourceFile -Destination $destinationPath
            $copySuccessful = $true
            Write-Host "Successfully copied $sourceArtifact to releases folder." -ForegroundColor Green
        }
        catch {
            $retryCount++
            if ($retryCount -ge $maxRetries) {
                Write-Host "Failed to copy $sourceArtifact after $maxRetries attempts. Error: $($_.Exception.Message)" -ForegroundColor Red
                Write-Host "This may be due to persistent file locks from background processes like CodeQL, Windows Defender, or other scanning tools." -ForegroundColor Red
                throw
            }
            else {
                $waitTime = 3 + ($retryCount * 2) # 3s, 5s, 7s, 9s
                Write-Host "Copy operation failed for $sourceArtifact (attempt $retryCount of $maxRetries). Waiting $waitTime seconds before retry..." -ForegroundColor Yellow
                Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Gray
                Start-Sleep -Seconds $waitTime
            }
        }
    }
}

# ask which type of module
Write-Host ""
Write-Host "Select module type:"
Write-Host "1. Modules"
Write-Host "2. Cross-Module"
$moduleTypeChoice = Read-Host "Enter choice (1 or 2)"

switch ($moduleTypeChoice) {
    "1" { $ipType = "modules" }
    "2" { $ipType = "cross-module" }
    default { 
        Write-Host "Invalid choice. Defaulting to modules."
        $ipType = "modules"
    }
}

$baseFolder = "$projectRoot\$ipType"

# ask for which module to sync
Write-Host ""
$excludeFolders = "__pycache__", "Scripts"
$folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
$module = Select-ItemFromList $folderNames

# Set up some paths here
$moduleFolder = "$baseFolder\$module"
$solutionFilePath = Join-Path $moduleFolder "src\Other\Solution.xml"
$releasesFolder = Join-Path $moduleFolder "releases"
$artifactFolder = Join-Path $moduleFolder "bin\Debug"
$cdsprojFile = Get-ChildItem -Path $moduleFolder -Filter "*.cdsproj" | Select-Object -First 1
$solutionName = $cdsprojFile.BaseName

# Confirm the version number
$currentVersion = Read-SolutionVersion $solutionFilePath
$confirm = Read-Host "Version number is $currentVersion, OK? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Update the version number in your online copy, use Sync-Module to pull that change down, and run this script again. This is to ensure that your next sync will not overwrite the version number in your local copy."
    exit
}
$newVersion = $currentVersion
# $newVersion = Read-Host "Enter new version number (enter to keep current)"
# if (-not [string]::IsNullOrEmpty($newVersion)) {
#     Update-SolutionVersion $solutionFilePath $newVersion
# }
# else {
#     $newVersion = $currentVersion
# }

# Build the solution.zip artifacts (managed and unmanaged)
Build-Solution $moduleFolder

# Ensure the destination folders exist
if (-not (Test-Path $releasesFolder)) {
    New-Item -Path $releasesFolder -ItemType Directory -Force
    Write-Host "Created releases folder: $releasesFolder"
}

$versionFolder = Join-Path -Path $releasesFolder -ChildPath "v$newVersion"
if (-not (Test-Path $versionFolder)) {
    New-Item -Path $versionFolder -ItemType Directory -Force
    Write-Host "Created version folder: $versionFolder"
}

# Copy the files
Copy-SolutionArtifact "${solutionName}.zip" $newVersion $module
Copy-SolutionArtifact "${solutionName}_managed.zip" $newVersion $module

# document the module
# & "${PSScriptRoot}/../.venv/Scripts/python.exe" "${PSScriptRoot}/create_erd.py" $module
# Copy-SolutionArtifact "README.md" $newVersion

# $sourceFile = "$moduleFolder\bin\debug\readme.md"
# $targetFile = "..\Business-Applications.wiki\Government-Common-Data-Model\$module.md"

# # Check if the source file exists
# if (-not (Test-Path -Path $sourceFile)) {
#     Write-Error "Source file does not exist: $sourceFile"
#     exit 1
# }

# if (-not (Test-Path -Path $targetFile)) {
#     Write-Error "Target wiki page does not exist: $targetFile. Please set up the blank wiki page first."
#     exit 1
# }

# Copy the source file to the target path, overwriting if it exists
# Copy-Item -Path $sourceFile -Destination $targetFile -Force

# Write-Output "The file has been successfully copied to: $targetFile"

Write-Host ""
Write-Host "Release created successfully!" -ForegroundColor Green
Write-Host "Module: $module" -ForegroundColor Cyan
Write-Host "Version: $newVersion" -ForegroundColor Cyan
Write-Host "Location: $versionFolder" -ForegroundColor Cyan