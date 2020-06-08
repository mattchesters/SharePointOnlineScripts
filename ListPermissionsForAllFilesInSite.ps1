$site = "https://tenant.sharepoint.com"

$installed = Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Version
if ($installed.Version -lt 3.21.2005.1){
    Write-Host "PnP Module Missing or Requires Update. Attempting now..."
    Install-Module SharePointPnPPowerShellOnline
}

Connect-PnPOnline -Url $site -UseWebLogin

$context = Get-PnPContext
$everyfile = Find-PnPFile -Match *
foreach($doc in $everyfile){
$file = Get-PnPFile -Url $doc.Url -AsListItem
        Get-PnPProperty -ClientObject $file -Property HasUniqueRoleAssignments, RoleAssignments

        if($file.HasUniqueRoleAssignments -eq $True) 
        {
            foreach($roleAssignments in $file.RoleAssignments )  
            {
                Get-PnPProperty -ClientObject $roleAssignments -Property RoleDefinitionBindings, Member

                $permission.LoginName = $roleAssignments.Member.LoginName
                $permission.LoginTitle = $roleAssignments.Member.Title
                $permission.PrincipalType = $roleAssignments.Member.PrincipalType.ToString()
                $permission.Permission = ""
                #Get the Permissions assigned to user 
                foreach ($RoleDefinition  in $roleAssignments.RoleDefinitionBindings) 
                { 
                    $permission.Permission = $permission.Permission + "," + $RoleDefinition.Name 
                }
            }
        }
        }
