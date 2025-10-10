# Common Scripts Ready 

# Builds the module only, does not deploy

$projectRoot = "$PSScriptRoot\.."
. "${projectRoot}\.scripts\Util.ps1"

# ask which type of ip
$ipType = "modules"
$baseFolder = "$projectRoot\modules"

# ask for which module to sync
Write-Host ""
$excludeFolders = "__pycache__", ".scripts"
$folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
$module = Select-ItemFromList $folderNames

$originalDir = Get-Location
Set-Location "$baseFolder\$module"
dotnet build
Set-Location $originalDir

# & "${PSScriptRoot}/../.venv/Scripts/python.exe" "${PSScriptRoot}/create_erd.py" $module