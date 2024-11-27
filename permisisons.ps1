$NetworkPaths = @(
    "[REDACTED_PATH1]",
    "[REDACTED_PATH2]",
    "[REDACTED_PATH3]"
)

$Output = @()

foreach ($Path in $NetworkPaths) {
    Write-Host "Processing $Path..."
    
    $Folders = Get-ChildItem -Directory -Path $Path -Recurse -Force
    
    foreach ($Folder in $Folders) {
        try {
            $Acl = Get-Acl -Path $Folder.FullName
            
            foreach ($Access in $Acl.Access) {
                $Output += [pscustomobject]@{
                    "Network Path" = $Path
                    "Folder Name"  = $Folder.FullName
                    "Group/User"   = $Access.IdentityReference
                    Permissions    = $Access.FileSystemRights
                    Inherited      = $Access.IsInherited
                }
            }
        } catch {
            Write-Warning "Could not process $($Folder.FullName): $_"
            continue
        }
    }
}

$Output | Export-Csv -Path "[REDACTED_PATH]\FILENAME.CSV" -NoTypeInformation
Write-Host "Group ACL Data Has Been Saved to [REDACTED_PATH]\FILENAME.CSV"
