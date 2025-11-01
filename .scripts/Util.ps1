function Invoke-PythonFunction {
    param (

        [Parameter(Mandatory = $true)]
        [string]$FunctionName,

        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Arguments
    )

    # Example 1: Invoke-PythonFunction -FunctionName "test" -Arguments "Hi"
    # Example 2: Invoke-PythonFunction -FunctionName "add" -Arguments 2, 3

    $pythonScriptPath = "$PSScriptRoot\util.py"
    $pythonCommand = "python ""$pythonScriptPath"" ""$FunctionName"""

    foreach ($arg in $Arguments) {
        if ($arg -is [string]) {
            $pythonCommand += " ""$arg"""
        }
        elseif ($arg -is [int] -or $arg -is [double] -or $arg -is [decimal]) {
            $pythonCommand += " $arg"
        }
        else {
            throw "Unsupported argument type: $($arg.GetType().Name)"
        }
    }

    Invoke-Expression -Command $pythonCommand
}

function Select-ItemFromList {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$choices
    )

    # Helper function to format a choice with a leading number
    function Format-Choice {
        param([int]$index, [string]$choice)
        return "{0}. {1}" -f ($index + 1), $choice
    }

    # Determine the max length for formatting each column
    $maxChoiceLength = ($choices | Measure-Object -Property Length -Maximum).Maximum
    $columnWidth = [Math]::Max($maxChoiceLength + 5, 30)  # Ensures minimum width

    # Display the choices to the user
    Write-Host "Please select an item:"
    for ($i = 0; $i -lt $choices.Count; $i += 2) {
        $firstChoice = Format-Choice $i $choices[$i]
        $secondChoice = if ($i + 1 -lt $choices.Count) { Format-Choice ($i + 1) $choices[$i + 1] } else { "" }
        
        # Write both choices in a single line with aligned columns
        Write-Host ("{0,-$columnWidth} {1}" -f $firstChoice, $secondChoice)
    }

    # Get the user's selection
    do {
        $selection = Read-Host "`nEnter selection"
        if ($selection -notin 1..$choices.Count) {
            Write-Host "Invalid selection, please try again."
        }
    } while ($selection -notin 1..$choices.Count)

    # Return the selected item
    return $choices[$selection - 1]
}

function Select-Environment {
    param(
        [string]$envKey = $null
    )

    if (-not $envKey) {
        Write-Host ""
        # $envKey = Read-Host "Enter target environment key (from env_config.json)"

        # Read and parse JSON file
        $filePath = "${PSScriptRoot}\..\env_config.json"
        $jsonContent = Get-Content -Path $filePath | ConvertFrom-Json

        # Display the top-level keys as a numbered list
        $keys = $jsonContent.PSObject.Properties.Name
        Write-Host "Select an environment:"
        for ($i = 0; $i -lt $keys.Count; $i++) {
            Write-Host ("{0}. {1}" -f ($i + 1), $keys[$i])
        }

        # Allow user to select an item
        $selectedIndex = -1
        while ($selectedIndex -lt 0 -or $selectedIndex -ge $keys.Count) {
            Write-Host ""
            $input = Read-Host "Enter selection"
            # Convert to 0-based index
            $selectedIndex = $input - 1

            if ($selectedIndex -lt 0 -or $selectedIndex -ge $keys.Count) {
                Write-Host "Invalid choice. Please enter a number between 1 and $($keys.Count)."
            }
        }

        $envKey = $keys[$selectedIndex]
    }

    $envConfig = Get-EnvironmentConfiguration $envKey
    Write-Host "Connecting..."
    $authSelect = pac auth select -n $envConfig.AuthProfile
    Write-Host $authSelect
    $pacOutput = pac org select --environment $envConfig.Url | Tee-Object -Variable pacOutput
    Write-Host $pacOutput
    return $envKey
}

function Update-SolutionPublisherName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath,

        [Parameter(Mandatory = $true)]
        [string]$newDescription
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Find the specific LocalizedName element
    $element = $xmlContent.SelectSingleNode("/ImportExportXml/SolutionManifest/Publisher/LocalizedNames/LocalizedName")

    # Replace the description attribute
    if ($null -ne $element) {
        $element.description = $newDescription
    }

    # Save the modified XML back to the file
    $xmlContent.Save($xmlFilePath)

}

