$PSVersionTable.PSVersion #check the PowerShell version installed
Get-Module -Name Microsoft.Entra -ListAvailable # Getting the list of Entra ID Modules available
Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List
Install-Module -Name Microsoft.Entra -Repository PSGallery -Scope CurrentUser -Force -AllowClobber # Installing the Microsofft Entra module
Get-Module -Name Microsoft.Entra -ListAvailable # Validating if the Module got installed

Find-Module -Name "Microsoft.Entra*" -Repository PSGallery |
Where-Object { $_.Name -notmatch "beta" }

Get-InstalledModule -Name Microsoft.Entra* |
Where-Object { $_.Name -notmatch "Beta" } | Format-Table Name, Version, InstalledLocation -AutoSize

Connect-Entra -Scopes 'User.Read.All'
Get-EntraUser -Filter "userPrincipalName eq 'aarav.bairagi@mii.com'"
Install-module Microsoft.Graph
Get-Module -Name "*graph*"
Connect-MgGraph -Scopes "Group.ReadWrite.All"
Get-MgGroup -All

# Fetch the list of users in an Entra ID group and export into a .csv file
Get-EntraGroupMember -GroupId <<GroupId_value>> -All | Select-Object Id, DisplayName, '@odata.type' | Export-Csv -Path "C:\MiTek Project\AAD_APP_PowerBI_Creator.csv" -NoTypeInformation 

# Fetch the list of users, with their respective emails in an Entra ID group and export into a .csv file
Get-EntraGroupMember -GroupId <<GroupId_value>> -All | 
    ForEach-Object {
        $user = Get-EntraUser -UserId $_.Id
        [PSCustomObject]@{
            Id = $_.Id
            DisplayName = $_.DisplayName
            '@odata.type' = $_.'@odata.type'
            UserPrincipalName = $user.UserPrincipalName
            Mail = $user.Mail
        }
    } | Export-Csv -Path "C:\MiTek Project\Entra ID Group Users with Emails\AAD_APP_PowerBI_Viewer.csv" -NoTypeInformation

# Export the output of 'history' command of a PowerShell session into a text file
Get-History | ForEach-Object { $_.CommandLine } | Out-File -FilePath "C:\MiTek Project\PowerShell_History_commands_Entra_ID_Groups_&_Group_Users.txt"
