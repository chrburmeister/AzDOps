Function New-AzDoProject {
    <#
    .SYNOPSIS
        Creates a new Azure DevOps project.
    .DESCRIPTION
        Creates a new Azure DevOps project.
    .PARAMETER Name
        Name of the new Azure DevOps Project.
    .PARAMETER TemplateName
        Specifies the template to use.
    .PARAMETER Description
        Project description.
    .PARAMETER VersionControlType
        Specifies the version control to use in the Azure DevOps project to be created.
    .PARAMETER APIVersion
        Specifies the API version which is used to query the Azure DevOps API.
    .EXAMPLE
        New-AzDoProject -Name "Application" -TemplateName "scrum" -Description "project for new application" -VersionControlType "git"
    .EXAMPLE
        New-AzDoProject -Name "Application" -TemplateName "agile" -Description "project for new application" -VersionControlType "tfvc"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][String]$Name,
        [Parameter(Mandatory = $true)][String]$TemplateName,
        [Parameter(Mandatory = $false)][String]$Description,
        [Parameter(Mandatory = $false)][String][ValidateSet("Git","tfvc")]$VersionControlType = "Git",
        [Parameter(Mandatory = $false)][String]$APIVersion = "5.0-preview.3"
    )

    if(-not($AzDOpsModuleConnectionStatus)){
        throw "No active Azure DevOps connection - use the 'Connect-AzDo' cmdlet to connect first"
    }

    $uri = "$AzDOpsModuleBaseUrl/_apis/projects?api-version=$APIVersion"

    try{
        $Templates = Get-AzDoProcesses -ErrorAction Stop
    }catch{
        throw "$($($_.Exception).Message)"
    }

    $TemplateID = $Templates | Where-Object {$_.name -eq $TemplateName} | Select-Object -ExpandProperty id
    if(-not($TemplateID)){
        throw "Could not find template '$($TemplateName)' - run the Get-AzDoProcesses cmdlet to identify the correct name"
    }

    $body = @{
        "name" = $name
        "description" = $description
        "capabilities" = @{
            "versioncontrol" = @{
                "sourceControlType" = $versionControlType
            }
            "processTemplate" = @{
                "templateTypeId" = $templateID
            }
        }
    }

    $restParam = @{
        "URI" = $uri
        "Headers" = $AzDOpsModuleAuthHeader
        "Method" = "POST"
        "ContentType" = "application/json"
        "Body" = (ConvertTo-Json -InputObject $body)
        "ErrorAction" = "Stop"
    }

    try{
        $Response = Invoke-RestMethod @restParam
        Write-Verbose "added entry to project cache"
        Return $Response
    }catch{
        throw "$($($_.Exception).Message)"
    }
}