function Update-SolutionName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath,

        [Parameter(Mandatory = $true)]
        [string]$newDescription
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Find the specific LocalizedName element
    $element = $xmlContent.SelectSingleNode("/ImportExportXml/SolutionManifest/LocalizedNames/LocalizedName")

    # Replace the description attribute
    if ($null -ne $element) {
        $element.description = $newDescription
    }

    # Save the modified XML back to the file
    $xmlContent.Save($xmlFilePath)

}

function Update-SolutionUniqueName {
    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath,

        [Parameter(Mandatory = $true)]
        [string]$newValue
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Find the specific LocalizedName element
    $element = $xmlContent.SelectSingleNode("/ImportExportXml/SolutionManifest/UniqueName")

    # Replace the description attribute
    if ($null -ne $element) {
        $element.InnerText = $newValue
    }

    # Save the modified XML back to the file
    $xmlContent.Save($xmlFilePath)
}

function Remove-UnmanagedSolution {
    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$solutionName
    )

    $solutionUniqueName = ${PSScriptRoot} -replace "-", ""

    Update-SolutionUniqueName "${solutionUniqueName}_delete"
    Deploy-Solution $PSScriptRoot -Managed
    pac solution delete --solution-name "${solutionUniqueName}"
    pac solution delete --solution-name "${solutionUniqueName}_delete"
    Update-SolutionUniqueName "${solutionUniqueName}"
}

function Update-SolutionProjectManaged {

    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Get the default namespace
    $namespace = $xmlContent.DocumentElement.NamespaceURI

    # Create the new elements in the default namespace
    $propertyGroup = $xmlContent.CreateElement('PropertyGroup', $namespace)
    $solutionPackageType = $xmlContent.CreateElement('SolutionPackageType', $namespace)
    $solutionPackageType.InnerText = 'Both'
    $solutionPackageEnableLocalization = $xmlContent.CreateElement('SolutionPackageEnableLocalization', $namespace)
    $solutionPackageEnableLocalization.InnerText = 'false'

    # Add the new elements to the PropertyGroup
    $propertyGroup.AppendChild($solutionPackageType) | Out-Null
    $propertyGroup.AppendChild($solutionPackageEnableLocalization) | Out-Null

    # Add the PropertyGroup to the Project (root element)
    $xmlContent.DocumentElement.AppendChild($propertyGroup) | Out-Null

    # Save the modified XML back to the file
    $xmlContent.Save($xmlFilePath)

}

function Read-SolutionVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Find the specific LocalizedName element
    $element = $xmlContent.SelectSingleNode("/ImportExportXml/SolutionManifest/Version")

    return $element.InnerText
}

function Update-SolutionVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$xmlFilePath,

        [Parameter(Mandatory = $true)]
        [string]$newVersion
    )

    # Load the XML file
    [xml]$xmlContent = Get-Content $xmlFilePath

    # Find the specific LocalizedName element
    $element = $xmlContent.SelectSingleNode("/ImportExportXml/SolutionManifest/Version")

    # Replace the description attribute
    if ($null -ne $element) {
        $element.InnerText = $newVersion
    }

    # Save the modified XML back to the file
    $xmlContent.Save($xmlFilePath)

}

function Get-EnvironmentConfiguration {

    param(
        [Parameter(Mandatory = $true)]
        [string]$environmentKey
    )
    # Define the path to your JSON file
    $jsonFilePath = "${PSScriptRoot}\..\env_config.json"

    # Load the JSON file
    $jsonContent = Get-Content $jsonFilePath | ConvertFrom-Json

    # Retrieve the username and creds for the specified environment
    $authProfile = $jsonContent.$environmentKey.authprofile
    $username = $jsonContent.$environmentKey.username
    $cred = $jsonContent.$environmentKey.cred
    $url = $jsonContent.$environmentKey.resource
    $fullDomain = $jsonContent.$environmentKey.domain
    $domain = $fullDomain -ireplace ".onmicrosoft.com", ""

    if (-not [string]::IsNullOrEmpty($cred)) {
        $secureCred = ConvertTo-SecureString $cred -Force -AsPlainText
    }
    
    # Create and return a custom object with the username and creds
    $result = New-Object -Type PSObject
    $result | Add-Member -Type NoteProperty -Name AuthProfile -Value $authProfile
    $result | Add-Member -Type NoteProperty -Name Username -Value $username

    if (-not [string]::IsNullOrEmpty($cred)) {
        $result | Add-Member -Type NoteProperty -Name Cred -Value $secureCred
    }
    $result | Add-Member -Type NoteProperty -Name Url -Value $url
    $result | Add-Member -Type NoteProperty -Name FullDomain -Value $fullDomain
    $result | Add-Member -Type NoteProperty -Name Domain -Value $domain

    return $result
    # # Output the username and creds
    # Write-Host "Username: $username"
    # Write-Host "Cred: $cred"

}

