#requires -version 2
<#
.SYNOPSIS
    CorrectDirectorySecurity sets correct ownership and security for all directory content.

    .DESCRIPTION
    <Brief description of script>

.PARAMETER DirectoryName
    The Directory Name

.INPUTS
    Directory Name

.OUTPUTS
    <Outputs if any, otherwise set "None" here>

.NOTES
    Version:        1.0
    Author:         Jens Torgeir Solaugsten
    Creation date:  04.20.2020
    Repository:     https://github.com/Sarpsborg-kommune/CorrectDirectorySecurity.git
    History:        04.20.2020: jTs - Initial script development
    
.EXAMPLE
    <Example(s) of script usage.>
#>
param([string]$DirectoryName)

Function SetAdministratorsOwnership($path = $pwd) {
    foreach ($item in Get-ChildItem $path)
    {
        $ACL = Get-Acl $item.FullName
        $Group = New-Object System.Security.Principal.NTAccount("Builtin","Administrators")
        $ACL.SetOwner($Group)
        Set-Acl -Path $item.FullName -AclObject $ACL

        if (Test-Path $item.FullName -PathType Container)
        {
            SetAdministratorsOwnership $item.FullName
        }
    }
}

Write-Host $DirectoryName
SetAdministratorsOwnership ($DirectoryName)
