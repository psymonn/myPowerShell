$admins = Get-LocalGroupMember administrators

foreach ($admin in $admins) { 
    Get-LocalUser -SID $admin.SID
}