function Confirm-Next {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    Write-Host ""
    $confirm = Read-Host $Text
    if ($confirm -eq "y") {
        return $true
    }
    return $false
}

function Build-Solution {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SolutionPath
    )

    $originalDir = Get-Location
    Set-Location $SolutionPath
    dotnet build
    Set-Location $originalDir
}

function Deploy-Solution {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SolutionPath,

        [Parameter(Mandatory = $false)]
        [switch]$Managed,

        [Parameter(Mandatory = $false)]
        [switch]$SkipBuild,

        [Parameter(Mandatory = $false)]
        [switch]$AutoConfirm
    )

    $cdsprojFile = Get-ChildItem -Path $SolutionPath -Filter *.cdsproj | Select-Object -First 1
    $Name = $cdsprojFile.BaseName
    $managedSuffix = ""
    if ($Managed -eq $true) {
        $managedSuffix = "_managed"
    }

    if ($AutoConfirm -eq $false) {
        Write-Host ""
        $confirm = Read-Host "Deploy ${Name} solution?"
        if ($confirm -ne "y") {
            return
        }
    }

    $path = "bin\debug\${Name}${managedSuffix}.zip"

    $originalDir = Get-Location
    Set-Location $SolutionPath

    if ($SkipBuild -eq $false) {
        dotnet build
    }

    pac solution import --path $path
    # pac solution import --path $path -up
    # pac solution import --path $path --force-overwrite # will overwrite unamanged changes (not recommended)
    # use -cm to convert unmanaged components to managed
    # pac solution upgrade --path $path

    Set-Location $originalDir
}


function Sync-Module {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SolutionPath
    )

    $originalDir = Get-Location

    Write-Host ""
    Write-Host "Synchronizing $SolutionPath ..."
    Set-Location $SolutionPath
    pac solution sync

    Set-Location $originalDir
}

function Connect-PBI {
    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey
    )

    Install-Module -Name MicrosoftPowerBIMgmt -AllowClobber -Scope CurrentUser # -force
    Import-Module MicrosoftPowerBIMgmt
    Import-Module MicrosoftPowerBIMgmt.Profile

    $envConfig = Get-EnvironmentConfiguration($envKey)
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $envConfig.Username, $envConfig.Cred
    Connect-PowerBIServiceAccount -Credential $credential
}

function New-PBIWorkspace {

    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName
    )
    # . "$PSScriptRoot\Util.ps1"

    # https://martinschoombee.com/2020/09/15/automating-power-bi-deployments-a-series/

    # Install-Module -Name MicrosoftPowerBIMgmt -AllowClobber -Scope CurrentUser
    # Import-Module MicrosoftPowerBIMgmt
    # Import-Module MicrosoftPowerBIMgmt.Profile

    $envConfig = Get-EnvironmentConfiguration($envKey)

    $WorkspaceObject = Get-PowerBIWorkspace -Scope Organization -Name $WorkspaceName -WarningAction SilentlyContinue -ErrorAction Stop
    if ($WorkspaceObject.Count -eq 0) {
        Write-Host "Creating Power BI Workspace ${WorkspaceName}..."
        $WorkspaceObject = New-PowerBIWorkspace -Name $WorkspaceName
    }
    else {
        if ($WorkspaceObject.State -eq "Deleted") { 
            Write-Host "Restoring Power BI Workspace"
            #Workspace is in a deleted state 
            #Restore workspace 
            Restore-PowerBIWorkspace -Id $WorkspaceObject.Id -RestoredName $WorkspaceName -AdminUserPrincipalName $envConfig.Username
        }
        else {
            Write-Host "Power BI Workspace already exists"
        }
    }

    return $WorkspaceObject
}

