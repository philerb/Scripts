#Import the AzureAD module and connect to AzureAD

$GroupOwners = @()
$Groups = Get-AzureADGroup -All $true

ForEach ( $Group in $Groups ) {

    $Owners = $Group | Get-AzureADGroupOwner

    ForEach ( $Owner in $Owners ) {
        $GroupOwners += [PSCustomObject]@{
            GroupName = $Group.MailNickName
            GroupDisplayName = $Group.DisplayName
            GroupOwner = $Owner.UserPrincipalName
        }
    }
}