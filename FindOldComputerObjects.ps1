Import-Module ActiveDirectory

$oneYearAgo = (Get-Date).AddDays(-365)
$adComputers = Get-ADComputer -Filter * -SearchBase "DC=royalad,DC=scranton,DC=edu" -Properties whenCreated,whenChanged | Where-Object { $_.DistinguishedName -NotLike "*,OU=EnterpriseServers,*" }
$oldComputers = $adComputers | Where-Object { $_.whenChanged -lt $oneYearAgo }