function Deploy-PBIReports {
    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $true)]
        [string]$ReportsPath
    )

    Write-Host ""
    $confirm = Read-Host "Deploy reports to ${WorkspaceName} Power BI workspace?"
    if ($confirm -ne "y") {
        return
    }

    # Get all files in the directory
    Get-ChildItem -Path $ReportsPath -File | ForEach-Object {
        $PbixFilePath = $_.FullName
        $ReportName = $_.BaseName
        Write-Host "Deploying ${ReportName} to ${WorkspaceName}..."
        Deploy-PBIReport $envKey $WorkspaceName $ReportName $PbixFilePath
    }
}
function Deploy-PBIReport {

    param(

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $true)]
        [string]$ReportName,

        [Parameter(Mandatory = $true)]
        [string]$PbixFilePath
    )

    # New-PBIWorkspace $envKey $WorkspaceName
    $PBIWorkspace = (Get-PowerBIWorkspace -Scope Organization -Name $WorkspaceName)
    New-PowerBIReport -Workspace $PBIWorkspace -Path $PbixFilePath -Name $ReportName -ConflictAction CreateOrOverwrite
}

function Update-PBIReportParameter {
    param(

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $true)]
        [string]$ReportName,

        # for update multiple at one time
        # [Parameter(Mandatory = $true)]
        # [PSCustomObject]$Parameters

        [Parameter(Mandatory = $true)]
        [string]$ParamName,

        [Parameter(Mandatory = $true)]
        [string]$ParamValue
    )

    $PBIWorkspace = (Get-PowerBIWorkspace -Scope Organization -Name $WorkspaceName)
    $PBIWorkspaceId = $PBIWorkspace.Id
    
    $PBIReport = Get-PowerBIReport -WorkspaceId $PBIWorkspaceId -Name $ReportName
    $DatasetId = $PBIReport.DatasetId

    $uri = "groups/$($PBIWorkspaceId)/datasets/$($DatasetId)/Default.UpdateParameters"

    # update multiple at one time:
    # $updateDetailsArray = @()
    # foreach ($param in $Parameters) {
    #     $updateDetailsArray += @{
    #         name     = $param.name
    #         newValue = $param.newValue
    #     }
    # }
    # $body = @{
    #     updateDetails = $updateDetailsArray
    # } | ConvertTo-Json

    $body = @{
        updateDetails = @(
            @{
                name     = $ParamName
                newValue = $ParamValue
            }
        )
    } | ConvertTo-Json

    Invoke-PowerBIRestMethod -Url $uri -Method Post -Body $body
}

# Function to get all subsites for a given site
function Get-SPOSubWebs($web) {
    Write-Host "Site: $($web.URL)"
    $webs = $web.Webs
    Write-Host $webs
}

function Connect-SharePoint {

    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$siteURL
    )

    $envConfig = Get-EnvironmentConfiguration($envKey)
    $creds = New-Object System.Management.Automation.PSCredential ($envConfig.Username, $envConfig.Cred)

    try {
        Connect-PnPOnline -Url $siteURL -Credentials $creds
    }
    catch {
        Register-PnPManagementShellAccess
        Connect-PnPOnline -Url $siteURL -Credentials $creds
    }
}

function New-SharePointSite {

    param(

        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$title,

        [Parameter(Mandatory = $true)]
        [string]$timeZoneDescription
    )

    $envConfig = Get-EnvironmentConfiguration($envKey)

    $domain = $envConfig.Domain
    $sharePointAdminURL = "https://${domain}-admin.sharepoint.com"
    Connect-SharePoint $envKey $sharePointAdminURL

    $alias = $title -replace "\s", ""
    $siteUrl = "https://${domain}.sharepoint.com/sites/" + $alias

    try {
        $site = Get-PnPTenantSite -Url $siteUrl -ErrorAction Stop
        if ($site) {
            Write-Host "Site exists."
        }
    }
    catch {
        Write-Host "Site does not exist, creating..."
        $siteURL = New-PnPSite -Type TeamSite -Title $title -Alias $alias
    }

    Connect-SharePoint $envKey $siteURL
    Update-SharePointTimeZone $siteURL $timeZoneDescription

    return $siteURL
}

function Install-Required {
    # Install-PackageProvider -Name nuget -MinimumVersion 2.8.5.201 -force -Scope CurrentUser
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
    Update-Module -Name Microsoft.Online.SharePoint.PowerShell
    # Install-Module SharePointPnPPowerShellOnline -AllowClobber -Scope CurrentUser
    # Uninstall-Module -Name SharePointPnPPowerShellOnline -AllVersions -Force 
    Install-Module PnP.PowerShell -AllowClobber -Scope CurrentUser
    # Install-Module -Name "PnP.PowerShell" -RequiredVersion 1.12.0 -Force -AllowClobber -Scope CurrentUser
}

