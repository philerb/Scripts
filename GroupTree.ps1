[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [String]$Group,
    [Switch]$ShowUsers,
    [Switch]$HideEmptyGroups
)

If ( $HideEmptyGroups) {
    If ( -not $ShowUsers ) {
        Write-Output "[INFO] Only listing group names that have users as members in their branch. This does not show all groups in the tree. To show the users, use the -ShowUsers flag."
    } Else {
        Write-Output "[INFO] Listing groups that have users as members in their branch, along with user information."
    }
    Write-Output ""
}

Import-Module ActiveDirectory

Function Indent {
	$indent = $null
	For ( $indentCounter=1; $indentCounter -le $numIndents; $indentCounter++ ) {
		$indent += "    "
	}
	Return $indent
}

Function GetGroupInfo ( $baseGroup ) {
	$group = Get-ADGroup $baseGroup -Properties Description
    $groupMembers = Get-ADGroupMember $baseGroup | Sort Name
    $groupMembersRecursive = Get-ADGroupMember $baseGroup -Recursive
    
    If ( -not ( $HideEmptyGroups -and ($groupMembersRecursive -eq $NULL) ) ) {
        Write-Output "$(Indent)$($group.Name)$(If ($group.Description -ne $NULL) { Write-Output "" ($($group.Description.ToUpper()))"" })"
    }
	
	If ( $groupMembers -ne $NULL ) {
        $memberGroups = $groupMembers | Where-Object { $_.objectClass -eq "group" }
        $memberUsers = $groupMembers | Where-Object { $_.objectClass -eq "user" }
        
        $numIndents++
        ForEach ( $memberGroup in $memberGroups ) {
                GetGroupInfo $memberGroup.SamAccountName
        }
        If ( $ShowUsers ) {
            $users = $memberUsers | Get-ADUser -Properties mail,uOfScr-PrimaryRole,uOfScr-LegacyUsername | Sort surname,givenname
            ForEach ( $user in $users ) {
                #$user = Get-ADUser $memberUser.SamAccountName -Properties mail,uOfScr-PrimaryRole
                Write-Output "$(Indent)$($group.Name)    $($user.SamAccountName)$(If ($user.surname -ne $NULL) { Write-Output ""    $($user.surname)    $($user.givenname)"" } Else { Write-Output "        " })    $(If ($user.Mail -ne $NULL) { Write-Output "" $($user.Mail)"" })    $(If ($user.'uOfScr-legacyUsername' -ne $NULL) { Write-Output ""$($user.'uOfScr-legacyUsername')"" })    $(If ($user.'uOfScr-PrimaryRole' -ne $NULL) { Write-Output ""$($user.'uOfScr-PrimaryRole')"" })"
            }
        }
        $numIndents--
    }
}

$numIndents = 0
GetGroupInfo $Group