Function ListOUTree ( $searchBase ) {
	$indent = $null
	For ( $indentCounter=1; $indentCounter -le $numIndents; $indentCounter++ ) {
		#$indent += "    "
		$indent += "|----"
	}

	$ouResults = Get-ADOrganizationalUnit -Filter * -SearchBase $searchBase -SearchScope OneLevel
	
	ForEach ( $orgUnit in $ouResults ) {
		Write-Output "$($indent)$($orgUnit.Name)"
		If ( (@(Get-ADOrganizationalUnit -Filter * -SearchBase $orgUnit.DistinguishedName -SearchScope OneLevel).Count) -gt 0 ) {
			$numIndents++
			ListOUTree $orgUnit.DistinguishedName
			$numIndents--
		}
	}
}

$numIndents = 1
Write-Output "royalad.scranton.edu"
ListOUTree "dc=royalad,dc=scranton,dc=edu"