function Import-Required {
    # Import-Module Microsoft.Online.SharePoint.Powershell -DisableNameChecking
    Import-Module PnP.PowerShell
}

function Import-ExcelAsSharePointList {

    param(
        [Parameter(Mandatory = $true)]
        [string]$envKey,

        [Parameter(Mandatory = $true)]
        [string]$sharePointURL,

        [Parameter(Mandatory = $true)]
        [string]$ExcelPath,

        [Parameter(Mandatory = $true)]
        [string]$ListName
    )

    Connect-SharePoint $envKey $sharePointURL

    # Open Excel and get the first worksheet in the first workbook
    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Open($ExcelPath)
    $worksheet = $workbook.Worksheets.Item(1)
    $range = $worksheet.UsedRange

    # Create the list
    $siteListName = $ListName -replace "\s", ""
    New-PnPList -Title $ListName -Url "Lists/${siteListName}" -Template GenericList

    # Get the list
    $list = Get-PnPList -Identity $ListName

    # Add fields to the list based on the Excel columns
    for ($i = 1; $i -le $range.Columns.Count; $i++) {
        $header = $range.Cells.Item(1, $i).Value2
        if ($header -ne 'ID' -and $header -ne 'Title') {
            if ($header -match "\[Date\]$") {
                $fieldName = ($header -replace "\[Date\]$", "").Trim()
                Add-PnPField -List $list -DisplayName $fieldName -InternalName $fieldName -Type DateTime
            }
            elseif ($header -match "\[Choice\]$") {
                $fieldName = ($header -replace "\[Choice\]$", "").Trim()
                Add-PnPField -List $list -DisplayName $fieldName -InternalName $fieldName -Type Choice
            }
            else {
                Add-PnPField -List $list -DisplayName $header -InternalName $header -Type Text
            }
        }  
    }

    # Add items to the list from the Excel file
    for ($i = 2; $i -le $range.Rows.Count; $i++) {
        $values = @{}
        for ($j = 1; $j -le $range.Columns.Count; $j++) {

            $header = $range.Cells.Item(1, $j).Value2
            if ($header -match "\[Date\]$") {
                $fieldName = ($header -replace "\[Date\]$", "").Trim()
            }
            elseif ($header -match "\[Choice\]$") {
                $fieldName = ($header -replace "\[Choice\]$", "").Trim()
            }
            else {
                $fieldName = $header
            }
            $fieldName = $fieldName -replace "\s", "_x0020_"

            if ($header -match "\[Date\]$") {
                $excelDate = $range.Cells.Item($i, $j).Value2  # For example
                $date = [DateTime]::FromOADate($excelDate)
                $dateUtc = $date.ToUniversalTime()
                $value = $dateUtc.ToString('yyyy-MM-ddTHH:mm:ssZ') # ISO 8601 format
            }
            else {
                $value = $range.Cells.Item($i, $j).Value2
            }    

            if ($header -ne 'ID') {
                $values.Add($fieldName, $value)
            }
        }
        Add-PnPListItem -List $list -Values $values
    }

    # Close Excel
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

}

function Add-ViewToSharePointList {
    param(
        [Parameter(Mandatory = $true)] [string] $siteUrl,
        [Parameter(Mandatory = $true)] [string] $listName,
        [Parameter(Mandatory = $true)] [string] $viewName,
        [Parameter(Mandatory = $true)] [string[]] $fields
    )

    # Connect to the SharePoint site
    Connect-SharePoint $envKey $sharePointURL
    # Connect-PnPOnline -Url $siteUrl -UseWebLogin

    # Create the view
    Add-PnPView -List $listName -Title $viewName -Fields $fields
}

function Add-GroupedViewToSharePointList {
    param(
        [Parameter(Mandatory = $true)] [string] $siteUrl,
        [Parameter(Mandatory = $true)] [string] $listName,
        [Parameter(Mandatory = $true)] [string] $viewName,
        [Parameter(Mandatory = $true)] [string[]] $fields,
        [Parameter(Mandatory = $true)] [string] $groupByField
    )

    # Check if already connected to SharePoint Online
    $context = Get-PnPContext
    if ($null -eq $context) {
        # Connect to the SharePoint site
        Connect-PnPOnline -Url $siteUrl -UseWebLogin
    }

    # Create the view
    Add-PnPView -List $listName -Title $viewName -Fields $fields

    # Get the created view
    $view = Get-PnPView -List $listName -Identity $viewName


    # Get the CSOM view object
    $csomView = [Microsoft.SharePoint.Client.ClientContext].GetMethod("CastTo").MakeGenericMethod([Microsoft.SharePoint.Client.View]).Invoke($context, $view)

    # Add grouping to the view
    $csomView.ViewQuery = "<GroupBy Collapse='TRUE'><FieldRef Name='$groupByField'/></GroupBy>"
    $csomView.Update()
    Invoke-PnPQuery
}

function Update-SharePointTimeZone {

    param(
        [Parameter(Mandatory = $true)]
        [string]$SiteURL,

        [Parameter(Mandatory = $true)]
        [string]$TimeZoneName
    )

    $web = Get-PnPWeb -Includes RegionalSettings.TimeZones
    $Tzone = $web.RegionalSettings.TimeZones | Where-Object { $_.Description -like "*${TimeZoneName}*" }

    If ($Null -ne $TimeZoneName) {
        $web.RegionalSettings.TimeZone = $Tzone
        $web.Update()
        Invoke-PnPQuery
        Write-host "Timezone is Successfully Updated " -ForegroundColor Green
    }
    else {
        Write-host "Can't Find Timezone $TimezoneName " -ForegroundColor Red
    }
}

function New-SharePointCalendarView {

    param(
        [Parameter(Mandatory = $true)]
        [string]$url,

        [Parameter(Mandatory = $true)]
        [string]$listName
    )

    $newViewTitle = "Calendar View" #Change if you require a different View name

    $viewCreationJson = @"
{
    "parameters": {
        "__metadata": {
            "type": "SP.ViewCreationInformation"
        },
        "Title": "$newViewTitle",
        "ViewFields": {
            "__metadata": {
                "type": "Collection(Edm.String)"
            },
            "results": [
                "Start_x0020_Date",
                "End_x0020_Date",
                "Title"
            ]
        },
        "ViewTypeKind": 1,
        "ViewType2": "MODERNCALENDAR",
        "ViewData": "<FieldRef Name=\"Title\" Type=\"CalendarMonthTitle\" /><FieldRef Name=\"Title\" Type=\"CalendarWeekTitle\" /><FieldRef Name=\"Title\" Type=\"CalendarWeekLocation\" /><FieldRef Name=\"Title\" Type=\"CalendarDayTitle\" /><FieldRef Name=\"Title\" Type=\"CalendarDayLocation\" />",
        "CalendarViewStyles": "<CalendarViewStyle Title=\"Day\" Type=\"day\" Template=\"CalendarViewdayChrome\" Sequence=\"1\" Default=\"FALSE\" /><CalendarViewStyle Title=\"Week\" Type=\"week\" Template=\"CalendarViewweekChrome\" Sequence=\"2\" Default=\"FALSE\" /><CalendarViewStyle Title=\"Month\" Type=\"month\" Template=\"CalendarViewmonthChrome\" Sequence=\"3\" Default=\"TRUE\" />",
        "Query": "",
        "Paged": true,
        "PersonalView": false,
        "RowLimit": 0
    }
}
"@

    Invoke-PnPSPRestMethod -Method Post -Url "$url/_api/web/lists/GetByTitle('$listname')/Views/Add" -ContentType "application/json;odata=verbose" -Content $viewCreationJson

    #Optional Commands
    Set-PnPList -Identity $listname -ListExperience NewExperience # Set list experience to force the list to display in Modern
    Set-PnPView -List $listname -Identity $newViewTitle -Values @{DefaultView = $true; MobileView = $true; MobileDefaultView = $true } #Set newly created view To Be Default
}

function New-AppRegistration {
    
    # Many of the automation scripts in this repo will use an app registration
    # Use the following instructions and script to help automate this
    # The script will prompt you for the tenant username and password in the Connect-AzureAD step

    # Run in the terminal window with: ./CreateAppRegistration.ps1
    # Be sure to look for the authentication window that pops up behind VS Code
    # Once complete, add the information to your env_config.json
    # Then navigate to https://admin.powerplatform.microsoft.com/environments and add the Application User

    # Install modules, elevate permissions, and connect
    Install-Module -Name AzureAD -Scope CurrentUser
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

    # prompt for credentials to the environment
    Connect-AzureAD 

    # Define app reg here (or leave as msgov)
    $appName = "msgov"
    $appURI = "https://msgov"
    $appReplyURLs = @($appURI)

    # Create the app
    if (!($myApp = Get-AzureADApplication -Filter "DisplayName eq '$($appName)'" -ErrorAction SilentlyContinue)) {
        $myApp = New-AzureADApplication -DisplayName $appName -ReplyUrls $appReplyURLs -PublicClient $false
    }

    # Register and create the secret
    $ClientSecret = New-AzureADApplicationPasswordCredential -ObjectId $myApp.ObjectId
    $ServicePrincipal = New-AzureADServicePrincipal -AppId $myApp.AppId
    $ServicePrincipal | Select-Object -Property DisplayName, AppId, ObjectId
    Write-Output "Client Secret: $($ClientSecret.Value)"
    Write-Output "Enter this information into a env_config.json file at the root of this project"

    Write-Output "Navigate to the Power Apps Environment and add the '$appName' Application User and assign a security role."
    Write-Output "https://admin.powerplatform.microsoft.com/environments"

}

function Connect-DataverseTenant {
    param(
        [string]$authProfile
    )

    Write-Host "Selecting authentication profile..."

    # Check if $authProfile is provided, otherwise prompt for it
    if (-not $authProfile) {
        Write-Host ""
        pac auth list
        $authProfile = Read-Host "Enter Tenant ID"
        pac auth select --index $authProfile
    }
    else {

        # # if auth profile provided, check the config file for custom settings
        # # else just use what was provided
        # $config = Get-Config
        # if ($null -ne $config -and $config.$authProfile) {
        #     Write-Host "Using configuration override for profile."
        #     $authProfile = $config.$authProfile
        # }

        # now connect
        pac auth select --name $authProfile
    }
}

function Connect-DataverseEnvironment {
    param(
        [string]$authProfile,
        [string]$envName
    )

    # if auth profile provided, connect to it
    if ($null -ne $authProfile -and "" -ne $authProfile) {
        Connect-DataverseTenant -authProfile $authProfile
    }
    # else if no auth profile was provided, use the current tenant

    Write-Host "Selecting environment..."

    # Check if $envName is provided, otherwise prompt for it
    if (-not $envName) {
        Write-Host ""
        pac org list
        $envName = Read-Host "Enter Environment Name"
    }
    pac org select --environment $envName
    Write-Host ""
}

function Get-ModuleFromIPType {
    param (
        [string]$ipType
    )

    $excludeFolders = "__pycache__", "Scripts"
    $projectRoot = "$PSScriptRoot\.."

    # Retrieve folder names, excluding the specified folders
    $folderNames = Get-ChildItem -Path "$projectRoot\$ipType" -Directory -Exclude $excludeFolders | Select-Object -ExpandProperty Name
    $module = Select-ItemFromList -choices $folderNames

    return $module
}

function Get-Config {
    # Try to read the configuration file
    try {
        $projectRoot = "$PSScriptRoot\.."
        $configPath = "$projectRoot\user.config"

        $config = Get-Content -Path $configPath -ErrorAction Stop | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to read or parse the config file at '$configPath': $_"
        return $null
    }

    return $config
}

function Get-DeploymentConfig {
    # Read the main deployment configuration file
    try {
        $projectRoot = "$PSScriptRoot\.."
        # $configPath = "$projectRoot\config.json"
        $configPath = "$projectRoot\.config\deployments.json"

        $config = Get-Content -Path $configPath -ErrorAction Stop | ConvertFrom-Json
        return $config
    }
    catch {
        Write-Error "Failed to read or parse the deployment config file at '$configPath': $_"
        return $null
    }
}

function Select-Deployment {
    # Get the deployment configuration
    $config = Get-DeploymentConfig
    if ($null -eq $config) {
        throw "Unable to load deployment configuration"
    }

    # Get available deployment names
    $deploymentNames = $config.Deployments.PSObject.Properties.Name

    Write-Host ""
    Write-Host "Available Deployments:"
    $selectedDeployment = Select-ItemFromList $deploymentNames

    return $config.Deployments.$selectedDeployment
}